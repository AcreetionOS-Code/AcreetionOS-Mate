#!/bin/bash

# AcreetionOS MATE Build Versioning System
# Generates semantic version with automatic build numbers
# Format: {version}.{major}.{minor}.{build}+{metadata}

set -euo pipefail

# Source the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Configuration
VERSION_FILE=".buildversion"
TIMESTAMP=$(date -u +'%Y-%m-%d %H:%M:%S UTC')
TIMESTAMP_SHORT=$(date -u +'%Y%m%d%H%M')
GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_COMMIT_FULL=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
GIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo "0")
ARCH="${ARCH:-x86_64}"

# Parse current version
parse_version() {
  # Try to get version from most recent tag
  TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
  
  if [[ -n "$TAG" ]]; then
    # Extract version from tag (v1.0-mate.1 -> 1.0)
    VERSION=$(echo "$TAG" | sed 's/^v//; s/-mate.*//')
  else
    VERSION="1.0.0"
  fi
  
  echo "$VERSION"
}

# Get or initialize build number
get_build_number() {
  if [[ -f "$VERSION_FILE" ]]; then
    cat "$VERSION_FILE"
  else
    # Start at 1
    echo "1"
  fi
}

# Increment build number
increment_build() {
  local current=$(get_build_number)
  echo $((current + 1))
}

# Generate semantic version
generate_semver() {
  local version=$(parse_version)
  local build=$(get_build_number)
  local metadata="${GIT_BRANCH}+${GIT_COMMIT}"
  
  echo "${version}.${build}+${metadata}"
}

# Generate full build info
generate_build_info() {
  local version=$(parse_version)
  local build=$(get_build_number)
  local semver=$(generate_semver)
  
  cat > airootfs/etc/acreetion-build-version << EOF
# AcreetionOS MATE Build Information
# Generated: ${TIMESTAMP}

VERSION_BASE=${version}
VERSION_MAJOR=1
VERSION_MINOR=0
VERSION_BUILD=${build}
VERSION_SEMVER=${semver}

BUILD_NUMBER=${GIT_COUNT}
BUILD_COMMIT=${GIT_COMMIT}
BUILD_COMMIT_FULL=${GIT_COMMIT_FULL}
BUILD_BRANCH=${GIT_BRANCH}
BUILD_TIMESTAMP=${TIMESTAMP}
BUILD_TIMESTAMP_UNIX=$(date +%s)
BUILD_ARCHITECTURE=${ARCH}

# Full version string for display
DISPLAY_VERSION="AcreetionOS MATE ${version}-build.${build}"
ISO_NAME="AcreetionOS-MATE-${version}-${build}-${ARCH}.iso"
EOF

  # Also update the classic build-info file
  cat >> airootfs/etc/acreetion-build-info << EOF

# Build Versioning Information
BUILD_VERSION_SEMVER=${semver}
BUILD_VERSION_FULL=${version}.${build}
BUILD_GIT_COUNT=${GIT_COUNT}
EOF
}

# Generate git tag for this build
generate_git_tag() {
  local version=$(parse_version)
  local build=$(get_build_number)
  
  echo "v${version}-mate.${build}"
}

# Create deterministic build hash
generate_build_hash() {
  # Hash of: version + build + timestamp + commit + arch
  local version=$(parse_version)
  local build=$(get_build_number)
  
  echo -n "AcreetionOS-MATE-${version}.${build}-${ARCH}-${GIT_COMMIT}" | sha256sum | cut -d' ' -f1 | cut -c1-16
}

# Print build information
print_build_info() {
  local version=$(parse_version)
  local build=$(get_build_number)
  local semver=$(generate_semver)
  local buildhash=$(generate_build_hash)
  local tag=$(generate_git_tag)
  
  cat << EOF
╔════════════════════════════════════════════════════════════╗
║          AcreetionOS MATE Build Version Info               ║
╚════════════════════════════════════════════════════════════╝

Version Information:
  Base Version:        ${version}
  Build Number:        ${build}
  Git Commit Count:    ${GIT_COUNT}
  Semantic Version:    ${semver}
  Full Version:        ${version}.${build}

Git Information:
  Commit (short):      ${GIT_COMMIT}
  Commit (full):       ${GIT_COMMIT_FULL}
  Branch:              ${GIT_BRANCH}
  Tag:                 ${tag}

Build Environment:
  Architecture:        ${ARCH}
  Timestamp:           ${TIMESTAMP}
  Build Hash:          ${buildhash}

Generated Files:
  Version File:        airootfs/etc/acreetion-build-version
  ISO Name:            AcreetionOS-MATE-${version}-${build}-${ARCH}.iso

╚════════════════════════════════════════════════════════════╝
EOF
}

# Main execution
main() {
  echo "🔢 Generating build version..."
  
  # Create version file if it doesn't exist
  if [[ ! -f "$VERSION_FILE" ]]; then
    echo "0" > "$VERSION_FILE"
  fi
  
  # Generate build information
  generate_build_info
  
  # Print version info
  print_build_info
  
  # Output version for use in CI/CD
  local version=$(parse_version)
  local build=$(get_build_number)
  
  echo ""
  echo "Export these for CI/CD:"
  echo "  export BUILD_VERSION=${version}"
  echo "  export BUILD_NUMBER=${build}"
  echo "  export BUILD_SEMVER=$(generate_semver)"
  echo "  export BUILD_GIT_TAG=$(generate_git_tag)"
  echo "  export BUILD_HASH=$(generate_build_hash)"
  echo "  export ISO_NAME=AcreetionOS-MATE-${version}-${build}-${ARCH}.iso"
}

# Allow external calls
case "${1:-}" in
  version)
    parse_version
    ;;
  build)
    get_build_number
    ;;
  increment)
    increment_build
    ;;
  semver)
    generate_semver
    ;;
  tag)
    generate_git_tag
    ;;
  hash)
    generate_build_hash
    ;;
  info)
    print_build_info
    ;;
  *)
    main
    ;;
esac

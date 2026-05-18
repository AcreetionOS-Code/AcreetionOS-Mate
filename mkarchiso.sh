export PACMAN_OPTS="--overwrite '*'"
/usr/bin/mkarchiso -L AcreetionOS -v -o ../ISO . -C ./pacman.conf

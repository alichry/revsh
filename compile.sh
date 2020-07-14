#!/bin/sh

set -e

oldpwd="${PWD}"

onexit () {
	cd "${oldpwd}"
}

start () {
	echo "You're now in a containerized session. Run revsh -h for more info.
Additionally, You can  copy the compiled binary by executing:
    $ docker exec CONTAINER_NAME cat /usr/local/bin/revsh > revsh
on your docker host while the container is running. If it's not, start it with:
    $ docker start CONTAINER_NAME
Replace CONTAINER_NAME with the container name you specified in docker run."
	sh
	exit $?
}

trap onexit EXIT

if [ -d ~/.revsh ]; then
	echo "revsh is already built, not compiling again."
else
	cd ~/build/revsh
	make clean
	make
	make install
fi


start

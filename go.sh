#!/bin/bash
#

# sudo docker run -it --rm -v "$(pwd):/code" -w "/code" -e "HOME=/tmp" -u $UID:$GID -p 8888:8000 hendrik/docker-elm go "$@"


# -p 8888:8000

sudo docker run \
	-it --rm \
	-v "$(pwd):/code" \
	-w "/code" \
	-e "HOME=/tmp" \
	-u $(id -u):$(id -g) \
	hendrik/docker-elm \
	go "$@"

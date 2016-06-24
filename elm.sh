#!/bin/bash
#

# alias elm='docker run -it --rm -v "$(pwd):/code" -w "/code" -e "HOME=/tmp" -u $UID:$GID -p 8000:8000 codesimple/elm:0.17'


# sudo docker run -it --rm -v "$(pwd):/code" -w "/code" -e "HOME=/tmp" -u $UID:$GID -p 8888:8000 hendrik/docker-elm elm "$@"

sudo docker run \
	-it --rm \
	-v "$(pwd):/code" \
	-w "/code" \
	-e "HOME=/tmp" \
	-u $(id -u):$(id -g) \
	-p 8888:8000 \
	hendrik/docker-elm \
	elm "$@"

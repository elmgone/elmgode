#!/bin/bash
#

# -p 8888:8000
sudo docker run \
	-it --rm \
	-v "$(pwd):/code" \
	-w "/code" \
	-e "HOME=/tmp" \
	-u $(id -u):$(id -g) \
	elmgone/elmgode \
	go "$@"


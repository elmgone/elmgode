#!/bin/bash
#

sudo docker run \
	-it --rm \
	-v "$(pwd):/code" \
	-w "/code" \
	-e "HOME=/tmp" \
	-u $(id -u):$(id -g) \
	-p 8888:8000 \
	elmgone/elmgode \
	elm "$@"

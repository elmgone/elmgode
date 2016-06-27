#!/bin/bash
#
# build the docker image
#

if [ "XX$http_proxy" != "XX" ] ; then
PROXY="--build-arg HTTP_PROXY=$http_proxy \
	--build-arg http_proxy=$http_proxy \
	--build-arg HTTPS_PROXY=$http_proxy \
	--build-arg https_proxy=$http_proxy"
fi

sudo docker build -t elmgone/elmgode $PROXY  . || exit 17


[ -d elmgode-tools ] || mkdir elmgode-tools
LT="-v $(pwd)/elmgode-tools:/elmgode-tools"


# exit 0
#	-v "$(pwd)/elmgode-tools:/local-tools" \


[ -d elmgode-tools ] || mkdir elmgode-tools
if sudo docker run \
	-it --rm \
	$LT \
	-e "HOME=/tmp" \
	-u $(id -u):$(id -g) \
	elmgone/elmgode \
	bash -xc "[ -d /elmgode-tools ] && cp /go/bin/gopath /go/bin/windows_amd64/gopath.exe /elmgode-tools" ; then

	echo "SUCCESS!!  please make sure the tools in the folder elmgode-tools are in your PATH"
	echo
	cp go.sh elmgode-tools
	file elmgode-tools/*

else
	echo "FAILED."
fi

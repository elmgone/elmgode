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

USER_IDs="--build-arg UserID=$(id -u) --build-arg GroupID=$(id -g)"

echo "building docker image ..."
if sudo docker build -t elmgone/elmgode $PROXY $USER_IDs . ; then
	echo "done."
else
	echo "FAILED. ABORT."
	exit 29
fi


LT="-v $(pwd)/elmgode-tools:/elmgode-tools"

[ -d elmgode-tools ] && rm -rf elmgode-tools
mkdir elmgode-tools || exit 23

echo "copying helper tools from docker image ..."
if sudo docker run \
	-it --rm \
	$LT \
	-e "HOME=/tmp" \
	-u $(id -u):$(id -g) \
	elmgone/elmgode \
	bash -c "[ -d /elmgode-tools ] && cp /go/bin/gopath /go/bin/windows_amd64/gopath.exe /elmgode-tools" ; then

	echo "SUCCESS!!  please make sure the tools in the local folder 'elmgode-tools' are in your PATH"
	echo
	cp eg.sh elmgode-tools
	file elmgode-tools/*

else
	echo "FAILED."
	exit 27
fi


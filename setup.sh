#!/bin/bash
#
# build the docker image
#

if docker version ; then :
else
	SUDO=sudo
fi

if [ "XX$http_proxy" != "XX" ] ; then
PROXY="--build-arg HTTP_PROXY=$http_proxy \
	--build-arg http_proxy=$http_proxy \
	--build-arg HTTPS_PROXY=$http_proxy \
	--build-arg https_proxy=$http_proxy"
fi

USER_IDs="--build-arg UserID=$(id -u) --build-arg GroupID=$(id -g)"

echo "building base docker image ..."
if $SUDO docker build -f Dockerfile.DE -t elmgone/elmgode $PROXY $USER_IDs . ; then
	echo "done."
else
	echo "FAILED. ABORT."
	exit 29
fi

echo "building extended docker image ..."
if $SUDO docker build -f Dockerfile.DEX -t elmgone/elmgodex $PROXY $USER_IDs . ; then
	echo "done."
else
	echo "FAILED. ABORT."
	exit 29
fi


LT="-v $(pwd)/elmgode-tools:/elmgode-tools"

[ -d elmgode-tools ] && rm -rf elmgode-tools
mkdir elmgode-tools || exit 23

echo "copying helper tools from docker image ..."
if $SUDO docker run \
	-it --rm \
	$LT \
	-e "HOME=/tmp" \
	-u $(id -u):$(id -g) \
	elmgone/elmgodex \
	bash -c "[ -d /elmgode-tools ] && cp /go/bin/egde /elmgode-tools" ; then

	## bash -c "[ -d /elmgode-tools ] && cp /go/bin/gopath /go/bin/windows_amd64/gopath.exe /elmgode-tools" ; then

	cat eg.sh | sed "s/# SUDO=sudo/SUDO=$SUDO/" > elmgode-tools/eg.sh || exit 31
	chmod a+x elmgode-tools/*                                         || exit 32
	echo
	echo "SUCCESS!!  please make sure the tools in the local folder 'elmgode-tools' are in your PATH"
	echo
	file elmgode-tools/*

else
	echo "FAILED."
	exit 27
fi


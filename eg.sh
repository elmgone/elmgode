#!/bin/bash
#

# GOBASE=$(gopath --base) || exit 13
# GOPKG=$(gopath --package) || exit 14

if which gopath > /dev/null; then :
else
	echo "Please make sure the gopath tool created by elmgode/setup.sh is in your PATH!"
	exit 23
fi

if [ "XX$http_proxy" != "XX" ] ; then
PROXY="-e HTTP_PROXY=$http_proxy \
	-e http_proxy=$http_proxy \
	-e HTTPS_PROXY=$http_proxy \
	-e https_proxy=$http_proxy"
fi

V1="-v $(pwd):/elm-src"
if GOBASE=$(gopath --base) && GOPKG=$(gopath --package) ; then
	V2="-v $GOBASE:/go"
	W="-w /go/src/$GOPKG"
else
	W="-w /elm-src"
fi


# -p 8888:8000
#	-w "$WD"
sudo docker run \
	-it --rm \
	$V1 $V2 $W \
	-e "HOME=/tmp" \
	$PROXY \
	-u $(id -u):$(id -g) \
	elmgone/elmgode \
	"$@"


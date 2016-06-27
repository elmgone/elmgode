#!/bin/bash
#

# GOBASE=$(gopath --base) || exit 13
# GOPKG=$(gopath --package) || exit 14

if GOBASE=$(gopath --base) && GOPKG=$(gopath --package) ; then
	# V1="-v $(pwd):/code"
	V2="-v $GOBASE:/go"
	W="-w /go/src/$GOPKG"
fi


# -p 8888:8000
#	-w "$WD"
sudo docker run \
	-it --rm \
	$V1 $V2 $W \
	-e "HOME=/tmp" \
	-u $(id -u):$(id -g) \
	elmgone/elmgode \
	"$@"


#!/bin/bash
#

# SUDO=sudo

if which egde > /dev/null; then :
else
	echo "Please make sure the 'egde' tool created by elmgode/setup.sh is in your PATH!"
	exit 23
fi

if [ "XX$http_proxy" != "XX" ] ; then
PROXY="-e HTTP_PROXY=$http_proxy \
	-e http_proxy=$http_proxy \
	-e HTTPS_PROXY=$http_proxy \
	-e https_proxy=$http_proxy"
fi

if echo "$*" | grep -e "^elm " > /dev/null ; then
	V="-v $(pwd):/elm-src"
	W="-w /elm-src"
else
	if GOBASE=$(egde gopath --base) && GOPKG=$(egde gopath --package) ; then
		V="-v $GOBASE:/go"
		W="-w /go/src/$GOPKG"
	else
		echo "Please make sure your source code is in the current directory and is in a proper Go workspace and the GOPATH environment variable is set correctly"
		exit 29
	fi
fi

# V1="-v $(pwd):/elm-src"
# if GOBASE=$(gopath --base) && GOPKG=$(gopath --package) ; then
# 	V2="-v $GOBASE:/go"
# 	W="-w /go/src/$GOPKG"
# else
# 	W="-w /elm-src"
# fi


# -p 8888:8000
#	-p 6080:8000 \
#	-p 6060:6060 \
#	-w "$WD"
#	$V1 $V2 $W \

if echo "$*" | grep -e elm | grep -e reactor > /dev/null ; then
	PORTS="$PORTS $(egde port 8000)"
fi
if echo "$*" | grep -e go | grep -e doc | grep -e '-http=:' > /dev/null ; then
	godocPort=$(echo "$*" | sed -e 's/.*-http=://' -e 's/[^0-9]*//')
	PORTS="$PORTS $(egde port $godocPort)"
fi

$SUDO docker run \
	-it --rm \
	$V $W \
	-e "HOME=/tmp" \
	$PROXY \
	$PORTS \
	-u $(id -u):$(id -g) \
	elmgone/elmgodex \
	"$@"


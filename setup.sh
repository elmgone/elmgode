#!/bin/bash
#
# build the docker image
#

DOCKER_IMAGE_BASE="elmgone/elmgode"
DOCKER_IMAGE_ENV="elmgone/elmgodex"
DOCKER_IMAGE_FINAL="elmgone/elmgodex1"

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
if $SUDO docker build -f Dockerfile.DE -t "$DOCKER_IMAGE_BASE" $PROXY $USER_IDs . ; then
	echo "done."
else
	echo "FAILED. ABORT."
	exit 29
fi

echo "building extended docker image ..."
if $SUDO docker build -f Dockerfile.DEX -t "$DOCKER_IMAGE_ENV" $PROXY $USER_IDs . ; then
	echo "done."
else
	echo "FAILED. ABORT."
	exit 29
fi

echo "building playground docker image ..."
if $SUDO docker build -f Dockerfile.TRY -t "$DOCKER_IMAGE_FINAL" $PROXY $USER_IDs . ; then
	echo "done."
else
	echo "FAILED. ABORT."
	exit 29
fi

TOOLS_DIR="$(pwd)/elmgode-tools"
LT="-v $TOOLS_DIR:/elmgode-tools"

[ -d "$TOOLS_DIR" ] && rm -rf "$TOOLS_DIR"
mkdir "$TOOLS_DIR" || exit 23

echo "copying helper tools from docker image ..."
if $SUDO docker run \
	-it --rm \
	$LT \
	-e "HOME=/tmp" \
	-u $(id -u):$(id -g) \
	"$DOCKER_IMAGE_ENV" \
	bash -c "[ -d /elmgode-tools ] && cp /go/bin/egde /elmgode-tools" ; then

	## bash -c "[ -d /elmgode-tools ] && cp /go/bin/gopath /go/bin/windows_amd64/gopath.exe /elmgode-tools" ; then

	echo " ... done."
else
	echo "FAILED."
	exit 27
fi

cat eg.sh | sed "s/# SUDO=sudo/SUDO=$SUDO/" > "$TOOLS_DIR/eg.sh" || exit 31
chmod a+x "$TOOLS_DIR"/*                                         || exit 32

export PATH="$TOOLS_DIR:$PATH"

echo "#"
echo "# the following tools are available for you now:"
echo "#"

export GOPATH=/tmp/elmgode/test-$$/go
DIR="$GOPATH/src/trial"
if mkdir -p "$DIR" && cd "$DIR" ; then :
else
	echo "FAILED to create and use test folder! ABORT."
	exit 47
fi

echo
echo "### go tools ###"
# set -x
eg.sh go version
echo
eg.sh gvt help
echo
eg.sh cobra help
echo
eg.sh ego --version
echo

echo
echo "### elm tools ###"
eg.sh elm make --version
echo
eg.sh elm package --help
echo
echo "elm repl"
eg.sh elm repl --version
echo
# eg.sh elm reactor --version

echo
echo "### PureScript tools ###"
# echo "psc # PureScript compiler"
eg.sh psc --help
echo
eg.sh pulp --help
# set +x

echo
echo "SUCCESS!!  please make sure the tools in the local folder 'elmgode-tools' are in your PATH"
echo
file "$TOOLS_DIR"/*


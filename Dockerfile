# FROM ubuntu
FROM golang

#
# setup Elm environment
#

# install npm
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update
RUN apt-get install -y nodejs

# install elm
RUN npm install -g elm

# open port for elm reactor
EXPOSE 8000

# ENTRYPOINT [ "elm" ]

#
# setup Go environment
#

WORKDIR /go/src

# add a helper tool written in Go
ADD gopath gopath
RUN go install gopath
RUN GOOS=windows GOARCH=amd64 go install gopath

# add a vendoring tool written in Go
RUN go get github.com/FiloSottile/gvt
RUN go install github.com/FiloSottile/gvt

# copy all the helper binaries onto the PATH
##RUN cp /go/bin/* /usr/local/bin

##RUN [ -d /local-tools ] && cp /go/bin/gopath /go/bin/windows_amd64/gopath.exe /local-tools

# open port for go doc
EXPOSE 6060

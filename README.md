# ElmGoDE

*development environment for Elm and Go using a docker container*

## Introduction

The most popular way to implement a user interface for [Go](http://golang.org) programs seems to be the Web UI. I.e. the actual functionality is created inside a Go http server which presents the GUI with the help of a web browser.
Instead of programming the GUI logic directly in Javascript I prefer the statically typed functional language [Elm](http://elm-lang.org).

The docker container maintained in this project enables you to build your Go binaries and your Elm Web UI on your 64bit Linux machine without having to install Go or Elm.

## Usage

1. setup a development machine with a 64bit linux (if you don't have one)
2. install [docker](https://docs.docker.com/engine/installation) (1.9.1+) and [git](https://git-scm.com/download/linux)
3. clone the elmgode repository: git clone https://github.com/elmgone/elmgode
4. cd elmgode
5. run ./setup.sh
6. make sure the tools created in ./elmgode-tools are copied in a folder which is in the PATH
7. cd to your project folder which should be inside your GOPATH folder
8. run eg.sh with some go or elm tools, e.g.:
   * eg.sh go version
   * eg.sh elm make --version

## Tools

There is a wrapper script **eg.sh** for using the tools in the docker container. Just prepend the go or elm command lines by it.

### Go Development Tools

1. the [**go** tool](https://golang.org/doc/articles/go_command.html) for building, testing, etc.
2. [**gvt**](https://github.com/FiloSottile/gvt) for vendoring
3. [**ego**](https://github.com/benbjohnson/ego) for (Html) templating
4. [**cobra**](https://github.com/spf13/cobra) for CLI's

### Elm Development Tools

1. the [**elm** tool](http://elm-lang.org/get-started) including *make*, *package*, *repl* and *reactor* for building the Web UI


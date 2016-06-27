# ElmGoDE

*development environment for Elm and Go using a docker container*

## Introduction

The most popular way to implement a user interface for [Go](http://golang.org) programs seems to be the Web UI. I.e. the actual functionality is created inside a Go http server which presents the GUI with the help of a web browser.
Instead of programming the GUI logic directly in Javascript I prefer the statically typed functional language [Elm](http://elm-lang.org).

The docker container maintained in this project enables you to build your Go binaries and your Elm Web UI on your 64bit Linux machine without having to install Go or Elm.

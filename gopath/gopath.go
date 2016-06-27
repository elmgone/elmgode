//	The MIT License (MIT)
//
//	Copyright (c) 2016 elmgone
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.

package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
)

var (
	base  = flag.Bool("base", false, "print the common string of the current working folder and the GOPATH")
	pkg   = flag.Bool("package", false, "print the go package name of the current working folder in the GOPATH")
	debug = flag.Bool("debug", false, "print some debug log messages")
)

func main() {
	flag.Parse()
	gp := splitGoPath()
	if len(gp) == 0 {
		os.Exit(42)
	}
	if *base {
		fmt.Println(gp[0])
		return
	}
	if *pkg {
		if len(gp) < 2 {
			fmt.Fprintln(os.Stderr, "must be in a subfolder of $GOPATH/src to get a valid go package name")
			os.Exit(43)
		}
		fmt.Println(gp[1])
		return
	}
	fmt.Fprintln(os.Stderr, "usage: gopath (-base|-package) [options]")
	flag.Usage()
	os.Exit(41)
}

func splitGoPath() []string {
	goPath_s := os.Getenv("GOPATH")
	if goPath_s == "" {
		fmt.Fprintln(os.Stderr, "GOPATH env var must be set")
		return nil
	}
	wd, err := os.Getwd()
	if err != nil {
		panic(err)
	}
	ret := make([]string, 0, 2)
	goPath := ""
	goPath_l := strings.Split(goPath_s, ":")
	for _, goPath = range goPath_l {
		goPathPrefix := filepath.Join(goPath, "src")
		if strings.HasPrefix(wd, goPathPrefix) {
			if *debug {
				log.Printf("gopath='%s'\n", goPath)
			}
			ret = append(ret, goPath)
			break
		}
	}
	if len(ret) == 0 {
		fmt.Fprintln(os.Stderr, "not in a subfolder of $GOPATH/src")
		return nil
	}
	if *debug {
		log.Printf("wd='%s', len(wd)=%d, goPath='%s', len(goPath)=%d\n",
			wd, len(wd), goPath, len(goPath))
	}

	goPathBaseLen := len(goPath) + 1 + 4
	if len(wd) <= goPathBaseLen {
		fmt.Fprintln(os.Stderr, "not in a subfolder of $GOPATH/src")
		return ret
	}

	goPkg := wd[goPathBaseLen:]
	ret = append(ret, goPkg)
	return ret
}

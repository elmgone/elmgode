package main

import (
	"flag"
	"fmt"
	//	"log"
	"os"
	"path/filepath"
	"strings"
)

var (
	base = flag.Bool("base", false, "print the common string of the current working folder and the GOPATH")
	pkg  = flag.Bool("package", false, "print the go package name of the current working folder in the GOPATH")
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
	fmt.Fprintln(os.Stderr, "usage: gopath (-base|-package)")
	os.Exit(41)
}

func splitGoPath() []string {
	goPath_s := os.Getenv("GOPATH")
	if goPath_s == "" {
		fmt.Fprintln(os.Stderr, "GOPATH env var must be set")
		//		os.Exit(-1)
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
			//			return goPath
			//			log.Printf("gopath='%s'\n", goPath)
			ret = append(ret, goPath)
			break
		}
	}
	//	if goPath == "" {
	if len(ret) == 0 {
		fmt.Fprintln(os.Stderr, "not in a subfolder of $GOPATH/src")
		return nil
	}
	//	log.Printf("wd='%s', len(wd)=%d, goPath='%s', len(goPath)=%d\n",
	//		wd, len(wd), goPath, len(goPath))

	//	goPkg := goPath[len(wd)+1:]
	goPathBaseLen := len(goPath) + 1 + 4
	if len(wd) <= goPathBaseLen {
		fmt.Fprintln(os.Stderr, "not in a subfolder of $GOPATH/src")
		return ret
	}

	goPkg := wd[goPathBaseLen:] //-- goPath[len(wd)+1:]
	ret = append(ret, goPkg)
	return ret
}

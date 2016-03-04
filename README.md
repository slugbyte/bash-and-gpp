Writing better bash with gpp
============================

# Preface
I love the `$SHELL`. I've been trying to _"exclusivly"_ use it to operate my computer for about three years. This switch came about when I decited that I wanted to take becoming a _programmer_ seriousally. The more I use it the more I fall in love. During this time I have spent a lot of time _dev'ing_  in **javascript**, **c**, **swift**, and **objective-c**. I have meet some amazing _developers_, [toastynerd](https://github.com/toastynerd), [michaelbabiy](https://github.com/michaelbabiy), [cadbot](https://github.com/cadbot), [brookr](https://github.com/brookr), and [krew](https://github.com/slugbyte/following).  
  
Some of the main things that Ive taken away from the last fiew years are the benifits of **modularization**, and **testing**. _Package managers_ aside, the idea of coding with out some way to `#import a-file` or `require('a-file');` makes my head hurt. Debuging a 500+ line file scares me, and I dont even want to think about Debuging a 5,000+, or 15,000 + line file.   
  
All week I've been spending my free time, trying to find a solution to writing more modular `$SHELL` scripts. I mostly came up with a pile of super sketchy hacks that wreeked of [code smell](https://en.wikipedia.org/wiki/Code_smell). Eventually I decited that I had no reason to re-solve a problem that has allready been solved, really well. I just needed a preprocessor that wasnt biased about the _language_ or _content_ of my code. I needed [general-purpose preprocessor](http://en.nothingisreal.com/wiki/GPP) **(_gpp_)**. 

# Poof Of Concept Overview
* Write a test for a function that does not exit and fail it, but will be imported with gpp.
* Run the test that make sure the test fails.
* Write a function to pass the test.
* Write a program that imports that test with gpp and puts it to good use.

# Getting Started
### Setup
* Create a new directory for this project `mkdir bash-and-gpp && cd bash-and-cpp`.
* Create lib and test directorys for organizing scripts   `mkdir lib test`.  
* Create an empty file _lib/say-hello.sh_ that we will be writing a code in later  `touch lib/say-hello.sh`.  
* Create a new empty file called 
* `#import say-hello.sh` into a **say-hello-test.sh**.
* Write a `sayHelloTest` function that will test `sayHello` with and without input. Log output regarding the results of your tests.
* Write a `sayHello` **fucnction** that will `echo "hello, $1"` if input is provided or `echo "hello, world"` if no input is provided. Store this function in its own file called **say-hello.sh**. 

* `#import say-hello.sh` into a file called **main.sh** and invoke `sayHello` with the first argument of arv `"$1"`.
* 

```
/
├── helloworld.sh         ----> final product
├── lib                   ----> dir for scripts that will provide specific functionality to your program. 
│   └── say-hello.sh      ----> the script with the function sayHello 
├── main.sh               ----> the script that is the entry point for gpp, for the main program.
├── makefile              ----> makefile with tasks for running tests and building helloworld.sh
└── test                  ----> dir for scripts that will test scripts in /lib
    ├── all-test.sh       ----> the script that is the entry point for gpp, for running tests.
    └── say-hello-test.sh ----> the script with the function sayHelloTest
```
  
**/helloworld.sh**  
``` sh  
#!/bin/bash

function sayHello(){
  local name="$1"
  [ "$name" ] || name="world"
  echo "hello, $name"
}

sayHello $1
```  
##/lib  
**/lib/say-hello.sh**  
``` sh  
#ifndef SAY_HELLO
#define SAY_HELLO
function sayHello(){
  local name="$1"
  [ "$name" ] || name="world"
  echo "hello, $name"
}
#endif
```  
**/main.sh**  
``` sh  
#!/bin/bash

#include "say-hello.sh"

#ifndef MAIN
#define MAIN
sayHello $1
#endif
```  
**/makefile**  
``` txt  
all:
	gpp main.sh -I ./lib -o helloworld.sh
	chmod 755 helloworld.sh

t: 
	gpp ./test/all-test.sh -I ./lib -I ./test -o run-me-test.sh
	chmod 755 run-me-test.sh
	./run-me-test.sh
	rm ./run-me-test.sh
```  
##/test  
**/test/all-test.sh**  
``` sh  
#!/bin/bash

#include "say-hello-test.sh"

#ifndef ALL_TEST
#define ALL_TEST
sayHelloTest
#endif
```  
**/test/say-hello-test.sh**  
``` sh  
#include "say-hello.sh"

#ifndef TEST_SAY_HELLO
#define TEST_SAY_HELLO
function sayHelloTest(){
  local tab="    "
  local tab2="        "
  echo "testing say-hello.sh"
  echo "${tab}sayHello with no args should return 'hello, world'"

  result=$(sayHello)  
  if [ "$result" = "hello, world" ];then 
    echo "${tab2}success"
  else 
    echo "${tab2}failure"
  fi

  echo "    sayHello with args should return 'hello, slug neo'"
  result=$(sayHello "slug neo")  
  if [ "$result" = "hello, slug neo" ];then 
    echo -e "${tab2}success"
  else 
    echo -e "${tab2}failure"
  fi
}
#endif
```  

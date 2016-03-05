Writing shell scripts with gpp
==============================

# Preface
I love the `$SHELL`. I've been trying to _"exclusivly"_ use it to operate my computer for about three years. This switch came about when I decited that I wanted to take becoming a _programmer_ seriousally. The more I use it the more I fall in love. During this time I have spent a lot of time _dev'ing_  in **javascript**, **c**, **swift**, and **objective-c**. I have meet some amazing _developers_, [toastynerd](https://github.com/toastynerd), [michaelbabiy](https://github.com/michaelbabiy), [cadbot](https://github.com/cadbot), [brookr](https://github.com/brookr), and [krew](https://github.com/slugbyte/following) who have tought me a lot.  
  
Some of the main things that I've taken away from the last fiew years are the benifits of **modularization**, and **testing**. _Package managers_ aside, the idea of coding with out some way to `#import a-file` or `require('a-file');` makes my head hurt. Debuging a 500+ line file scares me, and I dont even want to think about Debuging a 5,000+, or 15,000 + line file.   
  
All week I've been spending my free time, trying to find a solution to writing more modular `$SHELL` scripts. I mostly came up with a pile of super sketchy hacks that wreeked of [code smell](https://en.wikipedia.org/wiki/Code_smell). Eventually I decited that I had no reason to re-solve a problem that has allready been solved, really well. I just needed a preprocessor that wasnt biased about the _language_ or _content_ of my code. I needed [general-purpose preprocessor](http://en.nothingisreal.com/wiki/GPP) **(_gpp_)**. 

# Poof Of Concept Overview
* Write a test for a function that does not exist, but will be imported with gpp.
* Run the test and make sure it fails.
* Write a function to pass the test.
* Run the test and make sure it succeds.
* Write a program that imports the function with gpp and puts it to good use.

# Getting Started
### File Structure Outline
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

### Setup
* Create a new directory for this project.  
`$ mkdir bash-and-gpp && cd bash-and-cpp`.
* Create lib and test directorys for organizing scripts.  
`$ mkdir lib test`
* Create an empty file _lib/say-hello.sh_ that we will be writing a code in later.   
`touch lib/say-hello.sh` 
* Create a new empty file _test/say-hello-test.sh_ for writing a test function `say_hello_test`.  
 * `#include "say-hello.sh"` into _test/say-hello-test.sh_.
 * Use the **gpp** _macros_ `#ifndef`, `#define`, and `#endif` to check that your function say-hello-test has not been loaded.
 * Write a  function `say_hello_test` that will test `sayHello`. Say hello should `echo "hello, $1"` if input is provided or `echo "hello, world"` if no input is provided. Log output regarding the results of your tests.

**/test/say-hello-test.sh**  
``` sh  
#include "say-hello.sh"

#ifndef TEST_SAY_HELLO
#define TEST_SAY_HELLO
function say_hello_test(){
  local tab="    "
  local tab2="        "
  echo "testing say-hello.sh"
  
  echo "${tab}say_hello with no args should return 'hello, world'"
  result=$(say_hello)  
  if [ "$result" = "hello, world" ];then 
    echo "${tab2}success"
  else 
    echo "${tab2}failure"
  fi

  echo "${tab}say_hello with args should return 'hello, slug neo'"
  result=$(say_hello "slug neo")  
  if [ "$result" = "hello, slug neo" ];then 
    echo -e "${tab2}success"
  else 
    echo -e "${tab2}failure"
  fi
}
#endif
```  
* Create a new file _test/run-tests.sh_ for including and running test functions.  
```$ touch test/run-test.sh```
 * `#include "say_hello_test.sh"` in _test/run-tests.sh_.
 * Invoke the function`say_hello_test`
**/test/run-tests.sh**  
``` sh  
#!/bin/bash
#include "say-hello-test.sh"

say_hello_test
```  
* Create a makefile for building and running your test.  
`$ touch makefile`  
* Create a task in the makefile called `run_tests`.
 * build your _test/run-test.sh_ with `gpp`.
 * make your test exicutable with `chmod`.
 * run your test.
 * delete your test with `rm`.  
``` makefile
run_tests: 
   gpp test/run-tests.sh -I ./lib -I ./test -o run-tests.sh
   chmod 755 run-tests.sh
   ./run-tests.sh
   rm run-tests.sh
```
* run test and to sure they fail.
 * use `-s` flag with `make` to silence make, and only see output of `gpp`, `chmod`, `run-tests.sh`, and `rm`.
``` sh
$ make run_tests -s
testing say-hello.sh
    say_hello with no args should return 'hello, world'
        failure
    say_hello with args should return 'hello, slug neo'
        failure

```
* Write a `say_hello` **fucnction** in _lib/say-hello.sh_ to pass `say_hello_test` 
 * Use the **gpp** _macros_ `#ifndef`, `#define`, and `#endif` to check that your function say-hello has not been loaded.
**/lib/say-hello.sh**  
``` sh  
#ifndef SAY_HELLO
#define SAY_HELLO
function say_hello(){
  local name="$1"
  [ "$name" ] || name="world"
  echo "hello, $name"
}
#endif
```  
* Run your test again, and make sure they pass.
```sh
$ make run_tests -s
testing say-hello.sh
    say_hello with no args should return 'hello, world'
        success
    say_hello with args should return 'hello, slug neo'
        success

```
* Create _main.sh_ 
`$ touch main.sh`
 * `#include say-hello.sh` into _main.sh_ and invoke `say_hello` with the first argument of arv `"$1"`.  
**main.sh**
 ``` sh  
#!/bin/bash
#include "say-hello.sh"

sayHello $1
```  
* Add a task called all to your makefile build _main.sh_ with gpp
 * build your _main.sh_ with `gpp`.
 * make your program exicutable with `chmod`. 
```
all:
	gpp main.sh -I ./lib -o helloworld.sh
	chmod 755 helloworld.sh

run_tests: 
	gpp ./test/all-test.sh -I ./lib -I ./test -o run-me-test.sh
	chmod 755 run-me-test.sh
	./run-me-test.sh
	rm ./run-me-test.sh
```
* build your program  
`$ make`
* inspect the output
`$ cat helloworld.sh`
**/helloworld.sh**  
``` sh  
#!/bin/bash

function say_hello(){
  local name="$1"
  [ "$name" ] || name="world"
  echo "hello, $name"
}

say_hello $1
```  

* run your program
``` sh
$ ./helloworld.sh
hello, world
$ ./helloworld.sh neo slug
hello, neo slug
```

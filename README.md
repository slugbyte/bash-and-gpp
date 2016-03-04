writing better bash with gpp
============================
  
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

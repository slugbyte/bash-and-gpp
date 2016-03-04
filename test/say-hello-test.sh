#include "say-hello.sh"

#ifndef TEST_SAY_HELLO
#define TEST_SAY_HELLO
function say_hello_test(){
  local tab="    "
  local tab2="        "
  echo "testing say-hello.sh"

  echo "${tab}sayHello with no args should return 'hello, world'"
  result=$(say_hello)  
  if [ "$result" = "hello, world" ];then 
    echo "${tab2}success"
  else 
    echo "${tab2}failure"
  fi

  echo "    sayHello with args should return 'hello, slug neo'"
  result=$(say_hello "slug neo")  
  if [ "$result" = "hello, slug neo" ];then 
    echo -e "${tab2}success"
  else 
    echo -e "${tab2}failure"
  fi
}
#endif

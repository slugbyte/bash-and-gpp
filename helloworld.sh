#!/bin/bash

function say_hello(){
  local name="$1"
  [ "$name" ] || name="world"
  echo "hello, $name"
}

say_hello $1

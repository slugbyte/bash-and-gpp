#!/bin/bash

function sayHello(){
  local name="$1"
  [ "$name" ] || name="world"
  echo "hello, $name"
}

sayHello $1

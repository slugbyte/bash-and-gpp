#ifndef SAY_HELLO
#define SAY_HELLO
function sayHello(){
  local name="$1"
  [ "$name" ] || name="world"
  echo "hello, $name"
}
#endif

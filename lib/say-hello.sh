#ifndef SAY_HELLO
#define SAY_HELLO
function say_hello(){
  local name="$1"
  [ "$name" ] || name="world"
  echo "hello, $name"
}
#endif

#!/bin/bash
. ./adbKeyboard_keycodes

keycode() {
  mode=$(( $2 + 1 ))
  case $mode in
    1)
      code=$(eval echo \$$1)
    ;;
    2)
      code=$(eval echo \$KEYCODE_$1)
    ;;
    3)
      code=$(eval echo \$KEYCODE_DPAD_$1)
    ;;
    *)
      echo ""
      return 1
    ;;
  esac

#  if [[ $code =~ ^-?[0-9]+$ && "$i" -lt "100" ]]; then
  if [[ $code =~ ^-?[0-9]+$ ]]; then
    echo $code
    return 0
  fi
  echo $(keycode $1 $mode)
}

text=$@
# String.replace " ", "%s"
text=${text// /%s}

# String.split ";"
array=${text//;/ }

for i in $array; do
  code=$(keycode $i)
  if [ -z "$code" ]; then
    echo "text\>$i"
    adb shell input text "$i"
  else
    echo " key\>$code"
    adb shell input keyevent $i
  fi
done

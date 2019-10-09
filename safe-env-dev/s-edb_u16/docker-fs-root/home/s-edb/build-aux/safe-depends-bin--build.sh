#!/bin/bash

zpath=$(cd `dirname $0`; pwd)
cd $zpath > /dev/null

##############################

TEMP=`getopt -o fh --long force,help -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

########################################
########################################
########################################

FORCE="false"

function usage {
  echo "Usage: $0 [-f|--force] [-h|--help]"
  cat <<EOF
Options:
  -f|--force	true or false; default: false
  -h|--help		show help message

EOF
}

########################################
########################################
########################################

while true; do
  case "$1" in
    -f | --force )
      FORCE="true"; shift ;;
    -h | --help )
      usage; exit 0;;
    -- ) 
      shift; break ;;
    * )
      break ;;
  esac
done

########################################
########################################
########################################

if [[ "$FORCE" == "true" ]]; then
    [ -d ../depends_bin ] && {
        { echo "$0 said: ../depends_bin exists, warning."; }
    }
else
    [ -d ../depends_bin ] && {
        { echo "$0 said: ../depends_bin exists, aborting."; exit 1; }
    }
fi

MACOSX_SDK_FILE=${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/MacOSX*-SDKs.tar.gz
[ -f $MACOSX_SDK_FILE ] && 
[ "cc2d742d09e7e5e01e999098794fa2af" == $(md5sum $MACOSX_SDK_FILE | awk '{print $1}') ] ||
{ echo "$0 said: MacOSX*-SDKs.tar.gz error"; exit 1; }

rm -rf ../depends_bin/
cp -rfpP /home/bankledger/safe/depends/ ../depends_bin/
cd ../depends_bin &&
tar xzvf ${MACOSX_SDK_FILE} &&
make HOST=x86_64-pc-linux-gnu -j4 &&
make HOST=x86_64-w64-mingw32 -j4 &&
make HOST=i686-w64-mingw32 -j4 &&
make HOST=x86_64-apple-darwin11 ||
{ echo "$0 said: error when make HOST=xxx"; exit 1; }

echo -e "please check build result at $PWD"

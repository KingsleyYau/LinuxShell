#!/bin/sh
# Sort video and image from directory
# Author: Max.Chiu

function Usage {
  echo "Usage : ./sort_mp4_jpg.sh [SRC_DIR, default=input] [DST_DIR, default=output]"
  echo "Usage : ./sort_mp4_jpg.sh input output"
}

INPUT="input"
if [ "$1" != "" ];then
  INPUT="$1"
elif [ "$1" == "-v" ];then
  Usage
  exit 1
fi

if [ ! -d "$INPUT" ];then
  Usage
  exit
fi

OUTPUT=""
if [ "$2" != "" ];then
  OUTPUT="$2"
fi

echo "INPUT:$INPUT"
echo "OUTPUT:$OUTPUT"

# Sort Photo
if [ -z "$OUTPUT" ];then
  P_DIR="${INPUT}"
else
  P_DIR="${OUTPUT}/P"
fi
mkdir -p "$P_DIR"

RET=`find "$INPUT" -regextype posix-extended -iregex ".*\.(jpg|jpeg|bmp|png)"`
echo "$RET" | while read LINE
do
  if [ -n "$LINE" ];then
    echo "LINE:$LINE"
    EXT=`basename "$LINE" | awk -F '.' '{print $NF}'`
    FNAME=`md5sum "$LINE" | awk '{print $1}'`
    FNAME=P_$FNAME.$EXT
    if [ "$LINE" != "$P_DIR/$FNAME" ];then
      cp "$LINE" "$P_DIR/$FNAME"
    fi
  fi
done

# Sort Video
if [ -z "$OUTPUT" ];then
  V_DIR="${INPUT}"
else
  V_DIR="${OUTPUT}/V"
fi
mkdir -p "$V_DIR"

RET=`find "$INPUT" -regextype posix-extended -iregex '.*\.(mp4|mov|mkv|mpeg|mpg|avi|flv)'`
echo "$RET" | while read LINE
do
  if [ -n "$LINE" ];then
    echo "LINE:$LINE"
    EXT=`basename "$LINE" | awk -F '.' '{print $NF}'`
    FNAME=`md5sum "$LINE" | awk '{print $1}'`
    FNAME=V_$FNAME.$EXT
    if [ "$LINE" != "$V_DIR/$FNAME" ];then
      cp "$LINE" "$V_DIR/$FNAME"
    fi
  fi
done

if [ ! -z "$OUTPUT" ];then
  REAL_INPUT=`readlink -f "${INPUT}"`
  if [ ${#REAL_INPUT} -gt 10 ];then
    echo "REAL_INPUT:$REAL_INPUT"
    #rm "${REAL_INPUT}" -rf
  fi
fi
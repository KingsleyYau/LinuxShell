#!/bin/sh
# Sort video and image from directory
# Author: Max.Chiu

function Usage {
  echo "Usage : ./sort_mp4_jpg.sh [SRC_DIR, default=input] [DST_DIR, default=output]"
  echo "Usage : ./sort_mp4_jpg.sh input output"
}

INPUT="input"
if [ "$1" != "" ];then
  INPUT=""$1""
elif [ "$1" == "-v" ];then
  Usage
  exit 1
fi

OUTPUT="output"
if [ "$2" != "" ];then
  OUTPUT=""$2""
fi

# Sort Photo
P_DIR="${OUTPUT}/P"
mkdir -p $P_DIR
RET=`find $INPUT -regextype posix-extended -iregex ".*\.(jpg|jpeg|bmp|png)"`
echo "$RET" | while read LINE
do
  if [ -n "$LINE" ];then
    EXT=`basename "$LINE" | awk -F '.' '{print $(NF-1)}'`
    FNAME=`md5sum "$LINE" | awk '{print $1}'`
    FNAME=P_$FNAME.$EXT
    mv "$LINE" "$P_DIR/$FNAME"
  fi
done

# Sort Video
V_DIR="${OUTPUT}/V"
mkdir -p $V_DIR
RET=`find $INPUT -regextype posix-extended -iregex '.*\.(mp4|mov|mkv|mpeg|mpg|avi)'`
echo "$RET" | while read LINE
do
  if [ -n "$LINE" ];then
    EXT=`basename "$LINE" | awk -F '.' '{print $(NF-1)}'`
    FNAME=`md5sum "$LINE" | awk '{print $1}'`
    FNAME=V_$FNAME.$EXT
    mv "$LINE" "$V_DIR/$FNAME"
  fi
done
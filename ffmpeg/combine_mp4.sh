#!/bin/bash

FFMPEG=/Users/max/Documents/tools/build/bin/ffmpeg

function Usage {
  echo "Usage: ./combine_mp4.sh [INPUT_DIR_PATH]"
  echo "Example: ./combine_mp4.sh input"
}

INPUT_PATH=""
if [ ! "$1" == "" ]
then
  INPUT_PATH=$1
else
  Usage;
  exit 1;
fi

OUTPUT_NAME=`basename $INPUT_PATH`.mp4
TMP_DIR=`dirname $INPUT_PATH`/tmp
INPUT_FILES=`find $INPUT_PATH -name "*.mp4" | sort`

echo "OUTPUT_NAME:$OUTPUT_NAME"
echo "TMP_DIR:$TMP_DIR"
echo "INPUT_FILES:$INPUT_FILES"

rm -rf $TMP_DIR 
mkdir -p $TMP_DIR

i=0
for mp4 in $INPUT_FILES;do
  $((i++))
  echo $i
  $FFMPEG -i $mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts -y ${TMP_DIR}/$i.ts
done

TS_FILES=`find $TMP_DIR -name "*.ts"`
$FFMPEG -i `echo -e "concat:\c";for file in $TS_FILES;do echo -e "$file|\c";done` -acodec copy -absf aac_adtstoasc -vcodec copy -y ${OUTPUT_NAME}
echo ${OUTPUT_PATH}
rm -rf ${TMP_DIR}
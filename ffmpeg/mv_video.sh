#!/bin/sh

function Usage {
  echo "Usage : ./mv_video.sh [NAME] [DST_DIR, default=input]"
  echo "Usage : ./mv_video.sh NAME1234 134"
}

NAME=""
if [ "$1" != "" ];then
  NAME="$1"
else
  Usage
  exit 1
fi

OUTPUT="input"
if [ "$2" != "" ];then
  OUTPUT="$2"
fi

MV_PATH="input/${NAME}"
find download -name "${NAME}*" -type d | awk '{cmd="echo \""$0"\"|md5sum|cut -d \" \" -f1";cmd|getline ret;print ret","$0}' | awk -F ',' '{name="input/""'${NAME}_'"$1;cmd="mv \""$2"\" "name;cmd|getline ret;print name;}' | xargs -I {} ./sort_mp4_jpg.sh {} "${OUTPUT}/${NAME}_S"
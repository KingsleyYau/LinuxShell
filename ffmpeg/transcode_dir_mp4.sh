FFMPEG=ffmpeg

function Usage {
  echo "Usage : ./transcode_dir_mp4.sh [DIR, default=input] [Operation, {cut|transcode}, default=transcode]"
  echo "Usage : ./transcode_dir_mp4.sh input transcode"
}

INPUT="input"
if [ "$1" != "" ];then
  INPUT=""$1""
elif [ "$1" == "-v" ];then
  Usage
  exit 1
fi

op="transcode"
if [ "$2" == "transcode" ];then
  op=$2
elif [ "$2" == "transcode_replace" ];then
  op=$2
elif [ "$2" == "cut" ];then
  op=$2
elif [ "$2" == "snapshot" ];then
  op=$2
elif [ "$2" == "rename_file" ];then
  op=$2  
fi

echo "Operation: ${op}"

OUTPUT="output"
BACKUP="backup"

mkdir -p $OUTPUT
mkdir -p $BACKUP

IMGS=(jpg jpeg png gif)
VIDEOS=(mp4 mov mpg mkv avi flv)
  
function transcode {
  fpath=$1
  dir=`dirname "${fpath}"`
  fname=`basename $fpath|awk -F . '{print $1}'`;
  ext=`basename $fpath|awk -F . '{print $NF}'`;
  if [ "$ext" != "" ];then
    if [[ "${VIDEOS[@]}" =~ "$ext" ]];then
      echo "transcode: ${fname}.${ext}"
      $FFMPEG -i $fpath -map 0 -c:a copy -c:v libx264 -profile:v high -y "${OUTPUT}/${fname}.mp4" && mv "$fpath" $BACKUP/ && mv "${OUTPUT}/${fname}.mp4" "$dir/${fname}.mp4"
      #$FFMPEG -i $fpath -map 0 -c:a aac -c:v libx264 -profile:v high -y "${OUTPUT}/${fname}.mp4" && mv "${OUTPUT}/${fname}.mp4" "$dir/${fname}.mp4"
    fi
  fi
}

function transcode_replace {
  fpath=$1
  fname_ori=`basename "${fpath}"`
  dir=`dirname "${fpath}"`
  fname=`basename $fpath|awk -F . '{print $1}'`;
  ext=`basename $fpath|awk -F . '{print $NF}'`;
  if [ "$ext" != "" ];then
    if [[ "${VIDEOS[@]}" =~ "$ext" ]];then
      echo "transcode: ${fname}.${ext}"
      rm -f "$fpath"
      $FFMPEG -i $fpath -map 0 -c:a aac -c:v libx264 -profile:v high -y "${OUTPUT}/${fname}.mp4" && mv "${OUTPUT}/${fname}.mp4" "$dir/${fname}.mp4"
    fi
  fi
}

function cut {
  fpath=$1
  index=$2
  
  start=1:30
#  if [ "$3" != "" ];then
#    start="$3"   
#  fi

  fname=`basename "${fpath}"`
  ext=`basename $fpath|awk -F . '{print $NF}'`;
  if [ "$ext" != "" ];then
    if [[ "${VIDEOS[@]}" =~ "$ext" ]];then
      echo "cut: ${fname}, start: ${start}"
      $FFMPEG -ss $start -i $fpath -c copy -y "${OUTPUT}/${fname}" # && rm $fpath
    fi
  fi
}

function snapshot {
  fpath=$1
  fname=`basename "${fpath}"`.jpg
  echo "snapshot: ${fname}.${ext}"
  $FFMPEG -ss 1 -i $fpath -vframes 1 -y "${OUTPUT}/${fname}"
}

function rename_file {
  fpath=$1
  index=$2

  fname=`basename $fpath|awk -F . '{print $1}'`;
  ext=`basename $fpath|awk -F . '{print $2}'`;
  output_fname="F$index.$ext";
  #echo "${index}, ext: $ext, output_fname: $output_fname";
  if [ "$ext" != "" ];then
    if [[ "${IMGS[@]}" =~ "$ext" ]];then
      output_fname="P$index.$ext";
    elif [[ "${VIDEOS[@]}" =~ "$ext" ]];then
      output_fname="V$index.$ext";
    fi
  fi
  mv -f $fpath "${OUTPUT}/$output_fname";
}

i=0
IFS=$'\n';
INPUT_FILES=`find $INPUT -type f -name "*.*"`
for mp4 in $INPUT_FILES;do
  ((i++))
  #echo "$i, Processing: ${mp4}"
  eval "${op} \"${mp4}\" \"$i\""
done
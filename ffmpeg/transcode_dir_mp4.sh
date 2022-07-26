FFMPEG=ffmpeg

function Usage {
  echo "Usage : ./check_camshare_detail.sh [Operation, [cut|transcode], default=transcode]"
  echo "Usage : ./check_camshare_detail.sh cut"
}

op="transcode"
if [ "$1" == "transcode" ];then
  op="transcode"
elif [ "$1" == "cut" ];then
  op=$1
elif [ "$1" == "snapshot" ];then
  op=$1
elif [ "$1" == "rename_file" ];then
  op=$1  
elif [ "$1" == "-v" ];then
  Usage
  exit 1
fi

echo "Operation: ${op}"

INPUT="input"
if [ "$2" != "" ];then
  INPUT=""$2""
fi

OUTPUT="output"
BACKUP="backup"

mkdir -p $OUTPUT
mkdir -p $BACKUP

IMGS=(jpg jpeg png gif)
VIDEOS=(mp4 mov mpg mkv avi)
  
function transcode {
  fpath=$1
  #fname=`basename "${fpath}"`
  fname=`basename $fpath|awk -F . '{print $1}'`;
  ext=`basename $fpath|awk -F . '{print $2}'`;
  if [[ "${VIDEOS[@]}" =~ "$ext" ]];then
    $FFMPEG -i $fpath -c:a copy -c:v libx264 -profile:v high -y "${OUTPUT}/${fname}.mp4" && mv "$mp4" $BACKUP/
  fi
}

function cut {
  fpath=$1
  fname=`basename "${fpath}"`
  $FFMPEG -ss 3:00 -i $fpath -c copy -y "${OUTPUT}/${fname}" # && rm $fpath
}

function snapshot {
  fpath=$1
  fname=`basename "${fpath}"`.jpg
  $FFMPEG -ss 1 -i $fpath -vframes 1 -y "${OUTPUT}/${fname}"
}

function rename_file {
  fpath=$1
  index=$2
  IFS=$'\n';

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
INPUT_FILES=`find $INPUT -type f -name "*.*"`
for mp4 in $INPUT_FILES;do
  ((i++))
  echo "$i, Processing: ${mp4}"
  eval "${op} \"${mp4}\" $i"
done

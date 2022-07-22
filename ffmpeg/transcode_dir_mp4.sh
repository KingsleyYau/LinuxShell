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
elif [ "$1" == "-v" ];then
  Usage
  exit 1
fi

echo "Operation: ${op}"

INPUT="input"
OUTPUT="output"
BACKUP="backup"

INPUT_FILES=`find $INPUT -type f -name "*"`

mkdir -p $OUTPUT
mkdir -p $BACKUP

function transcode {
  fpath=$1
  fname=`basename ${fpath}`
  $FFMPEG -i $fpath -c:a copy -c:v libx264 -profile:v high -y ${OUTPUT}/${fname} && mv $mp4 $BACKUP/
}

function cut {
  fpath=$1
  fname=`basename ${fpath}`
  $FFMPEG -ss 1:30 -i $fpath -c copy -y ${OUTPUT}/${fname} # && rm $fpath
}

function snapshot {
  fpath=$1
  fname=`basename ${fpath}`.jpg
  $FFMPEG -ss 1 -i $fpath -vframes 1 -y ${OUTPUT}/${fname}
}

i=0
for mp4 in $INPUT_FILES;do
  ((i++))
  fname=`basename ${mp4}`
  echo "Processing: ${mp4}"
  eval "${op} ${mp4}"
done
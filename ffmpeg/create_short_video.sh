#!/bin/sh
# Create short live video script
# Author:	Max.Chiu

FFMPEG=/Users/max/Documents/tools/build/bin/ffmpeg

function Usage {
	echo "Usage : ./create_short_video.sh example.mp4"
}

if [ "$1" == "" ]
then
	Usage;
	exit 1
fi

FILE="$1"
START=0
#$FFMPEG -i /Users/max/Documents/log/LS/video/ajypj.mp4 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//
for((i=0,start=0;i<=10;i++));  
do  
	echo $i; 
	second=$(expr $start % 60);
	min=$(expr $start / 60);
	
	start=$(expr $start + 30)
	#second_new=$(expr $start % 60);
	#min_new=$(expr $start / 60);
	
	$FFMPEG -i $FILE -vcodec libx264 -preset superfast -profile:v baseline -level 3.0 -acodec copy -ss 00:$min:$second -t 00:00:30 output_$(expr $START + $i).mp4
done  
#$FFMPEG -i $FILE -vcodec libx264 -preset superfast -profile:v baseline -level 3.0 -acodec copy -ss 00:00:10 -t 00:00:10 1.mp4#
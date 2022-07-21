#!/bin/sh
# Transcode High Quality Gif
# Author:	Max.Chiu

set -e

function Usage {
  echo "Usage : ./create_gif.sh [filepath]"
  echo "Usage : ./create_gif.sh input.mp4"
}

# global filter
# 帧率
fps=15
# 缩放
scale=480:-1
# 插值法
interpolation=lanczos

# 指定了调色板用多少种颜色, 最多256
max_colors=256  

# 也就是选用 255 种颜色, 最后一种颜色留给透明. 这里透明也可以通过 transparency_color 指定具体哪种颜色.
# [off, on]
reserve_transparent=on

# 指定了在统计颜色分布直方图的时候要考虑的区域, 用于生成调色板
# [full, diff, single]
# full 背景色带区域更少
# diff 运动区域更细腻
stats_mode=full  

# 抖动算法 
# [bayer, heckbert, floyd_steinberg, sierra2, sierra2_4a, none]
dither=bayer

# 抖动算法参数
# [0, 5], only works when dither=bayer. higher means more color banding but less crosshatch pattern and smaller file size
# 数值越小, 棋盘格越明显, 但是颜色带伪影会更少.
bayer_scale=3  

# 运动区域 
# [rectangle, none]
diff_mode=rectangle  

# 是否每帧都使用新的调色板
# [off, on], when stats_mode=single and new=on, each frame uses different palette [off, on]
new=off  

input=""
if [ ! "$1" == "" ];then
  input="$1"
else
  Usage
  exit 1
fi

output_dir=`dirname $input | awk -F '.' '{print $1}'`
output=`basename $input | awk -F '.' '{print $1}'`
output=${output_dir}/${output}.gif
echo "output:$output"
ffmpeg -i $input -vf "fps=$fps,scale=$scale:flags=$interpolation,split[split1][split2];[split1]palettegen=max_colors=$max_colors:reserve_transparent=$reserve_transparent:stats_mode=$stats_mode[pal];[split2][pal]paletteuse=dither=$dither:bayer_scale=$bayer_scale:diff_mode=$diff_mode:new=$new" -y $output
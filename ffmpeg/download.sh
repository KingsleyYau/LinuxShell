#!/bin/sh
# Download live video script
# Author:	Max.Chiu

FFMPEG=/Users/max/Documents/tools/build/bin/ffmpeg

VIDEO_URL="https://r4---sn-i3belnel.googlevideo.com/videoplayback?expire=1568707117&ei=zT2AXd-6E92pgQPJpZvADg&ip=103.29.140.19&id=o-APhx694ZaEEr9HzXFm7Jsj_-FsFRsAEJ904Q6q9I7XLA&itag=244&aitags=133%2C134%2C135%2C136%2C137%2C160%2C242%2C243%2C244%2C247%2C248%2C278&source=youtube&requiressl=yes&mm=31%2C29&mn=sn-i3belnel%2Csn-i3b7kn76&ms=au%2Crdu&mv=m&mvi=3&pl=25&gcr=hk&initcwndbps=1200000&mime=video%2Fwebm&gir=yes&clen=8467608&dur=231.291&lmt=1568648791199832&mt=1568685460&fvip=5&keepalive=yes&c=WEB&txp=5535432&sparams=expire%2Cei%2Cip%2Cid%2Caitags%2Csource%2Crequiressl%2Cgcr%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&lsparams=mm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AHylml4wRQIhAJk7xEXFtDoOuvdZCEfihhD7LBpCyh_50__Z7q4opGjCAiAX0Dvi3GsyebnYLmacVIkodSQ7RZBO1n2i5bbIcw5_wg%3D%3D&alr=yes&sig=ALgxI2wwRQIgeuKfza2NAcRX2vR8COjjgjc8nEcZP--zi8HFhJHLx5sCIQD2THBHXEBiQwmH1zC8EmXH1iyJrhQf6-5kLfPduEkobg%3D%3D&cpn=D-5_NcMf9bj30nrG&cver=2.20190916.07.00&rn=25&rbuf=0"
AUDIO_URL="https://r4---sn-i3belnel.googlevideo.com/videoplayback?expire=1568707117&ei=zT2AXd-6E92pgQPJpZvADg&ip=103.29.140.19&id=o-APhx694ZaEEr9HzXFm7Jsj_-FsFRsAEJ904Q6q9I7XLA&itag=251&source=youtube&requiressl=yes&mm=31%2C29&mn=sn-i3belnel%2Csn-i3b7kn76&ms=au%2Crdu&mv=m&mvi=3&pl=25&gcr=hk&initcwndbps=1200000&mime=audio%2Fwebm&gir=yes&clen=3967013&dur=231.321&lmt=1568647808746108&mt=1568685460&fvip=5&keepalive=yes&c=WEB&txp=5531432&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cgcr%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&lsparams=mm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AHylml4wRQIhAJk7xEXFtDoOuvdZCEfihhD7LBpCyh_50__Z7q4opGjCAiAX0Dvi3GsyebnYLmacVIkodSQ7RZBO1n2i5bbIcw5_wg%3D%3D&alr=yes&sig=ALgxI2wwRgIhAMYs_Fsmaav9tTRS_ih6dT2GBAva3K3zYikJP9QWFdAZAiEAkx0nsoxSIXt7nU5Z2078RUKioQTvB3I3IPkE9Pqm0BI%3D&cpn=D-5_NcMf9bj30nrG&cver=2.20190916.07.00&rn=23&rbuf=0"
VIDEO_NAME=video.mp4
AUDIO_NAME=audio.mp4

# Combine mp4
$FFMPEG -i $VIDEO_URL -y ./$VIDEO_NAME
$FFMPEG -i $AUDIO_URL -y ./$AUDIO_NAME

$FFMPEG -i $VIDEO_NAME -i $AUDIO_NAME -y output.mp4
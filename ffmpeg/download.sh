#!/bin/sh
# Download live video script
# Author:	Max.Chiu

FFMPEG=/Users/max/Documents/tools/build/bin/ffmpeg

#VIDEO_URL="https://r4---sn-i3belnel.googlevideo.com/videoplayback?expire=1568707117&ei=zT2AXd-6E92pgQPJpZvADg&ip=103.29.140.19&id=o-APhx694ZaEEr9HzXFm7Jsj_-FsFRsAEJ904Q6q9I7XLA&itag=244&aitags=133%2C134%2C135%2C136%2C137%2C160%2C242%2C243%2C244%2C247%2C248%2C278&source=youtube&requiressl=yes&mm=31%2C29&mn=sn-i3belnel%2Csn-i3b7kn76&ms=au%2Crdu&mv=m&mvi=3&pl=25&gcr=hk&initcwndbps=1200000&mime=video%2Fwebm&gir=yes&clen=8467608&dur=231.291&lmt=1568648791199832&mt=1568685460&fvip=5&keepalive=yes&c=WEB&txp=5535432&sparams=expire%2Cei%2Cip%2Cid%2Caitags%2Csource%2Crequiressl%2Cgcr%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&lsparams=mm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AHylml4wRQIhAJk7xEXFtDoOuvdZCEfihhD7LBpCyh_50__Z7q4opGjCAiAX0Dvi3GsyebnYLmacVIkodSQ7RZBO1n2i5bbIcw5_wg%3D%3D&alr=yes&sig=ALgxI2wwRQIgeuKfza2NAcRX2vR8COjjgjc8nEcZP--zi8HFhJHLx5sCIQD2THBHXEBiQwmH1zC8EmXH1iyJrhQf6-5kLfPduEkobg%3D%3D&cpn=D-5_NcMf9bj30nrG&cver=2.20190916.07.00&rn=25&rbuf=0"
AUDIO_URL="https://r3---sn-i3b7knld.googlevideo.com/videoplayback?expire=1589361938&ei=smi7XrnhG4KMlQSA8rPgDg&ip=103.29.140.19&id=o-AM_giX-h7XKBwBUI6E29Lv2j2PmOse9ULZapDin_FTmT&itag=251&source=youtube&requiressl=yes&mh=8G&mm=31%2C29&mn=sn-i3b7knld%2Csn-i3belnl7&ms=au%2Crdu&mv=m&mvi=2&pl=25&initcwndbps=1692500&vprv=1&mime=audio%2Fwebm&gir=yes&clen=32849725&dur=2495.541&lmt=1545519448821494&mt=1589340283&fvip=3&keepalive=yes&c=WEB&txp=5411222&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRAIgVS_fn9XsuWMQjb_O--VS17kky_Ij4-o4GoNisnLvghMCIFIBxwRIkL8Rdd5sObMEeeNJq-kiKZ2LUnWy4Pdj4h1j&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRAIgE4ryBRMUNq1PEf7l39q1Ou1XLclZ6on-bM8Uydk6UIYCIEB_LEgcs9w97TsoRfhwGRhEYdHYcBS4n5L7fYDrupAK&alr=yes&cpn=fIfR56Vb-IAkj--n&cver=2.20200512.00.00&rn=2&rbuf=0"
VIDEO_NAME=videoplayback.mp4
AUDIO_NAME=audioplayback.mp3

# Combine mp4
#$FFMPEG -i $VIDEO_URL -y ./$VIDEO_NAME
$FFMPEG -i $AUDIO_URL -y ./$AUDIO_NAME

$FFMPEG -i $VIDEO_NAME -i $AUDIO_NAME -vcodec copy -y output.mp4
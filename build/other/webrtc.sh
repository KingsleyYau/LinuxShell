#!/bin/sh
# Curl build script for android
# Author:	Max.Chiu
# Description: asm
# WebRTC build script

# Getting Prerequisite software
WEBRTC_PATH=/Users/max/Documents/Project/webrtc/
mkdir -p $WEBRTC_PATH
export PATH=$PATH:$WEBRTC_PATH/depot_tools

# Getting code
#fetch --nohooks webrtc_ios
fetch --nohooks webrtc_android
cd webrtc
gclient sync

# Compiling
BUILD_ARCH=(arm arm64 x86 x64)
for var in ${BUILD_ARCH[@]};do
	gn gen out/Debug/$var --args='target_os="android" target_cpu="$var"'
	ninja -C out/Debug/$var
done
#!/bin/sh
# dlib build script for android
# Author:	Max.Chiu
# Description: asm

# Config version
VERSION=19.16

# Configure enviroment
export ANDROID_NDK_ROOT="/Applications/Android/android-sdks-studio/ndk-bundle"
export TOOLCHAIN_FILE="/Applications/Android/android-sdks-studio/ndk-bundle/build/cmake/android.toolchain.cmake"
export TOOLCHAIN=clang

function configure_prefix {
	export PREFIX=$(pwd)/out.android/$ARCH_ABI

	export PKG_CONFIG_LIBDIR=$PREFIX/lib/pkgconfig
	export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

	export EXTRA_CFLAGS="-I$PREFIX/include" 
	export EXTRA_LDFLAGS="-L$PREFIX/lib"
}

function configure_armv7a {
	export ANDROID_API=android-16
	
	export ARCH_ABI=armeabi-v7a
	export ARCH=arm
	export ANDROID_ARCH=arch-arm

	#export EXTRA_CFLAGS="$EXTRA_CFLAGS -mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=armv7-a "
	
	#export CONFIG_PARAM=""
	#export OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=armv7-a"

	configure_prefix
}

function configure_arm64 {
	export ANDROID_API=android-21
	
	export ARCH_ABI=arm64-v8a
	export ARCH=aarch64
	export ANDROID_ARCH=arch-arm64
	
	export CONFIG_PARAM=""
	export OPTIMIZE_CFLAGS=""
	
	configure_prefix
}

function configure_x86 {
	export ANDROID_API=android-16
	
	export ARCH_ABI=x86
	export ARCH=x86
	export ANDROID_ARCH=arch-x86

	#export CONFIG_PARAM="--disable-asm"
	#export OPTIMIZE_CFLAGS="-m32"

	configure_prefix
}

function configure_x86_64 {
	export ANDROID_API=android-16
	
	export ARCH_ABI=x86_64
	export ARCH=x86_64
	export ANDROID_ARCH=arch-x86_64

	#export CONFIG_PARAM="--disable-asm"
	#export OPTIMIZE_CFLAGS="-m32"

	configure_prefix
}

function show_enviroment {
	echo "####################### $ANDROID_ARCH ###############################"
	echo "ANDROID_NDK_ROOT : $ANDROID_NDK_ROOT"
	echo "TOOLCHAIN_FILE : $TOOLCHAIN_FILE"
	echo "TOOLCHAIN_ : $TOOLCHAIN"
	echo "ANDROID_API : $ANDROID_API"
	echo "ARCH_ABI : $ARCH_ABI"
	echo "ANDROID_ARCH : $ANDROID_ARCH"
	echo "CONFIG_PARAM : $CONFIG_PARAM"
	echo "PREFIX : $PREFIX"
	echo "PKG_CONFIG_LIBDIR : $PKG_CONFIG_LIBDIR"
	echo "PKG_CONFIG_PATH : $PKG_CONFIG_PATH"
	echo "####################### $ANDROID_ARCH enviroment ok ###############################"
}

function build_dlib {
	echo "# Start building dlib for $ARCH_ABI"
	TARGET="dlib-$VERSION"
	cd $TARGET
	
	# build
  cmake -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE 				\
  			-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=$PREFIX			\
      	-DCMAKE_BUILD_TYPE=Release          					\
      	-DCMAKE_C_FLAGS=$EXTRA_CFLAGS									\
      	-DANDROID_NDK=$ANDROID_NDK_ROOT     					\
      	-DANDROID_ABI=$ARCH_ABI          							\
      	-DANDROID_PLATFORM=$ANDROID_API 							\
      	-DANDROID_STL="c++_static"										\
      	-DANDROID_TOOLCHAIN=$TOOLCHAIN								\
      	-DUSE_AVX_INSTRUCTIONS=ON											\
      	-B $PREFIX/tmp 																\
      	.
  
	cmake --build $PREFIX/tmp	--clean-first --config Release
	#cmake --build $PREFIX/tmp --target install
	
	cd -
	echo "# Build dlib finish for $ARCH_ABI"
}

# Start Build
#BUILD_ARCH=(armv7a arm64 x86 x86_64)
BUILD_ARCH=(x86_64)

echo "# Starting building..."

for var in ${BUILD_ARCH[@]};do
	configure_$var
	show_enviroment
	echo "# Starting building for $ARCH_ABI..."
	build_dlib || exit 1
	echo "# Starting building for $ARCH_ABI finish..."
done

echo "# Build finish" 
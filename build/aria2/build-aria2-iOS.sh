#!/bin/sh
# aria2 build script for iOS
# Author:	Max.Chiu

# Config aria2 version
VERSION="1.35.0"

# Configure enviroment
export IPHONEOS_DEPLOYMENT_TARGET="11.0"

DEVELOPER="/Applications/Xcode.app/Contents/Developer"

function configure_prefix {
	export PREFIX=$(pwd)/out.iOS/$ARCH

	export PKG_CONFIG_LIBDIR=$PREFIX/lib/pkgconfig
	export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

	export EXTRA_CFLAGS="-I$PREFIX/include $EXTRA_CFLAGS" 
	export EXTRA_LDFLAGS="-L$PREFIX/lib $EXTRA_LDFLAGS "
	
	# Configure compiler and linker flags 
	export CFLAGS="-arch ${ARCH} -isysroot ${SYSROOT} -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET} -Wunguarded-availability"
	export CPPFLAGS=$CFLAGS
	export CXXFLAGS=$CPPFLAGS
	export LDFLAGS="-arch ${ARCH} -isysroot ${SYSROOT}"
	export OpenSSL=$(pwd)/out.iOS/$ARCH
		
	# Configure compiler and linker path
	export TOOLCHAIN=$(xcrun --sdk $PLATFORM -f clang)
	export CROSS_COMPILE_PREFIX="`dirname $TOOLCHAIN`"
	export CC="$TOOLCHAIN"
  export LD=$CROSS_COMPILE_PREFIX/ld
  export AR=$CROSS_COMPILE_PREFIX/ar
  export AS=$CROSS_COMPILE_PREFIX/as
  export NM=$CROSS_COMPILE_PREFIX/nm
  export RANLIB=$CROSS_COMPILE_PREFIX/ranlib
  export STRIP="$CROSS_COMPILE_PREFIX/strip"
}

function configure_i386 {
	export PLATFORM="iphonesimulator"
	
	export SYSROOT=`xcrun --sdk $PLATFORM --show-sdk-path`
	
	export ARCH=i386
	export HOST=$ARCH-apple-darwin
	
	export EXTRA_CFLAGS=""
	
	configure_prefix
}

function configure_x86_64 {
	export PLATFORM="iphonesimulator"
	
	export SYSROOT=`xcrun --sdk $PLATFORM --show-sdk-path`
	
	export ARCH=x86_64
	export HOST=$ARCH-apple-darwin
	
	export EXTRA_CFLAGS=""
	
	configure_prefix
}

function configure_armv7 {
	export PLATFORM="iphoneos"
	
	export SYSROOT=`xcrun --sdk $PLATFORM --show-sdk-path`
	
	export ARCH=armv7
	export HOST=$ARCH-apple-darwin

	configure_prefix
}

function configure_arm64 {
	export PLATFORM="iphoneos"
	
	export SYSROOT=`xcrun --sdk $PLATFORM --show-sdk-path`
	
	export ARCH=arm64
	export HOST=arm-apple-darwin

	# Configure (include/library/install) path 
	configure_prefix
}

function show_enviroment {
	echo "# ################################ $ARCH ################################ #"
	echo "ARCH : $ARCH"
	echo "HOST : $HOST"
	echo "PLATFORM : $PLATFORM"
	echo "SYSROOT : $SYSROOT"
	echo "CFLAGS : $CFLAGS"
	echo "LDFLAGS : $LDFLAGS"
	echo "CROSS_COMPILE_PREFIX : $CROSS_COMPILE_PREFIX"
	echo "PREFIX : $PREFIX"
	echo "EXTRA_CFLAGS : $EXTRA_CFLAGS"
	echo "EXTRA_LDFLAGS : $EXTRA_LDFLAGS"
	echo "TOOLCHAIN : $TOOLCHAIN"
	echo "# ################################ $ARCH ################################ #"
}

function build_libxz {
	echo "# Start building libxz for $ARCH"
	
	cd xz-5.2.5  
	./configure \
				--prefix=$PREFIX \
				--host=$HOST \
				--with-sysroot=$SYSROOT \
				--enable-shared=no \
				--enable-static=yes \
				$CONFIG_PARAM \
				|| exit 1
    		
    		
	make clean || exit 1
	make || exit 1
	make install || exit 1
	
	cd ..
	echo "# Build libxz finish for $ARCH"
}

function build_libxml2 {
	echo "# Start building libxml2 for $ARCH"
	
	cd libxml2

  CFLAGS="$CFLAGS $EXTRA_CFLAGS"
  LDFLAGS="$LDFLAGS $EXTRA_LDFLAGS"
  
	./configure --prefix=$PREFIX \
              --host=$HOST \
              --with-sysroot=$SYSROOT \
              --enable-shared=no \
              --enable-static=yes \
              $CONFIG_PARAM \
              || exit 1
    		
    		
	make clean || exit 1
	make || exit 1
	make install || exit 1
	
	cd ..
	echo "# Build libxml2 finish for $ARCH"
}

function build_aria2 {
	echo "# Start building aria2 for $ARCH"
	ARIA2="aria2-release-$VERSION"
	cd $ARIA2

  if [ ! -f "configure" ]; then
    autoreconf -i || exit 1
  fi
  
	CFLAGS="$CFLAGS $EXTRA_CFLAGS"
  CPPFLAGS=$CFLAGS
	CXXFLAGS=$CPPFLAGS
  LDFLAGS="$LDFLAGS $EXTRA_LDFLAGS"
  CONFIG_PARAM="ARIA2_STATIC=yes"
    
	# build
	./configure --prefix=$PREFIX \
		          --host="$HOST" \
	            --with-sysroot=$SYSROOT \
              --disable-shared \
              --enable-static=YES \
	            --enable-bittorrent \
	            --enable-metalink \
	            --enable-libaria2 \
              --disable-nls \
              --with-openssl \
              --without-appletls \
              --without-gnutls \
              --without-sqlite3 \
              --without-libssh2 \
              $CONFIG_PARAM \
             || exit 1
             
	make clean || exit 1
	make || exit
	make install || exit 1

	cd ..
	echo "# Build aria2 finish for $ARCH"
}

function combine {
	echo "# Starting combining..."
	cd "out.iOS"
	
	mkdir universal
	
	cd ..
	echo "# Combine finish"
}

# Start Build
#BUILD_ARCH=(armv7 arm64 i386 x86_64)
BUILD_ARCH=(arm64)

echo "# Starting building..."

for var in ${BUILD_ARCH[@]};do
	echo "##############################################################################################"
	echo "##############################################################################################"
	configure_$var
	echo "# Starting building for $ARCH..."
	show_enviroment
	build_libxz || exit 1
	build_libxml2 || exit 1
	build_aria2 || exit 1
	echo "# Build for $ARCH finish"
done

combine

echo "# Build finish" 
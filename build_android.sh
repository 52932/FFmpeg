
#!/bin/bash 

# 配置NDK环境
NDK=/Users/admin/Downloads/android-ndk-r21c
# 编译工具链目录
TOOLCHAIN_ROOT_DIR=darwin-x86_64
# 交叉编译环境
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$TOOLCHAIN_ROOT_DIR
# 很重要，如果使用静态库必须是 17，否则编译Android项目时会报:  error: undefined reference to ‘atof’
API=17 
# 不知道为什么 64架构的 clang 和 clang++ 最低都是21？
API_64=21

#配置 FFMpeg 编译参数
function build_android {
    echo "Compiling FFmpeg for $CPU" 
    ./configure \
    --prefix=$PREFIX \
    --disable-neon \
    --disable-hwaccels \
    --disable-gpl \
    --disable-postproc \
    --enable-shared \
    --enable-jni \
    --disable-mediacodec \
    --disable-decoder=h264_mediacodec \
    --enable-static \
    --enable-small \
    --enable-zlib \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
    --cross-prefix=$CROSS_PREFIX \
    --target-os=android \
    --arch=$ARCH \
    --cpu=$CPU \
    --cc=$CC
    --cxx=$CXX
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG 
    make clean 
    make -j16
    make install 
    echo "The Compilation of FFmpeg for $CPU is completed" 
}

#armv7-a 
ARCH=arm 
CPU=armv7-a 
CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang 
CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++ 
SYSROOT=$NDK/toolchains/llvm/prebuilt/$TOOLCHAIN_ROOT_DIR/sysroot 
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi- 
PREFIX=$(pwd)/android/$CPU 
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm - march=$CPU " 
ADDI_LDFLAGS=$NDK/android-21/arch-arm/usr/lib
build_android 


# #armv8-a 
# ARCH=aarch64 
# CPU=armv8-a 
# CC=$TOOLCHAIN/bin/aarch64-linux-android$API_64-clang 
# CXX=$TOOLCHAIN/bin/aarch64-linux-android$API_64-clang++ 
# SYSROOT=$NDK/toolchains/llvm/prebuilt/$TOOLCHAIN_ROOT_DIR/sysroot 
# CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android- 
# PREFIX=$(pwd)/android/$CPU 
# OPTIMIZE_CFLAGS="-march=$CPU" 
# build_android

# #x86 
# ARCH=x86 
# CPU=x86 
# CC=$TOOLCHAIN/bin/i686-linux-android$API-clang 
# CXX=$TOOLCHAIN/bin/i686-linux-android$API-clang++ 
# SYSROOT=$NDK/toolchains/llvm/prebuilt/$TOOLCHAIN_ROOT_DIR/sysroot 
# CROSS_PREFIX=$TOOLCHAIN/bin/i686-linux-android- 
# PREFIX=$(pwd)/android/$CPU 
# OPTIMIZE_CFLAGS="-march=i686 -mtune=intel -mssse3 - mfpmath=sse -m32" 
# build_android 

# #x86_64 
# ARCH=x86_64 
# CPU=x86-64 
# CC=$TOOLCHAIN/bin/x86_64-linux-android$API_64-clang 
# CXX=$TOOLCHAIN/bin/x86_64-linux-android$API_64-clang++ 
# SYSROOT=$NDK/toolchains/llvm/prebuilt/$TOOLCHAIN_ROOT_DIR/sysroot
# CROSS_PREFIX=$TOOLCHAIN/bin/x86_64-linux-android- 
# PREFIX=$(pwd)/android/$CPU 
# OPTIMIZE_CFLAGS="-march=$CPU -msse4.2 -mpopcnt -m64 - mtune=intel" 
# build_android
#!/bin/bash

set -e

echo "=== KernelSU Build Script for RMX3461 ==="
echo ""

# Configuration
KERNEL_SOURCE="https://github.com/realme-kernel-opensource/realme_GTmaster_Q3s_Q3t_9-5G-Speed-AndroidT-kernel-source"
KERNEL_BRANCH="master"
KERNEL_CONFIG="lahaina_defconfig"
CLANG_VERSION="r416183b"
KERNELSU_VERSION="v0.9.5"

cd /kernel

# Step 1: Clone kernel source
echo "[1/7] Cloning kernel source..."
if [ ! -d "kernel_source" ]; then
    git clone --depth=1 -b "$KERNEL_BRANCH" "$KERNEL_SOURCE" kernel_source
else
    echo "Kernel source already exists, skipping clone..."
fi

cd kernel_source

# Step 2: Download Clang
echo "[2/7] Downloading Clang toolchain..."
if [ ! -d "/kernel/clang" ]; then
    mkdir -p /kernel/clang
    cd /kernel/clang
    wget -q "https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android12-release/clang-${CLANG_VERSION}.tar.gz" -O clang.tar.gz
    tar -xzf clang.tar.gz
    rm clang.tar.gz
    cd /kernel/kernel_source
else
    echo "Clang already exists, skipping..."
fi

# Step 3: Download GCC
echo "[3/7] Downloading GCC toolchains..."
if [ ! -d "/kernel/gcc64" ]; then
    mkdir -p /kernel/gcc64
    cd /kernel/gcc64
    wget -q "https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/refs/heads/android12-release.tar.gz" -O gcc64.tar.gz
    tar -xzf gcc64.tar.gz
    rm gcc64.tar.gz
    cd /kernel/kernel_source
fi

if [ ! -d "/kernel/gcc32" ]; then
    mkdir -p /kernel/gcc32
    cd /kernel/gcc32
    wget -q "https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/+archive/refs/heads/android12-release.tar.gz" -O gcc32.tar.gz
    tar -xzf gcc32.tar.gz
    rm gcc32.tar.gz
    cd /kernel/kernel_source
fi

# Step 4: Setup KernelSU
echo "[4/7] Setting up KernelSU ${KERNELSU_VERSION}..."
if [ ! -d "KernelSU" ]; then
    curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s "$KERNELSU_VERSION"
fi

# Step 5: Modify defconfig
echo "[5/7] Configuring kernel..."
CONFIG_PATH="arch/arm64/configs/${KERNEL_CONFIG}"
if [ -f "$CONFIG_PATH" ]; then
    # Add KernelSU config
    if ! grep -q "CONFIG_KSU" "$CONFIG_PATH"; then
        echo "" >> "$CONFIG_PATH"
        echo "# KernelSU" >> "$CONFIG_PATH"
        echo "CONFIG_KSU=y" >> "$CONFIG_PATH"
    fi
    # Add Kprobes config
    if ! grep -q "CONFIG_KPROBES=y" "$CONFIG_PATH"; then
        echo "CONFIG_KPROBES=y" >> "$CONFIG_PATH"
        echo "CONFIG_HAVE_KPROBES=y" >> "$CONFIG_PATH"
        echo "CONFIG_KPROBE_EVENTS=y" >> "$CONFIG_PATH"
    fi
else
    echo "Error: defconfig not found at $CONFIG_PATH"
    echo "Available configs:"
    ls arch/arm64/configs/
    exit 1
fi

# Step 6: Build kernel
echo "[6/7] Building kernel (this may take 30-60 minutes)..."
export PATH="/kernel/clang/bin:/kernel/gcc64/bin:/kernel/gcc32/bin:$PATH"
export ARCH=arm64
export SUBARCH=arm64

make O=out "$KERNEL_CONFIG"
make -j$(nproc) O=out \
    ARCH=arm64 \
    CC=clang \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi- \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    LLVM=1 \
    LLVM_IAS=1

# Step 7: Package with AnyKernel3
echo "[7/7] Packaging with AnyKernel3..."
if [ -f "out/arch/arm64/boot/Image" ]; then
    echo "Kernel built successfully!"
    
    # Clone AnyKernel3
    if [ ! -d "/kernel/AnyKernel3" ]; then
        git clone --depth=1 https://github.com/osm0sis/AnyKernel3 /kernel/AnyKernel3
    fi
    
    # Copy kernel image
    cp out/arch/arm64/boot/Image /kernel/AnyKernel3/
    
    # Copy dtbo if exists
    if [ -f "out/arch/arm64/boot/dtbo.img" ]; then
        cp out/arch/arm64/boot/dtbo.img /kernel/AnyKernel3/
    fi
    
    # Configure AnyKernel3
    cd /kernel/AnyKernel3
    sed -i 's/do.devicecheck=1/do.devicecheck=0/g' anykernel.sh
    rm -rf .git README.md
    
    # Create flashable zip
    DATE=$(date +%Y%m%d_%H%M%S)
    zip -r9 "/kernel/output/KernelSU-RMX3461-${DATE}.zip" * -x .git README.md *placeholder
    
    echo ""
    echo "=== BUILD COMPLETE ==="
    echo "Output: /kernel/output/KernelSU-RMX3461-${DATE}.zip"
else
    echo "ERROR: Kernel build failed!"
    echo "Check the build logs above for errors."
    exit 1
fi

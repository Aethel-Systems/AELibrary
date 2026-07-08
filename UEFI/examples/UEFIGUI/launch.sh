#!/bin/bash
# ============================================================================
# UEFI GUI Application Compilation & Virtual Disk Launch Script
# ============================================================================

set -e

# 定义路径
UEFI_LIB_DIR="../.."
BUILD_DIR="./build"
EFI_APP="BOOTX64.EFI"
DISK_IMG="esp.img"

aethelc main.ae \
        "$UEFI_LIB_DIR/Gfx/uefiFont.ae" \
        "$UEFI_LIB_DIR/Gfx/uefiGfx.ae" \
        "$UEFI_LIB_DIR/Platform/uefiPlatform.ae" \
        --format efi \
        -o "$EFI_APP"

# 创建一个 128MB 的 ESP 镜像
dd if=/dev/zero of=esp.img bs=1M count=128 status=progress

# 格式化为 FAT32
mformat -i esp.img -F -v "ESP" ::

# 创建目录结构
mmd -i esp.img ::/EFI
mmd -i esp.img ::/EFI/BOOT

# 复制 BOOTX64.EFI 到正确位置
mcopy -i esp.img BOOTX64.EFI ::/EFI/BOOT/BOOTX64.EFI

echo "✅ esp.img 创建完成，BOOTX64.EFI 已复制到 EFI/BOOT/"

qemu-system-x86_64 -drive if=pflash,format=raw,readonly=on,file=/opt/homebrew/share/qemu/edk2-x86_64-code.fd -drive format=raw,file=esp.img -net none -m 512M -serial stdio

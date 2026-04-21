#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# ==================== 修改默认 LAN IP 为 192.168.8.1 ====================
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate

# 同时修改 DHCP 地址池（强烈推荐一起改，避免冲突）
sed -i 's/192.168.1.100/192.168.8.100/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.249/192.168.8.249/g' package/base-files/files/bin/config_generate
# =====================================================================

# 临时解决Rust问题
sed -i 's/ci-llvm=true/ci-llvm=false/g' feeds/packages/lang/rust/Makefile

# add date in output file name
sed -i -e '/^IMG_PREFIX:=/i BUILD_DATE := $(shell date +%Y%m%d)' \
       -e '/^IMG_PREFIX:=/ s/ \( (SUBTARGET) /\1- )(BUILD_DATE)/' include/image.mk

# ==================== 添加 Nikki + 依赖 ====================
echo "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main" >> feeds.conf.default

# 强制启用 nikki 所需内核模块（24.10 分支）
cat >> .config << EOF
CONFIG_PACKAGE_kmod-dummy=y
CONFIG_PACKAGE_kmod-tun=y
CONFIG_PACKAGE_kmod-nft-tproxy=y
CONFIG_PACKAGE_kmod-nft-socket=y
CONFIG_PACKAGE_kmod-inet-diag=y
EOF
# ===================================================

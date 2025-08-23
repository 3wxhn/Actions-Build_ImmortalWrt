#!/bin/bash
# 默认添加安装的包列表
# kmods
PACKAGE="$PACKAGE kmod-tcp-bbr kmod-lib-zstd kmod-thermal kmod-input-core kmod-gpio-cascade"
PACKAGE="$PACKAGE kmod-drm kmod-drm-buddy kmod-drm-display-helper kmod-drm-kms-helper kmod-drm-mipi-dbi kmod-drm-ttm"
PACKAGE="$PACKAGE usb-modeswitch kmod-usb-core kmod-usb2 kmod-usb3 kmod-usb-ohci kmod-usb-storage kmod-scsi-generic" # USB驱动
PACKAGE="$PACKAGE kmod-nft-offload kmod-nft-nat"
# base
PACKAGE="$PACKAGE busybox uci luci uhttpd opkg curl openssl-util ds-lite e2fsprogs lsblk resolveip swconfig zram-swap"
# packages
PACKAGE="$PACKAGE bash luci-base nano wget-ssl openssh-sftp-server coremark htop"
PACKAGE="$PACKAGE perl-http-date perlbase-file perlbase-getopt perlbase-time perlbase-unicode perlbase-utf8"
# luci
PACKAGE="$PACKAGE luci-lib-ipkg"
PACKAGE="$PACKAGE luci-i18n-base-zh-cn" 
PACKAGE="$PACKAGE luci-i18n-firewall-zh-cn"
PACKAGE="$PACKAGE luci-i18n-ttyd-zh-cn"
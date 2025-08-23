#!/bin/bash
conf="/etc/opkg/customfeeds.conf"
arch=$(source "/etc/openwrt_release" && echo ${DISTRIB_ARCH})
# sed -i 's/option check_signature/# option check_signature/g' "/etc/opkg.conf"
sed -i '$a\src/gz 3wlh_feed https://packages.11121314.xyz/packages/'${arch} "${conf}"
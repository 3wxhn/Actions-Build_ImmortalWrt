#!/bin/sh
# 固件首次启动时运行的脚本 /etc/uci-defaults/99-custom.sh
# 输出日志文件
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date '+%Y-%m-%d %H:%M:%S')" >> $LOGFILE

# 检查配置文件diy-settings是否存在
SETTINGS_FILE="/etc/config/diy-settings"
if [ -f "$SETTINGS_FILE" ]; then
   # 读取diy-settings信息
   source "$SETTINGS_FILE"
fi
#====================添加插件源====================
# sed -i "s/option check_signature/# option check_signature/g" "/etc/opkg.conf"
opkg-conf="/etc/opkg/customfeeds.conf"
sed -i '$a\src/gz 3wlh https://packages.11121314.xyz/packages/aarch64_generic' ${opkg-conf}
#====================设置LAN口IP====================
if [ -n "${settings_lan}" ]; then
uci set network.lan.ipaddr="${settings_lan}"
uci commit network
fi
#==========================Dropbear==========================
# 设置所有网口可连接 SSH
# uci set dropbear.@dropbear[0].Interface=''
# uci commit dropbear

#==========================Fstab==========================
# 自动挂载未配置的Swap
uci set fstab.@global[0].anon_swap="0"
# 自动挂载未配置的磁盘
uci set fstab.@global[0].anon_mount="0"
# 自动挂载交换分区
uci set fstab.@global[0].auto_swap="0"
# 自动挂载磁盘
uci set fstab.@global[0].auto_mount="1"
uci commit fstab

#==========================TTYD==========================
[[ -f "/etc/config/ttyd" ]] && uci delete ttyd.@ttyd[0].interface
uci commit ttyd

#==========================ARGON==========================
if [ ! -n "$(uci -q get argon.@global[])" ]; then
	echo "" > "/etc/config/argon"
	uci add argon global
	uci commit argon
fi
uci set argon.@global[0].online_wallpaper="none"
uci set argon.@global[0].mode="light"
uci set argon.@global[0].bing_background="0"
uci set argon.@global[0].primary="#5e72e4"
uci set argon.@global[0].dark_primary="#483d8b"
uci set argon.@global[0].blur="1"
uci set argon.@global[0].blur_dark="1"
uci set argon.@global[0].transparency="0.2"
uci set argon.@global[0].transparency_dark="0.2"
uci commit argon

#==========================DHCP==========================
# 强制此接口DHCP
uci set dhcp.lan.force='1'
# 删除 DNS重定向
uci -q delete dhcp.@dnsmasq[0].dns_redirect
# 禁用 ipv6 DHCP
# DHCPv6 服务
uci -q delete dhcp.lan.dhcpv6
# RA 服务
uci -q delete dhcp.lan.ra
# NDP 代理
uci -q delete dhcp.lan.ndp
# 禁用 ipv6 解析
# uci set dhcp.@dnsmasq[0].filter_aaaa="1"
uci commit dhcp

#==========================Firewall==========================
# 默认设置WAN口防火墙打开
uci set firewall.@zone[1].input='ACCEPT'
uci commit firewall

#==========================Network==========================
# 删除 WAN6 口
uci -q delete network.wan6
# 设置拨号协议
if $enable_pppoe; then
	uci set network.wan.proto="pppoe"
	echo "PPPoE_Protocol configuration completed successfully." >> $LOGFILE
fi
if [ -n "${pppoe_account}" ]; then
   uci set network.wan.username=$pppoe_account
   echo "PPPoE_Account configuration completed successfully." >> $LOGFILE
fi
if [ -n "${pppoe_password}" ]; then
   uci set network.wan.password=$pppoe_password
   echo "PPPoE_Password configuration completed successfully." >> $LOGFILE
fi
uci commit network

#==========================System==========================
# 关闭系统 Blue_led
Blue_LED=$(find "/sys/class/leds/" -type l -name "*blue*" | sed "s|.*/||g")
if [ -n "${Blue_LED}" ]; then
	uci set system.led_blue="led"
	uci set system.led_blue.name="Blue"
	uci set system.led_blue.sysfs="${Blue_LED}"
	uci set system.led_blue.trigger="none"
	uci set system.led_blue.default="0"
fi
# 关闭系统 Green_led
Green_LED=$(find "/sys/class/leds/" -type l -name "*green*" | sed "s|.*/||g")
if [ -n "${Green_LED}" ]; then
	uci set system.led_green="led"
	uci set system.led_green.name="Green"
	uci set system.led_green.sysfs="${Green_LED}"
	uci set system.led_green.trigger="none"
	uci set system.led_green.default="0"
fi
# 更改名称
if [ -n "${settings_model}" ]; then
uci set system.@system[0].hostname="${settings_model}"
fi
uci commit system
# 设置编译作者信息
FILE_PATH="/etc/openwrt_release"
NEW_DESCRIPTION="Compiled by 3wlh"
sed -i "s/DISTRIB_DESCRIPTION='[^']*'/DISTRIB_DESCRIPTION='$NEW_DESCRIPTION'/" "$FILE_PATH"
# 删除配置文件
rm -f "${SETTINGS_FILE}"
exit 0

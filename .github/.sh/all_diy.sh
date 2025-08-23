#!/bin/bash
[[ -d "$(pwd)/files/etc/uci-defaults" ]] || mkdir -p "$(pwd)/files/etc/uci-defaults"
[[ -f "$(pwd)/files/99-custom.sh" ]] && \
mv -f "$(pwd)/files/99-custom.sh" "$(pwd)/files/etc/uci-defaults"
[[ -f "$(pwd)/all/sys-passwd.sh" ]] && \
mv -f "$(pwd)/all/sys-passwd.sh" "$(pwd)/files/etc/uci-defaults"
[[ -f "$(pwd)/all/sys-opkg.sh" ]] && \
mv -f "$(pwd)/all/sys-opkg.sh" "$(pwd)/files/etc/uci-defaults"

[[ -d "$(pwd)/files/etc/profile.d" ]] || mkdir -p "$(pwd)/files/etc/profile.d"
[[ -f "$(pwd)/all/sys-sysinfo.sh" ]] && \
mv -f "$(pwd)/all/sys-sysinfo.sh" "$(pwd)/files/etc/profile.d"
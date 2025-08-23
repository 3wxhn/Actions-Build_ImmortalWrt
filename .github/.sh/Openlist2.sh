echo "$(date '+%Y-%m-%d %H:%M:%S') - 下载 luci-app-openlist2 ..."
Data="$(curl -s https://api.github.com/repos/sbwml/luci-app-openlist2/releases/latest)"
gz_url="$(echo "${Data}" | grep -Eo '"browser_download_url":\s*".*openwrt-24.10-'${1}'.tar.gz"' | cut -d '"' -f 4)"
echo "Downloading ${gz_url}"
if [[ "$(du -b "$(pwd)/packages/diy_packages/$(basename ${gz_url})" 2>/dev/null | awk '{print $1}')" -ge "20000" ]]; then
	echo "######################################################################## 100.0%"
else	
	find $(pwd)/packages/diy_packages/ -type f -name "$(basename ${gz_url})" -exec rm -f {} \;
	curl -# -L --fail "${gz_url}" -o "$(pwd)/packages/diy_packages/$(basename ${gz_url})"
    # #wget -qO "$(pwd)/packages/diy_packages/$(basename $Download_URL)" "${Download_URL}" --show-progress
    # 删除 GitHub 缓存
    echo "cache=delete" >> "$(pwd)/bin/.bashrc"
fi
find $(pwd)/packages/diy_packages/ -type f -name "$(basename ${gz_url})" -exec tar -zxf {} -C "$(pwd)/packages/diy_packages/" \;
find $(pwd)/packages/diy_packages/packages_ci -type f -name "*.[ia]pk" -exec mv -f {} "$(pwd)/packages/diy_packages/" \;
rm -rf $(pwd)/packages/diy_packages/packages_ci
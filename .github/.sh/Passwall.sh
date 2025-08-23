#!/bin/bash
Data="$(curl -s https://api.github.com/repos/xiaorouji/openwrt-passwall/releases/latest)"
Zip_url="$(echo "${Data}" | grep -Eo '"browser_download_url":\s*".*passwall_packages_ipk_'${1}'.zip"' | cut -d '"' -f 4)"
luci_url="$(echo "${Data}" | grep -Eo '"browser_download_url":\s*".*luci-'${2}'.*\.ipk"' | head -1 | cut -d '"' -f 4)"
i18n="$(echo "${Data}" | grep -Eo '"browser_download_url":\s*".*luci-'${2}'.*\.ipk"' | tail -1 | cut -d '"' -f 4)"
Download_url=(${Zip_url} ${luci_url} ${i18n})
for url in "${Download_url[@]}"; do
echo "Downloading ${url}"
if [[ "$(du -b "$(pwd)/packages/diy_packages/$(basename ${url})" 2>/dev/null | awk '{print $1}')" -ge "10000" ]]; then
	echo "######################################################################## 100.0%"
else	
	find $(pwd)/packages/diy_packages/ -type f -name "$(echo "$(basename ${url})")" -exec rm -f {} \;
	curl -# -L --fail "${url}" -o "$(pwd)/packages/diy_packages/$(basename ${url})"
    # #wget -qO "$(pwd)/packages/diy_packages/$(basename $Download_URL)" "${Download_URL}" --show-progress
    # 删除 GitHub 缓存
    echo "cache=delete" >> "$(pwd)/bin/.bashrc"
fi
done
find $(pwd)/packages/diy_packages/ -type f -name "$(echo "$(basename ${Zip_url})")" -exec unzip -oq {} -d "$(pwd)/packages/diy_packages/" \;
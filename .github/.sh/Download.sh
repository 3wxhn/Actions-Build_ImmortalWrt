#!/bin/bash
echo "Downloading ${1}"
if [[ "$(du -b $(pwd)/packages/diy_packages/$(basename ${1}) 2>/dev/null | awk '{print $1}')" -ge "512" ]]; then
    echo "######################################################################## 100.0%"
else
    find $(pwd)/packages/diy_packages/ -type f -name "$(echo "$(basename ${1})" | cut -d "_" -f 1)" -exec rm -f {} \;
    curl -# -L --fail "${1}" -o "$(pwd)/packages/diy_packages/$(basename ${1})"
    # #wget -qO "$(pwd)/packages/diy_packages/$(basename $Download_URL)" "${Download_URL}" --show-progress
    # 删除 GitHub 缓存
    echo "cache=delete" >> "$(pwd)/bin/.bashrc"
fi
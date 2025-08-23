#!/bin/bash
Kernel=$(find "$(pwd)/build_dir/" -type f -name "kernel_*.[ia]pk" 2>/dev/null -exec basename {} \;)
[[ -n "${Kernel}" ]] && echo "$(date '+%Y-%m-%d %H:%M:%S') - Kernel版本：$(basename ${Kernel})"
cat "$(pwd)/repositories.conf" | \
while IFS= read -r LINE; do
    [[ -z "$(echo "${LINE}" | grep -Eo "^src/gz .*kmods")" ]] && continue
    url=$(echo "${LINE}" | cut -d " " -f 3)
    [[ -z "${url}" ]] && continue
	kmods_url="${url%/*}"
	kmods_version="${url##*/}"
	echo "$(date '+%Y-%m-%d %H:%M:%S') - kmods版本：${kmods_version}"
done
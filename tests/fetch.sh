#!/bin/bash
set +x
NEXUS_USER=$1
NEXUS_PASSWORD=$2
NEXUS_URL=$3

files=$(curl -XPOST -s --user "${NEXUS_USER}:${NEXUS_PASSWORD}" ${NEXUS_URL}/service/extdirect -d '{"action":"coreui_Component","method":"readAssets","data":[{"page":1,"start":0,"limit":100000,"sort":[{"property":"name","direction":"ASC"}],"filter":[{"property":"repositoryName","value":"rawpackage"}]}],"type":"rpc","tid":42}' -H 'Content-Type: application/json' | jq '.result.data[] | .name' | sed 's/"//g')

echo "${files}"
for file in ${files}; do
    echo "feeding ${file}"
    mkdir -p ${file%/*}
    curl -o $file --user "${NEXUS_USER}:${NEXUS_PASSWORD}" ${NEXUS_URL}/repository/rawpackage/${file}
done
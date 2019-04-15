#!/bin/bash
set -e
NEXUS_USER=$1
NEXUS_PASSWORD=$2
NEXUS_URL=$3
for file in $(find tests/binaries); do
    curl -k --user "${NEXUS_USER}:${NEXUS_PASSWORD}" --upload-file ${file} ${NEXUS_URL}/repository/rawpackage/${file}
    echo "upload ${file} done!!"
done

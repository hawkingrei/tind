#!/usr/bin/env bash
set -x
TIDB_VERSION_SLICE=('v5.1.1' 'v5.1.0' 'v5.0.3' 'v4.0.14')
 
for version in "${TIDB_VERSION_SLICE[@]}"
do
    export TIDB_VERSION=${version}
    echo ${version}
	docker build -t hawkingrei/tind:${TIDB_VERSION}  --build-arg TIDB_VERSION .
    docker push hawkingrei/tind:${TIDB_VERSION}
done
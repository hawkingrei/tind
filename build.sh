#!/usr/bin/env bash
set -x
TIDB_VERSION_SLICE=(
    'v5.2.0'
    'v5.1.1' 
    'v5.1.0' 
    'v5.0.3' 
    'v4.0.14'
    'v4.0.13'
    'v4.0.12'
    'v4.0.11'
    'v4.0.10'
    'v4.0.9'
    'v4.0.8'
    'v4.0.7'
    'v4.0.6'
    'v4.0.5'
    'v4.0.4'
    'v4.0.3'
    'v4.0.2'
    'v4.0.1'
    'v4.0.0'
)
 
for version in "${TIDB_VERSION_SLICE[@]}"
do
    export TIDB_VERSION=${version}
    echo ${version}
	docker build -t hawkingrei/tind:${TIDB_VERSION}  --build-arg TIDB_VERSION .
    docker push hawkingrei/tind:${TIDB_VERSION}
done
#!/usr/bin/env bash
set -x
TIDB_VERSION_SLICE=(
    'v6.6.0'
    'v6.5.0'
    'v6.2.0'
    'v5.2.2'
    'v5.2.1'
    'v5.2.0'
    'v5.1.2'
    'v5.1.1' 
    'v5.1.0'
    'v5.0.4'
    'v5.0.3'
    'v4.0.15'
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
    export BUILD_VERSION=1
    echo ${version}
	docker build --no-cache -t hawkingrei/tind:${TIDB_VERSION}  --build-arg TIDB_VERSION  --build-arg BUILD_VERSION .
    docker push hawkingrei/tind:${TIDB_VERSION}
    export BUILD_VERSION=2
    docker build -t hawkingrei/tind:${TIDB_VERSION}-standalone  --build-arg TIDB_VERSION  --build-arg BUILD_VERSION .
    docker push hawkingrei/tind:${TIDB_VERSION}-standalone
done

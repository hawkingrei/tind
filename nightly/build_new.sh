#!/usr/bin/env bash
set -x
TIDB_VERSION_SLICE=(
    'v6.2.0'
)
 
for version in "${TIDB_VERSION_SLICE[@]}"
do
    export TIDB_VERSION=${version}
    export BUILD_VERSION=1
    echo ${version}
	docker build --no-cache -t hawkingrei/tind:${TIDB_VERSION}  --build-arg TIDB_VERSION  --build-arg BUILD_VERSION -f Dockerfile.new .
    docker push hawkingrei/tind:${TIDB_VERSION}
    export BUILD_VERSION=2
    docker build -t hawkingrei/tind:${TIDB_VERSION}-standalone  --build-arg TIDB_VERSION  --build-arg BUILD_VERSION -f Dockerfile.new .
    docker push hawkingrei/tind:${TIDB_VERSION}-standalone
done
ARG BUILD_VERSION=1

FROM golang:bullseye as builder
RUN git clone --branch=debug_cpu_usage https://github.com/hawkingrei/tidb.git --depth=1
RUN cd tidb && make


FROM buildpack-deps:focal as base
COPY setup.sh /
ARG TIDB_VERSION=v6.4.0
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
COPY tidb.conf /etc/supervisor/conf.d/
COPY tikv.conf /etc/supervisor/conf.d/
COPY pd.conf /etc/supervisor/conf.d/
COPY tidb.toml /conf/tidb.toml
COPY tikv.toml /conf/tikv.toml
COPY entrypoint.sh /
COPY --from=builder /go/tidb/bin/tidb-server /bin/
ADD https://download.pingcap.org/tidb-community-server-${TIDB_VERSION}-linux-amd64.tar.gz /
RUN chmod +x entrypoint.sh && bash setup.sh && rm /setup.sh && tar -xvf tidb-community-server-${TIDB_VERSION}-linux-amd64.tar.gz && \
    cd tidb-community-server-${TIDB_VERSION}-linux-amd64 && \
    tar -xvf pd-${TIDB_VERSION}-linux-amd64.tar.gz && \
    tar -xvf tidb-${TIDB_VERSION}-linux-amd64.tar.gz && \
    tar -xvf tikv-${TIDB_VERSION}-linux-amd64.tar.gz && \
    cp -r tikv-server /bin/ && \
    cp -r pd-server /bin/ && \
    rm -rf tidb-community-server-${TIDB_VERSION}-linux-amd64* && \
    mkdir -p /data/tikv && mkdir -p /data/pd


FROM base AS branch-version-1


FROM base AS branch-version-2
ENTRYPOINT ["/entrypoint.sh"]

FROM branch-version-${BUILD_VERSION} AS after-condition

FROM after-condition 
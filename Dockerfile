ARG BUILD_VERSION=1

FROM buildpack-deps:focal as base
COPY setup.sh /
ARG TIDB_VERSION=v5.1.0
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
COPY tidb.conf /etc/supervisor/conf.d/
COPY tikv.conf /etc/supervisor/conf.d/
COPY pd.conf /etc/supervisor/conf.d/
COPY tidb.toml /conf/tidb.toml
COPY tikv.toml /conf/tikv.toml
COPY entrypoint.sh /
ADD https://tiup-mirrors.pingcap.com/tidb-${TIDB_VERSION}-linux-amd64.tar.gz /
RUN chmod +x entrypoint.sh && bash setup.sh && rm /setup.sh && tar -xvf tidb-${TIDB_VERSION}-linux-amd64.tar.gz && \
    cp -r tidb-${TIDB_VERSION}-linux-amd64/bin/tikv-server /bin/ && \
    cp -r tidb-${TIDB_VERSION}-linux-amd64/bin/tidb-server /bin/ && \
    cp -r tidb-${TIDB_VERSION}-linux-amd64/bin/pd-server /bin/ && \
    rm -rf tidb-${TIDB_VERSION}-linux-amd64* && \
    mkdir -p /data/tikv && mkdir -p /data/pd

FROM base AS branch-version-1


FROM base AS branch-version-2
ENTRYPOINT ["/entrypoint.sh"]

FROM branch-version-${BUILD_VERSION} AS after-condition

FROM after-condition 
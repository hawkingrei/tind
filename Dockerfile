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
ADD https://tiup-mirrors.pingcap.com/pd-${TIDB_VERSION}-linux-amd64.tar.gz /
ADD https://tiup-mirrors.pingcap.com/tikv-${TIDB_VERSION}-linux-amd64.tar.gz /
RUN chmod +x entrypoint.sh && bash setup.sh && rm /setup.sh && \
    tar -xvf tidb-${TIDB_VERSION}-linux-amd64.tar.gz && \
    tar -xvf pd-${TIDB_VERSION}-linux-amd64.tar.gz && \
    tar -xvf tikv-${TIDB_VERSION}-linux-amd64.tar.gz && \
    cp -r tikv-server /bin/ && \
    cp -r tidb-server /bin/ && \
    cp -r pd-server /bin/ && \
    rm -rf tikv-server && \
    rm -rf tidb-server && \
    rm -rf pd-server && \
    rm -rf tidb-${TIDB_VERSION}-linux-amd64.tar.gz && \
    rm -rf tikv-${TIDB_VERSION}-linux-amd64.tar.gz && \
    rm -rf pd-${TIDB_VERSION}-linux-amd64.tar.gz && \
    mkdir -p /data/tikv && mkdir -p /data/pd

FROM base AS branch-version-1


FROM base AS branch-version-2
ENTRYPOINT ["/entrypoint.sh"]

FROM branch-version-${BUILD_VERSION} AS after-condition

FROM after-condition 
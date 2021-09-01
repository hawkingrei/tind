FROM buildpack-deps:focal
COPY setup.sh /
ARG TIDB_VERSION=v5.1.0
COPY tidb.conf /etc/supervisor/conf.d/
COPY tikv.conf /etc/supervisor/conf.d/
COPY pd.conf /etc/supervisor/conf.d/
COPY tidb.toml /conf/tidb.toml
COPY tikv.toml /conf/tikv.toml
COPY entrypoint.sh /
ADD https://download.pingcap.org/tidb-${TIDB_VERSION}-linux-amd64.tar.gz /
RUN chmod +x entrypoint.sh && bash setup.sh && rm /setup.sh && tar -xvf tidb-${TIDB_VERSION}-linux-amd64.tar.gz && \
    cp -r tidb-${TIDB_VERSION}-linux-amd64/bin/* /bin/ && rm -rf tidb-${TIDB_VERSION}-linux-amd64* && \
    mkdir -p /data/tikv && mkdir -p /data/pd

FROM debian:stretch
LABEL maintainer=taherbs
ARG ARTIFACT_DIR=./docker/proxysql

### Install ProxySql package and Supervisord ###
ENV VERSION 2.0.4
RUN apt-get update && \
    apt-get install -y lsb-core gnupg2 wget inotify-tools procps supervisor && \
    wget https://github.com/sysown/proxysql/releases/download/v${VERSION}/proxysql_${VERSION}-debian9_amd64.deb -O /opt/proxysql_${VERSION}-debian9_amd64.deb && \
    dpkg -i /opt/proxysql_${VERSION}-debian9_amd64.deb && \
    rm -f /opt/proxysql_${VERSION}-debian9_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

### Install Percona package - PMM-Client ###
RUN wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb && \
    dpkg -i percona-release_latest.generic_all.deb && \
    apt-get update && apt-get install pmm-client


VOLUME /var/lib/proxysql
EXPOSE 6032 6033 6080

COPY $ARTIFACT_DIR/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

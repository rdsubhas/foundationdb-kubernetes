FROM ubuntu:16.04

WORKDIR /opt/foundationdb
ADD scripts/prepare.sh scripts/prepare.sh
RUN scripts/prepare.sh

ADD scripts scripts
ADD conf conf

VOLUME ["/var/lib/foundationdb"]
ENTRYPOINT ["/tini", "--"]
CMD ["/opt/foundationdb/scripts/run.sh"]

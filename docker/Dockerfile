FROM ubuntu:16.04

ADD scripts/prepare.sh /prepare.sh
RUN /prepare.sh

# fdb kubernetes service hostname
ENV FDB_ID="fdb" \
    FDB_DESC="fdb" \
    FDB_COORDINATORS="fdb" \
    FDB_HOME="/var/lib/foundationdb"

WORKDIR $FDB_HOME
ADD scripts/run.sh run.sh
VOLUME ["/var/lib/foundationdb/data"]
ENTRYPOINT ["tini", "--"]
CMD ["/var/lib/foundationdb/run.sh"]

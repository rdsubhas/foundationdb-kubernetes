#!/usr/bin/env sh
set -xe

export DEBIAN_FRONTEND=noninteractive
apt-get -qq -y update
apt-get -qq -y install --no-install-recommends --no-install-suggests \
  curl ca-certificates python

# dumb-init
tini_version="v0.17.0"
curl -fsSL "https://github.com/krallin/tini/releases/download/${tini_version}/tini" > /tini
chmod +x /tini

# install
fdb_version="5.1.5"
curl -fsSL "https://www.foundationdb.org/downloads/${fdb_version}/ubuntu/installers/foundationdb-clients_${fdb_version}-1_amd64.deb" > foundationdb-client.deb
curl -fsSL "https://www.foundationdb.org/downloads/${fdb_version}/ubuntu/installers/foundationdb-server_${fdb_version}-1_amd64.deb" > foundationdb-server.deb
dpkg --force-confdef --install foundationdb-client.deb foundationdb-server.deb

# unconfigure
/etc/init.d/foundationdb stop
sleep 5
rm -Rf /var/lib/foundationdb /var/log/foundationdb /etc/foundationdb

# cleanup
apt-get -qq -y --force-yes --purge remove curl
rm -Rf *.deb /var/lib/apt/lists/* /var/cache/apt/*

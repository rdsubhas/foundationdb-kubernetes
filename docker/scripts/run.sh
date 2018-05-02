#!/bin/bash
set -e

cd $FDB_HOME
mkdir -p data logs

echo "Generating fdb.cluster..."
fdb_ips=$( (dig +short $FDB_COORDINATORS || echo $FDB_COORDINATORS) | head -n1)
fdb_ips=$(echo $fdb_ips | sed -e 's/$/:4500/g' | tr '\n' ',')
fdb_ips=${fdb_ips%,}
echo $FDB_DESC:$FDB_ID@$fdb_ips > fdb.cluster
cat fdb.cluster

usermod -u 2005 foundationdb
groupmod -g 2005 foundationdb
chown -R foundationdb:foundationdb .
chmod -R 0700 $FDB_HOME
chmod 0644 fdb.cluster

echo "Starting foundationdb..."
gosu foundationdb:foundationdb /usr/sbin/fdbserver \
  --cluster_file $FDB_HOME/fdb.cluster \
  --datadir $FDB_HOME/data \
  --logdir $FDB_HOME/logs \
  --machine_id $(hostname) \
  --listen_address public \
  --public_address auto:4500

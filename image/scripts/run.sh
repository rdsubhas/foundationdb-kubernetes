#!/usr/bin/env sh
set -xe

mkdir -p /var/log/foundationdb /etc/foundationdb /var/lib/foundationdb/data

if [ ! -f /etc/foundationdb/fdb.cluster ]; then
  if [ -f /var/lib/foundationdb/fdb.cluster ]; then
    echo "Using /var/lib/foundationdb/fdb.cluster..."
    cp /var/lib/foundationdb/fdb.cluster /etc/foundationdb/
  else
    echo "Creating test /etc/foundationdb/fdb.cluster..."
    description=`LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 8`
    random_str=`LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 8`
    echo $description:$random_str@127.0.0.1:4500 > /etc/foundationdb/fdb.cluster
    chown foundationdb:foundationdb /etc/foundationdb/fdb.cluster
    chmod 0664 /etc/foundationdb/fdb.cluster
  fi
fi

if [ ! -f /etc/foundationdb/foundationdb.conf ]; then
  if [ -f /var/lib/foundationdb/foundationdb.conf ]; then
    echo "Using /var/lib/foundationdb/foundationdb.conf..."
    cp /var/lib/foundationdb/foundationdb.conf /etc/foundationdb/
  else
    echo "Using /opt/foundationdb/conf/foundationdb.conf..."
    cp /opt/foundationdb/conf/foundationdb.conf /etc/foundationdb/
  fi
fi

usermod -u 2005 foundationdb
groupmod -g 2005 foundationdb
chown -R foundationdb:foundationdb /var/lib/foundationdb /var/log/foundationdb /etc/foundationdb
chmod -R 0700 /var/lib/foundationdb/data /var/log/foundationdb

/usr/lib/foundationdb/fdbmonitor --conffile /etc/foundationdb/foundationdb.conf

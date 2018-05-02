# foundationdb-kubernetes

## Under development

Docker image for running FoundationDB on kubernetes as a statefulset.

## Quickstart with docker-compose

```
# Start first node
docker-compose up -d --build

# Setup database
docker-compose exec fdb fdbcli --exec "configure new single memory"
> Database created

# Verify status and wait for first node to be healthy
docker-compose exec fdb fdbcli --exec status
> ...
> Data:
>   Replication health     - (Re)initializing automatic data distribution
> ...
> Data:
>   Replication health     - Healthy
> ...

# Scale up
docker-compose up -d --scale fdb=2

# Verify status and see second node
docker-compose exec fdb fdbcli --exec status
> ...
> Cluster:
>   FoundationDB processes - 2
>   Machines               - 2
> ...
> Data:
>   Replication health     - (Re)initializing automatic data distribution
> ...
> Data:
>   Replication health     - Healthy
> ...

# Add more nodes
# docker-compose up -d --scale fdb=<n>

# Destroy
docker-compose down
```

### Pending

- Automatic scaledown/failover
- Automatic memory tuning based on cgroup/k8s memory requests/limits
- Allow tweaking fdbserver configuration flags

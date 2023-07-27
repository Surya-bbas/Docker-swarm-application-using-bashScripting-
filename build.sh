#!/usr/bin/env bash

#sh for network and volume creation
docker network create -d overlay frontend  \
   && \
   docker network create -d overlay backend

docker volume create db-data

#sh to create service - vote
docker service create \
    -p 80:80 \
    --name vote \
    --network frontend \
    --replicas 2 \
    bretfisher/examplevotingapp_vote


#sh to create service - redis
docker service create \
    --name redis \
    --network frontend  \
    redis:3.2

#sh to create service - worker
docker service create \
    --name worker \
    --network frontend \
    --network backend \
    bretfisher/examplevotingapp_worker

#sh to create service - db
docker service  create \
    --name db \
    --mount source=db-data,target=/var/lib/postgresql/data \
    --network backend \
    -e POSTGRES_HOST_AUTH_METHOD=trust \
    postgres:9.4

#sh to create service - result
docker service create \
    --name result \
    -p 5001:80 \
    --network backend \
    bretfisher/examplevotingapp_result

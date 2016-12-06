#!/usr/bin/env bash

docker stop $(docker ps -a -q)
docker-compose rm -f
docker rm $(docker ps -a -q)
docker rmi $(docker images -a -q)


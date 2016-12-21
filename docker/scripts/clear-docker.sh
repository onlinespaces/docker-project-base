#!/usr/bin/env bash

docker stop $(docker ps -aq)
docker-compose rm -f
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images -aq)


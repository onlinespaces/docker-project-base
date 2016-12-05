#!/usr/bin/env bash

# ip addr show docker0;
docker inspect $(docker ps -f name=nginx -q) | grep IPAddress;
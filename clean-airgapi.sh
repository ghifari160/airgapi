#!/bin/bash

docker rm -v pigen_work

docker container prune -f
docker image prune -f
docker volume prune -f

docker system prune --all -f

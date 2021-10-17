#!/bin/bash

. config

export DISCORD_WEBHOOK

curl -X POST -sSL ${DISCORD_WEBHOOK} -H 'Content-Type: application/json' \
    -d '{"username": "AirGaPi Builder", "embeds": [ { "title": "AirGaPi", "color": 30656, "description": "Building AirGaPi...", "footer": { "text": "'"$(date)"'" } } ] }'

echo "Building AirGaPi..."
PRESERVE_CONTAINER=1 CONTINUE=1 PIGEN_DOCKER_OPTS="--env CLEAN=0" ./pi-gen/build-docker.sh
echo "Done!"

curl -X POST -sSL ${DISCORD_WEBHOOK} -H 'Content-Type: application/json' \
    -d '{"username": "AirGaPi Builder", "embeds": [ { "title": "AirGaPi", "color": 65280, "description": "Done!", "footer": { "text": "'"$(date)"'" } } ] }'

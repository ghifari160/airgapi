#!/bin/bash

docker run \
        --rm --privileged \
        -v /dev:/dev \
        -v ${PWD}:/build:ro \
        -v ${PWD}/packer-cache:/root/.cache/packer \
        -v ${PWD}/deploy:/build/output-raspbian \
        packer-builder-arm build "${@}" .

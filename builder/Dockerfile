FROM golang:1.23-alpine AS builder

RUN apk update && \
    apk add git

WORKDIR /

RUN git clone https://github.com/solo-io/packer-plugin-arm-image /build

WORKDIR /build

RUN go mod download && \
    go build

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -yq && \
    apt-get install -yqq \
        binfmt-support \
        qemu-user-static \
        unzip \
        wget \
        curl \
        sudo \
    && rm -rf /var/lib/apt/lists/*

ENV PACKER_VERSION 1.10.3

RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -O /tmp/packer.zip && \
    unzip /tmp/packer.zip -d /bin && \
    rm /tmp/packer.zip

WORKDIR /build

COPY entrypoint.sh /entrypoint.sh

COPY --from=builder /build/packer-plugin-arm-image /bin/packer-plugin-arm-image

ENTRYPOINT [ "/entrypoint.sh" ]

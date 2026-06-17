#!/bin/bash
podman build -t my-typst2 -f - . << 'DOCKERFILE'
FROM docker.io/rust:slim-bullseye AS Builder
ARG TYPST_VERSION=v0.15.0

RUN apt-get update && apt-get install -y --no-install-recommends git pkg-config libssl-dev

WORKDIR /typst

RUN git clone -c advice.detachedHead=false \
    --branch $TYPST_VERSION --single-branch --depth 1 \
    https://github.com/typst/typst.git ./

RUN env -u TYPST_VERSION CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse \
    cargo build -p typst-cli --release

FROM docker.io/debian:bullseye-slim
COPY --from=Builder /typst/target/release/typst /usr/bin/typst
WORKDIR /root
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates
DOCKERFILE

podman run --rm my-typst2 /usr/bin/typst --version

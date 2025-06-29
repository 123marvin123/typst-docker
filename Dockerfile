FROM docker.io/rust:slim-bullseye AS Builder
ARG TYPST_VERSION=v0.13.1

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    git pkg-config libssl-dev

WORKDIR /typst

RUN git clone -c advice.detachedHead=false \
    --branch $TYPST_VERSION --single-branch --depth 1 \
    https://github.com/typst/typst.git ./

RUN CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse cargo build -p typst-cli --release

FROM docker.io/debian:bullseye-slim

COPY --from=Builder /typst/target/release/typst /usr/bin/typst

WORKDIR /root

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates

# syntax=docker/dockerfile:1.27
FROM docker.io/rust:slim-bookworm AS builder
ARG TYPST_VERSION=v0.15.1

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    git pkg-config libssl-dev

WORKDIR /typst

RUN git clone -c advice.detachedHead=false \
    --branch $TYPST_VERSION --single-branch --depth 1 \
    https://github.com/typst/typst.git ./

RUN --mount=type=cache,target=/usr/local/cargo/registry,sharing=locked \
    --mount=type=cache,target=/typst/target,sharing=locked \
    CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse \
    TYPST_VERSION=${TYPST_VERSION#v} cargo build -p typst-cli --locked --release \
    && cp target/release/typst /tmp/typst

FROM docker.io/debian:bookworm-slim

ARG TYPST_VERSION=v0.15.1
ARG UID=1000
ARG GID=1000

LABEL org.opencontainers.image.title="typst" \
      org.opencontainers.image.description="Unofficial bare-bones Typst CLI image" \
      org.opencontainers.image.source="https://github.com/123marvin123/typst-docker" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="${TYPST_VERSION#v}"

COPY --from=builder /tmp/typst /usr/local/bin/typst

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --system --gid ${GID} typst \
    && useradd --system --uid ${UID} --gid ${GID} \
       --home-dir /work --create-home --shell /usr/sbin/nologin typst

USER typst
WORKDIR /work
FROM rust:slim-bullseye AS Builder
ARG TYPST_VERSION=v0.3.0


RUN apt-get --allow-unauthenticated update && \
    apt-get --allow-unauthenticated install -y git pkg-config libssl-dev

RUN git clone --branch $TYPST_VERSION --depth 1 https://github.com/typst/typst.git /typst
RUN cd /typst && CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse cargo build -p typst-cli --release

FROM debian:bullseye-slim

COPY --from=Builder /typst/target/release/typst /usr/bin/typst
WORKDIR /root

# Typst Docker Image

Unofficial, bare-bones Docker image for [Typst](https://github.com/typst/typst). Multi-arch (`linux/amd64`, `linux/arm64/v8`), runs as a non-root user, with a configurable UID/GID.

[![CI](https://github.com/123marvin123/typst-docker/actions/workflows/ci.yml/badge.svg)](https://github.com/123marvin123/typst-docker/actions/workflows/ci.yml)
[![Docker Image Size](https://img.shields.io/docker/image-size/123marvin123/typst)](https://hub.docker.com/r/123marvin123/typst)
[![Docker Pulls](https://img.shields.io/docker/pulls/123marvin123/typst)](https://hub.docker.com/r/123marvin123/typst)

> ⚠️ **No extra fonts installed.** Use the built-in embedded fonts, or mount host fonts (see below).

## Tags

Each Typst release is tagged by version (`v0.15.0`) and rolling minor/major (`0.15`, `0`). We do not ship a `latest` tag until Typst stabilises. Available tags:

- `123marvin123/typst:0.15.0` — exact version
- `123marvin123/typst:0.15` — latest patch of `0.15`
- `123marvin123/typst:0` — latest minor of `0.x`

## Quick start

```bash
docker run --rm -v "$PWD":/work 123marvin123/typst:0.15.0 typst compile thesis.typ
```

```bash
docker run --rm 123marvin123/typst:0.15.0 typst --version
docker run --rm 123marvin123/typst:0.15.0 typst watch thesis.typ
```

## UID / GID

By default the image runs as user `typst` (UID 1000 / GID 1000) inside `/work`. Files written by Typst (e.g. `compile`) are owned by that UID, which usually matches your host user.

To use a different UID/GID at build time:

```bash
docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t my-typst .
```

| Build arg | Default | Purpose |
|-----------|---------|---------|
| `TYPST_VERSION` | `v0.15.0` | Typst git tag to build |
| `UID` | `1000` | Non-root user ID |
| `GID` | `1000` | Non-root group ID |

## Using installed host fonts

The base image contains **no** additional fonts. Use the embedded ones, or mount your system fonts. Common host font paths: `/usr/share/fonts` (Linux), `/System/Library/Fonts` (macOS), or any directory of `.ttf`/`.otf` files you own.

### Mount to `/usr/share/fonts` (read-only)

```bash
docker run --rm -v "$PWD":/work \
  -v <HOST_FONT_DIR>:/usr/share/fonts:ro \
  123marvin123/typst:0.15.0 typst compile thesis.typ
```

### Mount anywhere and point Typst at it

Use `TYPST_FONT_PATHS` to expose one or more custom font directories:

```bash
docker run --rm -v "$PWD":/work \
  -v <HOST_FONT_DIR>:/fonts:ro \
  -e TYPST_FONT_PATHS=/fonts \
  123marvin123/typst:0.15.0 typst compile thesis.typ
```

## Multi-arch

Images are built for `linux/amd64` and `linux/arm64/v8` via GitHub Actions (QEMU + buildx). Pick one explicitly with `--platform`, or let Docker auto-select:

```bash
docker run --rm --platform linux/arm64 123marvin123/typst:0.15.0 typst --version
```

## Building from source

```bash
docker build --build-arg TYPST_VERSION=v0.15.0 -t typst:0.15.0 .
```

## License

Typst is licensed under the [Apache License 2.0](https://github.com/typst/typst/blob/main/LICENSE). This Dockerfile is provided as-is under the same license; see [`LICENSE`](./LICENSE).
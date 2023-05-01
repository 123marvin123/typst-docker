# Typst Docker Image

This is a (unofficial) Docker Image for a bare-bones distribution of [Typst](https://github.com/typst/typst). It is based on Debian and only contains a pre-compiled version of the Typst-CLI. 

❗️*Please note*: **There are no additional fonts installed**. Take a look at the section "Using Installed Host System Fonts" or use the built-in fonts in the pre-compiled binary.

## ⚒️ Running the image

```bash
docker run --name typst -v $(PWD):/root  -it 123marvin123/typst:v0.3.0
```

**In the docker environment, you can use the `typst` command like usual. E.g. `typst compile thesis.typ`.**

*Please note that we will not provide a `latest` tag until Typst has arrived at a stable state without major breaking changes with each release.*

## 🈂️ Using Installed Host System Fonts

The base image of Debian does not contain any additional fonts. This means, you can either use the few built-in fonts that are embedded in the Typst executable, or mount your system's font directory into the docker container. This can be accomplished in two ways:

### Mount system fonts to `/usr/share/fonts`

E.g. on macOS:
```bash
docker run --name typst -it -v /System/Library/Fonts:/usr/share/fonts:ro 123marvin123/typst:v0.3.0
```
This will allow Typst to see the read-only mounted fonts from your host system without having to modify anything.

### Mount system fonts to anywhere

Instead of mounting to `/usr/share/fonts`, you can mount the folder to anywhere (e.g. `/root/fonts`) and then modify the environment variable `TYPST_FONT_PATHS`. Using this technique, you can also mount more than one folder:

E.g. on macOS:
```bash
docker run --name typst -it -v /System/Library/Fonts:/root/fonts:ro --env TYPST_FONT_PATHS=/root/fonts 123marvin123/typst:v0.3.0
```
This only has to be done once you create the container.

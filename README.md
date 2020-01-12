
# Docker images for the Nix package manager

This repository builds a minimal Docker image for the
[Nix](https://nixos.org/nix) package manager.  The current [official docker
image for Nix](https://hub.docker.com/r/nixos/nix/) is based on Alpine, this
image that is build from scratch and looks a lot more like
[nixos](https://nixos.org/nixos).

Nix, bash and coreutils are installed in a system profile that is linked to
`/run/current-system/sw`, the only global paths are `/bin/sh` and
`/usr/bin/env`

It's easy to create an image with a custom version of nix or nixpkgs.

## Default image

The default image is intended for interactive use and includes some common and
useful packages:

```sh
docker run --rm -it monacoremo/nix nix repl '<nixpkgs>'
nix-repl>

```

## CircleCI image

The CircleCI image is intended as an efficient base for CircleCI jobs that are
based on Nix.

## Building an Image

```Dockerfile
FROM monacoremo/nix:2020-01-02

RUN nix-env -iA \
 nixpkgs.curl \
 nixpkgs.jq

```

## Building and pushing images

`nix-docker-build` builds all images and tags them in Docker:

```sh
nix-shell --run nix-docker-build

```

`nix-docker` will build, push and clean all images:

```sh
nix-shell --run nix-docker

```

## Custom `nixpgs`

The `src` can also can be overridden to use a custom
[nixpkgs](https://github.com/NixOS/nixpkgs) for the image.

```sh
nix-shell --argstr src ./srcs/2020-01-02.nix nix-docker-build

```

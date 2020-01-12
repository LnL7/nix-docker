# [nix-docker](https://hub.docker.com/r/monacoremo/nix/tags)

Docker images for the Nix package manager

This repository contains nix expressions to build a minimal docker image for
the [nix](https://nixos.org/nix) package manager.  The current [official docker
image for nix](https://hub.docker.com/r/nixos/nix/) is based on alpine, this
image that is build from scratch and looks a lot more like
[nixos](https://nixos.org/nixos).

- nix, bash and coreutils are installed in a system profile that is linked to
  `/run/current-system/sw`, the only global paths are `/bin/sh` and
  `/usr/bin/env`
- it's easy to build a new custom baseimage using a specific version of
  nixpkgs, this makes it a lot easier to create an image with a custom version
  of nix or nixpkgs.


## Default Image

The default image is intended for interactive use and includes some common and
useful packages:

```sh
docker run --rm -it monacoremo/nix nix repl '<nixpkgs>'
nix-repl>

```

## Building an Image

```Dockerfile
FROM monacoremo/nix:2020-01-02

RUN nix-env -iA \
 nixpkgs.curl \
 nixpkgs.jq

```

## Building a new Base Image

```sh
nix-shell --run nix-docker-build

```

The `src` can also can be overridden to use a custom i
[nixpkgs](https://github.com/NixOS/nixpkgs) for the image.

```sh
nix-shell --argstr src ./srcs/2020-01-02.nix nix-docker-build

```

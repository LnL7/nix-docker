# [nix-docker](https://hub.docker.com/r/lnl7/nix)

Docker images for the Nix package manager

This repository contains nix expressions to build a minimal docker image for the [nix](https://nixos.org/nix) package manager.
The current official image for [nix](https://hub.docker.com/r/nixos/nix/) is based on alpine, this image that is build from scratch and looks a lot more like [nixos](https://nixos.org/nixos).

- nix, bash and coreutils are installed in a system profile that is linked to `/run/current-system/sw`,
  the only global paths are `/bin/sh` and `/usr/bin/env`

- it's easy to build a new custom baseimage using a specific version of nixpkgs,
  this makes it a lot easier to create an image with a custom version of nix or nixpkgs.

- the lnl7/nix:ssh image can be used to setup an image that can be used as a remote builder,
  this allows you to build expressions for `x86_64-linux` on other platforms (ex. building a new baseimage on a darwin machine)


## Default Image


The default image uses [272cf5c](https://github.com/NixOS/nixpkgs/tree/272cf5c44fbe973c33e9dde9a40c458a341d48cc) with some common packages installed.
```sh
docker run --rm -it lnl7/nix nix-repl '<nixpkgs>'
nix-repl> 
```

## Building an Image

```Dockerfile
FROM lnl7/nix:1.11.2

RUN nix-env -iA \
 nixpkgs.curl \
 nixpkgs.jq
```

## Building a new Base Image

```sh
nix-build -A docker
docker build -t nix:base result
```

The expression also includes an `env` attribute that copies the outputs to the current directory.
Both the `nixpkgs` attribute can be overridden to use a custom [nixpkgs](https://github.com/NixOS/nixpkgs) for the image.

```sh
nix-shell -A env --arg nixpkgs /tmp/custom-nixpkgs --argstr system x86_64-linux
[nix-shell:/tmp]$ docker build -t nix:base .
```

## Running as a [remote builder](https://nixos.org/wiki/Distributed_build)

```sh
docker run --restart always --name nix-docker -d -p 3022:22 lnl7/nix:ssh
```

If you have not setup a remote builder before you can follow these steps.

#### Configure ssh

```sh
mkdir -p /etc/nix
chmod 600 ssh/insecure_rsa
cp ssh/insecure_rsa /etc/nix/docker_rsa
```

Add an entry for the container in your `~/.ssh_config`, at this point you should be able to ssh to the container.

> Note: If you use docker-machine you'll have to use `docker-machine ip` as the host instead of localhost.

```sshconfig
Host nix-docker
  User root
  HostName 127.0.0.1
  Port 3022
  IdentityFile /etc/nix/docker_rsa
```

Optionally you can setup your own ssh key, instead of using the insecure key.

```sh
ssh-keygen -t rsa -b 2048 -N "" -f docker_rsa
scp docker_rsa.pub nix-docker:/root/.ssh/authorized_keys
cp docker_rsa /etc/nix/
```

#### Create a signing keypair

```sh
openssl genrsa -out /etc/nix/signing-key.sec 2048
openssl rsa -in /etc/nix/signing-key.sec -pubout > /etc/nix/signing-key.pub
chmod 600 /etc/nix/signing-key.sec
ssh nix-docker mkdir -p /etc/nix
scp /etc/nix/signing-key.sec nix-docker:/etc/nix/signing-key.sec
```

#### Setup the container as a remote builder

```sh
cp ssh/remote-build-env /etc/nix/
cp ssh/remote-systems.conf /etc/nix/
```

#### Build a linux derivation

```sh
source /etc/nix/remote-build-env
nix-build -A hello --argstr system x86_64-linux 
```

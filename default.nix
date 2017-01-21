{ src ? ./srcs/2017-01-21.nix, nixpkgs ? <nixpkgs>, system ? builtins.currentSystem }:

let
  inherit (pkgs) stdenv buildEnv writeText;
  inherit (pkgs) bashInteractive coreutils cacert gnutar gzip less nix openssh;

  pkgs = import unstable { system = "x86_64-linux"; };

  native = import nixpkgs { inherit system; };
  unstable = native.callPackage src { stdenv = native.stdenvNoCC; };

  tarball = native.callPackage <nixpkgs/nixos/lib/make-system-tarball.nix> {
    contents = [];
    storeContents = map (x: { object = x; symlink = "none"; }) [ path profile ];
    extraArgs = "--owner=0";
  };

  path = buildEnv {
    name = "system-path";
    paths = [ bashInteractive coreutils cacert gnutar gzip less nix ];
  };

  profile = buildEnv {
    name = "user-environment";
    paths = [ ];
  };

  group = writeText "group" ''
    root:x:0:
    nixbld:x:30000:nixbld1,nixbld2
  '';

  passwd = writeText "passwd" ''
    root:x:0:0::/root:/run/current-system/sw/bin/bash
    nixbld1:x:30001:30000::/var/empty:/bin/nologin
    nixbld2:x:30002:30000::/var/empty:/bin/nologin
  '';

  baseDocker = writeText "Dockerfile" ''
    FROM scratch
    ADD nixos-system.tar.xz /

    RUN ["${path}/bin/mkdir", "-p", "/bin", "/usr/bin", "/etc", "/var", "/tmp", "/root/.nix-defexpr", "/run/current-system", "/nix/var/nix/profiles/per-user/root"]
    RUN ["${path}/bin/ln", "-s", "${path}", "/run/current-system/sw"]
    RUN ["${path}/bin/ln", "-s", "/run/current-system/sw/bin/sh", "/bin/sh"]
    RUN ["${path}/bin/ln", "-s", "/run/current-system/sw/bin/env", "/usr/bin/env"]
    RUN ["${path}/bin/ln", "-s", "${profile}", "/nix/var/nix/profiles/per-user/root/profile-1-link"]
    RUN ["${path}/bin/ln", "-s", "/nix/var/nix/profiles/per-user/root/profile-1-link", "/nix/var/nix/profiles/per-user/root/profile"]
    RUN ["${path}/bin/ln", "-s", "/nix/var/nix/profiles/per-user/root/profile", "/root/.nix-profile"]

    ADD group /etc
    ADD passwd /etc

    RUN echo "hosts: files dns myhostname mymachines" > /etc/nsswitch.conf

    ENV GIT_SSL_CAINFO /run/current-system/sw/etc/ssl/certs/ca-bundle.crt
    ENV SSL_CERT_FILE /run/current-system/sw/etc/ssl/certs/ca-bundle.crt
    ENV PATH /root/.nix-profile/bin:/root/.nix-profile/sbin:/run/current-system/sw/bin:/run/current-system/sw/sbin
    ENV MANPATH /root/.nix-profile/share/man:/run/current-system/sw/share/man
    ENV NIX_PATH /root/.nix-defexpr/channels

    RUN nix-store --init && nix-store --load-db < nix-path-registration \
     && rm env-vars pathlist nix-path-registration closure-*

    CMD ["bash"]
  '';

  pkgsDocker = writeText "Dockerfile" ''
    FROM lnl7/nix:${unstable.version}
    RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable \
     && nix-channel --update
  '';

  latestDocker = writeText "Dockerfile" ''
    FROM lnl7/nix:${(builtins.parseDrvName nix.name).version}

    RUN nix-env -iA \
     nixpkgs.curl \
     nixpkgs.findutils \
     nixpkgs.git \
     nixpkgs.glibc \
     nixpkgs.gnugrep \
     nixpkgs.gnused \
     nixpkgs.gnutar \
     nixpkgs.jq \
     nixpkgs.netcat \
     nixpkgs.nix \
     nixpkgs.nix-prefetch-scripts \
     nixpkgs.nix-repl \
     nixpkgs.silver-searcher \
     nixpkgs.vim \
     nixpkgs.which \
     && nix-store --optimize
  '';

  sshDocker = writeText "Dockerfile" ''
    FROM lnl7/nix:${(builtins.parseDrvName nix.name).version}

    RUN nix-env -iA \
     nixpkgs.gnused \
     nixpkgs.openssh \
     && nix-store --optimize

    RUN mkdir -p /etc/ssh \
     && cp /root/.nix-profile/etc/ssh/sshd_config /etc/ssh \
     && sed -i '/^PermitRootLogin/d; /^UsePrivilegeSeparation/d' /etc/ssh/sshd_config \
     && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
     && echo "UsePrivilegeSeparation no" >> /etc/ssh/sshd_config \
     && ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N "" -t rsa \
     && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N "" -t dsa \
     && echo "export SSL_CERT_FILE=$SSL_CERT_FILE" >> /etc/bashrc \
     && echo "export PATH=$PATH" >> /etc/bashrc \
     && echo "export NIX_PATH=$NIX_PATH" >> /etc/bashrc \
     && echo "source /etc/bashrc" >> /etc/profile

    ADD insecure_rsa /root/.ssh/id_rsa
    ADD insecure_rsa.pub /root/.ssh/authorized_keys

    EXPOSE 22
    CMD ["${openssh}/bin/sshd", "-D"]
  '';

  env = native.stdenv.mkDerivation {
    name = "build-environment";
    shellHooks = ''
      mkdir -p pkgs latest ssh
      cp -f ${tarball}/tarball/nixos-system-*.tar.xz nixos-system.tar.xz
      cp -f ${group} group
      cp -f ${passwd} passwd
      cp -f ${baseDocker} Dockerfile
      cp -f ${pkgsDocker} pkgs/Dockerfile
      cp -f ${latestDocker} latest/Dockerfile
      cp -f ${sshDocker} ssh/Dockerfile
    '';
  };

in

{
  inherit baseDocker pkgsDocker latestDocker sshDocker;
  inherit env path profile tarball unstable;
}

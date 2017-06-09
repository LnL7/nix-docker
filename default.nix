{ src ? ./srcs/2017-06-09.nix, nixpkgs ? <nixpkgs>, system ? builtins.currentSystem }:

let
  inherit (pkgs) dockerTools stdenv buildEnv writeText;
  inherit (pkgs) bashInteractive coreutils cacert gnutar gzip less nix openssh;

  pkgs = import unstable { system = "x86_64-linux"; };

  native = import nixpkgs { inherit system; };
  unstable = native.callPackage src { stdenv = native.stdenvNoCC; };

  path = buildEnv {
    name = "system-path";
    paths = [ bashInteractive coreutils less nix ];
  };

  passwd = ''
    root:x:0:0::/root:/run/current-system/sw/bin/bash
    nixbld1:x:30001:30000::/var/empty:
    nixbld2:x:30002:30000::/var/empty:
    nixbld3:x:30003:30000::/var/empty:
    nixbld4:x:30004:30000::/var/empty:
  '';

  group = ''
    root:x:0:
    nixbld:x:30000:nixbld1,nixbld2,nixbld3,nixbld4
  '';

  nsswitch = ''
    hosts: files dns myhostname mymachines
  '';

  contents = stdenv.mkDerivation {
    name = "user-environment";
    phases = [ "installPhase" "fixupPhase" ];

    exportReferencesGraph =
      map (drv: [("closure-" + baseNameOf drv) drv]) [ path cacert unstable ];

    installPhase = ''
      mkdir -p $out/run/current-system $out/var
      ln -s /run $out/var/run
      ln -s ${path} $out/run/current-system/sw

      mkdir -p $out/bin $out/usr/bin $out/sbin
      ln -s ${stdenv.shell} $out/bin/sh
      ln -s ${pkgs.coreutils}/bin/env $out/usr/bin/env

      mkdir -p $out/etc
      echo '${passwd}' > $out/etc/passwd
      echo '${group}' > $out/etc/group
      echo '${nsswitch}' > $out/etc/nsswitch.conf

      printRegistration=1 ${pkgs.perl}/bin/perl ${pkgs.pathsFromGraph} closure-* > $out/.reginfo
    '';
  };

  image = dockerTools.buildImage rec {
    name = "nix-base";
    tag = "${unstable.version}";
    inherit contents;

    config.Cmd = [ "${pkgs.bashInteractive}/bin/bash" ];
    config.Env =
      [ "PATH=/root/.nix-profile/bin:/run/current-system/sw/bin"
        "MANPATH=/root/.nix-profile/share/man:/run/current-system/sw/share/man"
        "NIX_PATH=nixpkgs=${unstable}"
        "GIT_SSL_CAINFO=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      ];
  };

  baseDocker = writeText "Dockerfile" ''
    FROM nix-base:${unstable.version}
    RUN nix-store --init && nix-store --load-db < .reginfo

    RUN mkdir -m 0777 -p /tmp \
     && mkdir -p /nix/var/nix/profiles/per-user/root /root/.nix-defexpr \
     && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
     && ln -s ${unstable} /root/.nix-defexpr/nixos \
     && ln -s ${unstable} /root/.nix-defexpr/nixpkgs
  '';

  latestDocker = writeText "Dockerfile" ''
    FROM lnl7/nix:${unstable.version}

    RUN nix-env -f '<nixpkgs>' -iA \
        curl \
        findutils \
        git \
        glibc \
        gnugrep \
        gnused \
        gnutar \
        jq \
        nix \
        nix-repl \
        procps \
        silver-searcher \
        vim \
        which \
     && nix-store --gc
  '';

  sshDocker = writeText "Dockerfile" ''
    FROM lnl7/nix:${unstable.version}

    RUN nix-env -f '<nixpkgs>' -iA \
        gnused \
        openssh \
     && nix-store --gc

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

  run = native.writeScriptBin "run-docker-build" ''
    #! ${native.stdenv.shell}
    set -e

    echo "building root image..." >&2
    imageOut=$(nix-build -A image --no-out-link)
    echo "importing root image..." >&2
    docker load < $imageOut
    echo "building ${unstable.version}..." >&2
    cp -f ${baseDocker} Dockerfile
    docker build -t lnl7/nix:${unstable.version} .
    docker rmi nix-base:${unstable.version}
  '';

  env = native.stdenv.mkDerivation {
    name = "build-environment";
    shellHooks = ''
      nix-build -A run

      cp -f ${baseDocker} Dockerfile
      cp -f ${latestDocker} latest/Dockerfile
      cp -f ${sshDocker} ssh/Dockerfile
    '';
  };

in

{
  inherit baseDocker latestDocker sshDocker;
  inherit env run image contents path unstable;
}

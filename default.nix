{ src ? ./srcs/2020-01-02.nix, nixpkgs ? <nixpkgs>, system ? builtins.currentSystem }:

let
  inherit (pkgs) dockerTools stdenv buildEnv writeTextDir;
  inherit (pkgs) bashInteractive coreutils cacert nix openssh shadow;

  inherit (native.lib) concatStringsSep genList;

  pkgs =
    import unstable { system = "x86_64-linux"; };

  native =
    import nixpkgs { inherit system; };

  unstable =
    native.callPackage src { stdenv = native.stdenvNoCC; };

  path =
    buildEnv {
      name = "system-path";
      paths = [ bashInteractive coreutils nix shadow ];
    };

  nixconf =
    ''
      build-users-group = nixbld
      sandbox = false
    '';

  passwd =
    ''
      root:x:0:0::/root:/run/current-system/sw/bin/bash
      user:x:1000:1000::/home/user:/run/current-system/sw/bin/bash
      ${concatStringsSep "\n" (genList (i: "nixbld${toString (i+1)}:x:${toString (i+30001)}:30000::/var/empty:/run/current-system/sw/bin/nologin") 32)}
    '';

  group =
    ''
      root:x:0:
      user:x:1000:user
      nogroup:x:65534:
      nixbld:x:30000:${concatStringsSep "," (genList (i: "nixbld${toString (i+1)}") 32)}
    '';

  nsswitch =
    ''
      hosts: files dns myhostname mymachines
    '';

  contents =
    stdenv.mkDerivation {
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
        ln -s ${coreutils}/bin/env $out/usr/bin/env

        mkdir -p $out/etc/ssl
        ln -s ${cacert}/etc/ssl/certs $out/etc/ssl/certs

        mkdir -p $out/etc/nix
        echo '${nixconf}' > $out/etc/nix/nix.conf
        echo '${passwd}' > $out/etc/passwd
        echo '${group}' > $out/etc/group
        echo '${nsswitch}' > $out/etc/nsswitch.conf

        printRegistration=1 ${pkgs.perl}/bin/perl ${pkgs.pathsFromGraph} closure-* > $out/.reginfo
      '';
    };

  baseImage =
    dockerTools.buildImage rec {
      name = "nix-base";
      tag = "${unstable.version}";
      inherit contents;

      config.Cmd = [ "${bashInteractive}/bin/bash" ];
      config.Env =
        [
          "PATH=/root/.nix-profile/bin:/run/current-system/sw/bin"
          "MANPATH=/root/.nix-profile/share/man:/run/current-system/sw/share/man"
          "NIX_PAGER=cat"
          "NIX_PATH=nixpkgs=${unstable}"
          "NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt"
        ];
      config.WorkingDir = "/root";
    };

  baseDocker =
    writeTextDir "Dockerfile"
      ''
        FROM nix-base:${unstable.version}
        RUN nix-store --init && nix-store --load-db < /.reginfo

        RUN mkdir -m 1777 -p /tmp \
          && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
          && ln -s ${path} /nix/var/nix/gcroots/booted-system \
          && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
          && ln -s ${unstable} /root/.nix-defexpr/nixos \
          && ln -s ${unstable} /root/.nix-defexpr/nixpkgs \
          && nix-store --optimize \
          && nix-store --verify --check-contents
      '';

  latestDocker =
    writeTextDir "Dockerfile"
      ''
        FROM monacoremo/nix:${unstable.version}

        RUN nix-env -f '<nixpkgs>' -iA \
            curl \
            findutils \
            git \
            glibc \
            gnugrep \
            gnused \
            gnutar \
            gzip \
            jq \
            procps \
            vim \
            which \
            xz \
         && nix-store --gc
      '';

  circleciDocker =
    writeTextDir "Dockerfile"
      ''
        FROM monacoremo/nix:${unstable.version}

        RUN nix-env -f '<nixpkgs>' -iA \
            gnutar \
            gzip \
            git \
            openssh \
            su-exec \
         && nix-store --gc
      '';

  buildDockerImages =
    native.writeShellScriptBin "nix-docker-build"
      ''
        set -e

        trap "docker rmi nix-base:${unstable.version}" exit

        echo "importing root image..." >&2
        docker load < ${baseImage}
        echo "building ${unstable.version} images..." >&2

        docker build -t monacoremo/nix:${unstable.version} ${baseDocker}
        docker build -t monacoremo/nix:latest-${unstable.version} ${latestDocker}
        docker build -t monacoremo/nix:circleci-${unstable.version} ${circleciDocker}
      '';

  pushDockerImages =
    native.writeShellScriptBin "nix-docker-push"
      ''
        docker push monacoremo/nix:${unstable.version}
        docker push monacoremo/nix:latest-${unstable.version}
        docker push monacoremo/nix:circleci-${unstable.version}
      '';

  cleanDockerImages =
    native.writeShellScriptBin "nix-docker-clean"
      ''
        docker rmi monacoremo/nix:${unstable.version}
        docker rmi monacoremo/nix:latest-${unstable.version}
        docker rmi monacoremo/nix:circleci-${unstable.version}
      '';

  dockerImages =
    native.writeShellScriptBin "nix-docker"
      ''
        ${buildDockerImages}/bin/nix-docker-build
        ${pushDockerImages}/bin/nix-docker-push
        ${cleanDockerImages}/bin/nix-docker-clean
      '';
in
native.stdenv.mkDerivation {
  name = "nix-docker";

  buildInputs = [
    buildDockerImages
    pushDockerImages
    cleanDockerImages
    dockerImages
  ];
}

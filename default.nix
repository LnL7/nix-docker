{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux" }:

let
  inherit (import <nixpkgs> {}) stdenv;

  pkgs = import nixpkgs { inherit system; };
  inherit (pkgs) buildEnv writeText;
  inherit (pkgs) bashInteractive coreutils cacert gnutar gzip less nix;

  sw = buildEnv {
    name = "system-path";
    paths = [ bashInteractive coreutils cacert gnutar gzip less nix ];
  };

  profile = buildEnv {
    name = "user-environment";
    paths = [ ];
  };

  tarball = pkgs.callPackage <nixpkgs/nixos/lib/make-system-tarball.nix> {
    contents = [];
    storeContents = map (x: { object = x; symlink = "none"; }) [ sw profile ];
    extraArgs = "--owner=0";
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

  docker = writeText "dockerfile" ''
    FROM scratch
    ADD ${tarball}/tarball/nixos-system-${system}.tar.xz /

    RUN ["${sw}/bin/mkdir", "-p", "/bin", "/usr/bin", "/etc", "/var", "/tmp", "/root/.nix-defexpr", "/run/current-system", "/nix/var/nix/profiles/per-user/root"]
    RUN ["${sw}/bin/ln", "-s", "${sw}", "/run/current-system/sw"]
    RUN ["${sw}/bin/ln", "-s", "/run/current-system/sw/bin/sh", "/bin/sh"]
    RUN ["${sw}/bin/ln", "-s", "/run/current-system/sw/bin/env", "/usr/bin/env"]
    RUN ["${sw}/bin/ln", "-s", "${profile}", "/nix/var/nix/profiles/per-user/root/profile-1-link"]
    RUN ["${sw}/bin/ln", "-s", "/nix/var/nix/profiles/per-user/root/profile-1-link", "/nix/var/nix/profiles/per-user/root/profile"]
    RUN ["${sw}/bin/ln", "-s", "/nix/var/nix/profiles/per-user/root/profile", "/root/.nix-profile"]

    ADD group /etc
    ADD passwd /etc

    ENV SSL_CERT_FILE /run/current-system/sw/etc/ssl/certs/ca-bundle.crt
    ENV PATH /root/.nix-profile/bin:/root/.nix-profile/sbin:/run/current-system/sw/bin:/run/current-system/sw/sbin
    ENV MANPATH /root/.nix-profile/share/man:/run/current-system/sw/share/man
    ENV NIX_PATH /root/.nix-defexpr/nixpkgs:nixpkgs=/root/.nix-defexpr/nixpkgs

    RUN nix-store --init && nix-store --load-db < nix-path-registration \
     && rm env-vars pathlist nix-path-registration closure-*

    CMD ["bash"]
  '';

  env = stdenv.mkDerivation {
    name = "build-environment";
    shellHooks = ''
      cp -f ${tarball}/tarball/nixos-system-${system}.tar.xz nixos-system.tar.xz
      cp -f ${group} group
      cp -f ${passwd} passwd
      cp -f ${docker} Dockerfile
    '';
  };

in {
  inherit sw profile tarball docker env;
}

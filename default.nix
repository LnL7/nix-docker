{ pkgs ? import <nixpkgs> {}
, linuxpkgs ? import <nixpkgs> { system = "x86_64-linux"; }
}:

pkgs.dockerTools.buildImage {
  name = "lnl7/nix";
  tag = "base";

  contents = pkgs.buildEnv {
    name = "user-environment";
    paths = (with linuxpkgs; [ bashInteractive.out coreutils.out gnutar.out bzip2.bin curl.bin ]);
  };
  config = {
    Cmd = [ "/bin/sh" ];
  };
}

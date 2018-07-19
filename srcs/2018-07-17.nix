{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-${version}";
  version = "2018-07-17";

  src = fetchurl {
    url = https://github.com/NixOS/nixpkgs/archive/d7d31fea7e7eef8ff4495e75be5dcbb37fb215d0.tar.gz;
    sha256 = "013na1m4g8c3rcfw0dwmv2zmia6byg5c2xdx3z5dk90i27s449kx";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

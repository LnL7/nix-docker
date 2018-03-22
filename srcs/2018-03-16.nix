{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-${version}";
  version = "2018-03-16";

  src = fetchurl {
    url = https://github.com/NixOS/nixpkgs/archive/13e74a838db27825c88be99b1a21fbee33aa6803.tar.gz;
    sha256 = "07zva9flryqkbrq5abzb96fl6pz8g0yb3jm483hbisgra3kx8cpz";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

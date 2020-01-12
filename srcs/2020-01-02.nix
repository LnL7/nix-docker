
{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-2020-01-02";
  version = "2020-01-02";

  src = builtins.fetchTarball {
    inherit name;
    url = "https://github.com/nixos/nixpkgs/archive/7e8454fb856573967a70f61116e15f879f2e3f6a.tar.gz";
    sha256 = "0lnbjjvj0ivpi9pxar0fyk8ggybxv70c5s0hpsqf5d71lzdpxpj8";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

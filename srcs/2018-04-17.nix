{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-${version}";
  version = "2018-04-17";

  src = fetchurl {
    url = https://github.com/NixOS/nixpkgs/archive/d91caac6c3e58b8a5f4721c0a6cc8f0dc3b93fd3.tar.gz;
    sha256 = "1i684pkn3bgf734p53yxvllv0gl092z757qlh6hfw4zajawyh6ns";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

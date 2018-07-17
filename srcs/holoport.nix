{ stdenv, fetchgitlocal }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-${version}";
  version = "2018-04-17";

  src = fetchgitlocal {
    src = ~/repos/nixpkgs;
    sha256 = "1i684pkn3bgf734p53yxvllv0gl092z757qlh6hfw4zajawyh6ns";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

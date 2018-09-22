{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-${version}";
  version = "2018-09-21";

  src = fetchurl {
    url = https://github.com/NixOS/nixpkgs/archive/7df10f388dabe9af3320fe91dd715fc84f4c7e8a.tar.gz;
    sha256 = "0qycshcvfhrkv4yals02q3i1s4c0mvwl59bxmqblys0lrndpprxs";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

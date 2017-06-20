{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-${version}";
  version = "2017-06-20";

  src = fetchurl {
    url = https://github.com/NixOS/nixpkgs/archive/03d1e8a14ec29388f6a50c2900c7d4f48c491214.tar.gz;
    sha256 = "1xiybn07xi6shb3am9scasll106l3z3p83vy6rk3yq5vniblxjgg";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

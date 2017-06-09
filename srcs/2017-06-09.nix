{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-${version}";
  version = "2017-06-09";

  src = fetchurl {
    url = https://github.com/NixOS/nixpkgs/archive/57091a19e2aa1a0e11fd91d95cefa7d42fbf95e0.tar.gz;
    sha256 = "0ir9fvmjbvjr9gnyn6j7kbsp88icwnpfri8zxvjlcgaj9y4vddqj";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

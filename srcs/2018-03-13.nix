{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-${version}";
  version = "2018-03-13";

  src = fetchurl {
    url = https://github.com/NixOS/nixpkgs/archive/a682ba23d49cd13c92922af3d5dc44efd60ae9e7.tar.gz;
    sha256 = "010a165ni23g09xwdm003qv7nn2lmnhg2d4avhwjh1b3lrn0wxl0";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-${version}";
  version = "2017-01-21";

  src = fetchurl {
    url = https://github.com/NixOS/nixpkgs/archive/dc6413399c0f18d5ae6cfa514ea2582f4d9388de.tar.gz;
    sha256 = "0wll89yaq2w25d0pmillyx48z573qr4d0izx5ik4gam2rbbm5671";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

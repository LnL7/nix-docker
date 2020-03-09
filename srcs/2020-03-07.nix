{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-20.09pre216190.6b6f9d769a5";
  version = "2020-03-07";

  src = fetchurl {
    url = "https://releases.nixos.org/nixpkgs/${name}/nixexprs.tar.xz";
    sha256 = "06gcnkww9g8b63r1jmzyziw7axbl3lqnrl3ddfbl3bz7sfq9r4s4";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

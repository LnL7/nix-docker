{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-19.09pre178484.8bc70c937b3";
  version = "2019-05-04";

  src = fetchurl {
    url = "https://releases.nixos.org/nixpkgs/${name}/nixexprs.tar.xz";
    sha256 = "0r0v329x13rc996ysjq9xg5qb17vn301vpv8ikmhgcf9471i30lq";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

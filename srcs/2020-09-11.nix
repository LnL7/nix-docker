{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-21.03pre243353.6d4b93323e7";
  version = "2020-09-11";

  src = fetchurl {
    url = "https://releases.nixos.org/nixpkgs/${name}/nixexprs.tar.xz";
    sha256 = "1ri1mqvihviz80765p3p59i2irhnbn7vbvah0aacpkks60m9m0id";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

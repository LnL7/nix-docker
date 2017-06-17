{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-${version}";
  version = "2017-06-17";

  src = fetchurl {
    url = https://github.com/NixOS/nixpkgs/archive/fd92d817a33c24041feba3df3c11dbc987b4f331.tar.gz;
    sha256 = "04gb7lzcjjznd4rsgwwmldlll7b0k98jjzgcz6g7hrhrha6ycbh8";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

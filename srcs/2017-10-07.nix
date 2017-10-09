{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-${version}";
  version = "2017-10-07";

  src = fetchurl {
    url = https://github.com/NixOS/nixpkgs/archive/66f8512e4f280108222d9a0bf64951a392fd16bd.tar.gz;
    sha256 = "0c4rsg1w99riqxlm14qlqf91wq7dr7rxg3vndjdbfazb9hn9ssx6";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

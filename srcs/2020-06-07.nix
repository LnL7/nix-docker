{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-20.09pre228453.dcb64ea42e6";
  version = "2020-06-07";

  src = fetchurl {
    url = "https://releases.nixos.org/nixpkgs/${name}/nixexprs.tar.xz";
    sha256 = "0ily7j9cb24fa6m779vwdn1l5w0v2fy031dhmjg0hh494y4y8zl5";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

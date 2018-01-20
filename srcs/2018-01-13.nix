{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-${version}";
  version = "2018-01-13";

  src = fetchurl {
    url = https://github.com/NixOS/nixpkgs/archive/9420e076f4184fe08fafcc716db26f1d51ac73db.tar.gz;
    sha256 = "0vlq242jmjwvcz94dky5lyjg8yzj6fs8bdr955qk1kw3ghrg24jj";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

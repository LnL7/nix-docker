{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-unstable-${version}";
  version = "2019-03-01";

  src = fetchurl {
    url = https://releases.nixos.org/nixpkgs/nixpkgs-19.09pre170896.6e5caa3f8ac/nixexprs.tar.xz;
    sha256 = "10lqmzry265cvmvy330f2k41gk1k88yfmvm3ljknwkd4p8hn2ggi";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}

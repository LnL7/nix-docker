FROM lnl7/nix:1.11.2

RUN nix-env -iA \
 nixpkgs.curl \
 nixpkgs.findutils \
 nixpkgs.git \
 nixpkgs.glibc \
 nixpkgs.gnugrep \
 nixpkgs.gnused \
 nixpkgs.gnutar \
 nixpkgs.jq \
 nixpkgs.netcat \
 nixpkgs.nix \
 nixpkgs.nix-prefetch-scripts \
 nixpkgs.nix-repl \
 nixpkgs.silver-searcher \
 nixpkgs.vim \
 nixpkgs.which \
 && nix-store --optimize

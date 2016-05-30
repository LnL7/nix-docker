FROM lnl7/nix:1.11.2

RUN nix-channel --update && nix-env -iA \
 nixpkgs.bashInteractive \
 nixpkgs.cacert \
 nixpkgs.curl \
 nixpkgs.git \
 nixpkgs.jq \
 nixpkgs.less \
 nixpkgs.netcat \
 nixpkgs.nix \
 nixpkgs.nix-repl \
 nixpkgs.silver-searcher \
 nixpkgs.vim

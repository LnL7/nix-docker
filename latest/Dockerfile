FROM lnl7/nix:1.11.6

RUN nix-env -f '<nixpkgs>' -iA \
    curl \
    findutils \
    git \
    glibc \
    gnugrep \
    gnused \
    gnutar \
    jq \
    netcat \
    nix \
    nix-prefetch-scripts \
    nix-repl \
    psproc \
    silver-searcher \
    vim \
    which \
 && nix-store --optimize

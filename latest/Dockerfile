FROM lnl7/nix:2018-01-13

RUN nix-env -f '<nixpkgs>' -iA \
    curl \
    findutils \
    git \
    glibc \
    gnugrep \
    gnused \
    gnutar \
    jq \
    nix \
    nix-repl \
    procps \
    silver-searcher \
    vim \
    which \
 && nix-store --gc

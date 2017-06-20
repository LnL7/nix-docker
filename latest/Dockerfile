FROM lnl7/nix:2017-06-20

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

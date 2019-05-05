FROM lnl7/nix:2019-05-04

RUN nix-env -f '<nixpkgs>' -iA \
    curl \
    findutils \
    git \
    glibc \
    gnugrep \
    gnused \
    gnutar \
    gzip \
    jq \
    procps \
    vim \
    which \
    xz \
 && nix-store --gc

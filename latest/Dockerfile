FROM lnl7/nix:2018-03-13

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
 && nix-store --gc

FROM monacoremo/nix:2020-01-02

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

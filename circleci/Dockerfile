FROM monacoremo/nix:2020-01-02

RUN nix-env -f '<nixpkgs>' -iA \
    git \
    openssh \
 && nix-store --gc

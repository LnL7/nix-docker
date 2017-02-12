FROM nix-base:2017-01-21
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 0777 -p /tmp \
 && mkdir -p /nix/var/nix/profiles/per-user/root /root/.nix-defexpr \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/5l32y4720dfz49wflj3js5cc730rwmf0-nixpkgs-unstable-2017-01-21 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/5l32y4720dfz49wflj3js5cc730rwmf0-nixpkgs-unstable-2017-01-21 /root/.nix-defexpr/nixpkgs

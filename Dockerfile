FROM nix-base:2020-01-02
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/1p8mn3npkfhqy5b47kx94wfp91i6nysk-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/pvjp7mv7i8lny6k9h2pq71zhw8249cr5-nixpkgs-unstable-2020-01-02 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/pvjp7mv7i8lny6k9h2pq71zhw8249cr5-nixpkgs-unstable-2020-01-02 /root/.nix-defexpr/nixpkgs

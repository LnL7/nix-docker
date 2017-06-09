FROM nix-base:2017-06-09
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 0777 -p /tmp \
 && mkdir -p /nix/var/nix/profiles/per-user/root /root/.nix-defexpr \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/fmnqvj4nyjv7253v5zddn615zw2adnyc-nixpkgs-unstable-2017-06-09 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/fmnqvj4nyjv7253v5zddn615zw2adnyc-nixpkgs-unstable-2017-06-09 /root/.nix-defexpr/nixpkgs

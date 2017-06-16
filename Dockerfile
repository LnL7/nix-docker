FROM nix-base:2017-06-09
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/kr6272h4r4yy4jfk3aafz726r67dcjwz-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/fmnqvj4nyjv7253v5zddn615zw2adnyc-nixpkgs-unstable-2017-06-09 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/fmnqvj4nyjv7253v5zddn615zw2adnyc-nixpkgs-unstable-2017-06-09 /root/.nix-defexpr/nixpkgs

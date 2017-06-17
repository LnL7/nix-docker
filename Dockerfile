FROM nix-base:2017-06-17
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/vdy2c7kahbs4i4vwnxy7qmy6a8y5gf9i-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/r2x7gamy1wmcy6mb7vnyllgzsj5xvg6n-nixpkgs-unstable-2017-06-17 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/r2x7gamy1wmcy6mb7vnyllgzsj5xvg6n-nixpkgs-unstable-2017-06-17 /root/.nix-defexpr/nixpkgs

FROM nix-base:2018-07-17
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/v2nl63nrx6jv58qk5q8dc93dl1rj5bgc-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/1a7blwzdwsafkw1x5fql61ddbv1v3r25-nixpkgs-unstable-2018-07-17 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/1a7blwzdwsafkw1x5fql61ddbv1v3r25-nixpkgs-unstable-2018-07-17 /root/.nix-defexpr/nixpkgs

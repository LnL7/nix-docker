FROM nix-base:2017-10-07
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/79gx1ak76shigh1g3a2fivcifh2p4bq6-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/ah82llnxfsx6v99l8yalj90ikp5zac04-nixpkgs-unstable-2017-10-07 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/ah82llnxfsx6v99l8yalj90ikp5zac04-nixpkgs-unstable-2017-10-07 /root/.nix-defexpr/nixpkgs

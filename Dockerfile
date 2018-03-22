FROM nix-base:2018-03-16
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/paz37n5zya7p8way7s6mjq1h5qbhpfrn-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/cqjnsfbv1sk1vv24yargb13hw8sf7pzr-nixpkgs-unstable-2018-03-16 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/cqjnsfbv1sk1vv24yargb13hw8sf7pzr-nixpkgs-unstable-2018-03-16 /root/.nix-defexpr/nixpkgs

FROM nix-base:2018-03-13
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/nwrrwgl4jfd6mn55ah933ipi474wcfx1-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/nlzzf8w19w8d7d9yv3d4gn5fa7r9mxy7-nixpkgs-unstable-2018-03-13 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/nlzzf8w19w8d7d9yv3d4gn5fa7r9mxy7-nixpkgs-unstable-2018-03-13 /root/.nix-defexpr/nixpkgs

FROM nix-base:2018-04-17
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/xhcml8hf4016l6rc7sbihdxdckwxx4m0-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/yb3hz7czbx1hw96103d6jc0jsysrn5p8-nixpkgs-unstable-2018-04-17 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/yb3hz7czbx1hw96103d6jc0jsysrn5p8-nixpkgs-unstable-2018-04-17 /root/.nix-defexpr/nixpkgs

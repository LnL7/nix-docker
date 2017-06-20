FROM nix-base:2017-06-20
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/xswki9jaj9wmjjyy7fxsyaj95yswk2j1-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/lv6p5ybdyjky4jr532rywwdw5my3x6n2-nixpkgs-unstable-2017-06-20 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/lv6p5ybdyjky4jr532rywwdw5my3x6n2-nixpkgs-unstable-2017-06-20 /root/.nix-defexpr/nixpkgs

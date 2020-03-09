FROM nix-base:2020-03-07
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/4l52g2px6z6sj1gh0xnip6hivi7pxkrc-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/p2d6ih9sz4whijgf9i5jvy4g9hycfb02-nixpkgs-20.09pre216190.6b6f9d769a5 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/p2d6ih9sz4whijgf9i5jvy4g9hycfb02-nixpkgs-20.09pre216190.6b6f9d769a5 /root/.nix-defexpr/nixpkgs

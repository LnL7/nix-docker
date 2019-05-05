FROM nix-base:2019-05-04
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/v1lf771njhlp7j9fyd9fljx1fvv37g42-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/90y1kisxz9j16lbx8fqb1pinng9sxhkc-nixpkgs-19.09pre178484.8bc70c937b3 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/90y1kisxz9j16lbx8fqb1pinng9sxhkc-nixpkgs-19.09pre178484.8bc70c937b3 /root/.nix-defexpr/nixpkgs

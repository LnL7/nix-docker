FROM nix-base:2020-06-07
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/flb08j4x46i6zg3ldp3vvf7lkzz0q2sw-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/z124xpfhlsshxs775jrc8nd83chqkbzy-nixpkgs-20.09pre228453.dcb64ea42e6 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/z124xpfhlsshxs775jrc8nd83chqkbzy-nixpkgs-20.09pre228453.dcb64ea42e6 /root/.nix-defexpr/nixpkgs

FROM nix-base:2019-03-01
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/frdv5rh0v6zsgkj8hpwcs5lm7zw019qq-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/3bi2hg5m1b94v6iwkdd8w3xp09489dbs-nixpkgs-unstable-2019-03-01 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/3bi2hg5m1b94v6iwkdd8w3xp09489dbs-nixpkgs-unstable-2019-03-01 /root/.nix-defexpr/nixpkgs

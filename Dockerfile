FROM nix-base:2018-01-13
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/l3hciq0a9s4nzb006mx3j7dyiq7p9mif-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/d7r0qlms9w7k0m5kmvinp52abxbncafv-nixpkgs-unstable-2018-01-13 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/d7r0qlms9w7k0m5kmvinp52abxbncafv-nixpkgs-unstable-2018-01-13 /root/.nix-defexpr/nixpkgs

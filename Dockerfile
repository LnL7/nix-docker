FROM nix-base:2018-09-21
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/bfacyfvbndlh3gd4ln5qnwz6b4pjyddb-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/ml2yq4cj4n234bp7srawm674b93sak4i-nixpkgs-unstable-2018-09-21 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/ml2yq4cj4n234bp7srawm674b93sak4i-nixpkgs-unstable-2018-09-21 /root/.nix-defexpr/nixpkgs

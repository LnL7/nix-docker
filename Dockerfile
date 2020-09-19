FROM nix-base:2020-09-11
RUN nix-store --init && nix-store --load-db < .reginfo

RUN mkdir -m 1777 -p /tmp \
 && mkdir -p /nix/var/nix/gcroots /nix/var/nix/profiles/per-user/root /root/.nix-defexpr /var/empty \
 && ln -s /nix/store/7w80v91gd7lv23diick7waws1n3szgr3-system-path /nix/var/nix/gcroots/booted-system \
 && ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile \
 && ln -s /nix/store/id92xjzzpkv5flzm4451ll6c1iwa87cm-nixpkgs-21.03pre243353.6d4b93323e7 /root/.nix-defexpr/nixos \
 && ln -s /nix/store/id92xjzzpkv5flzm4451ll6c1iwa87cm-nixpkgs-21.03pre243353.6d4b93323e7 /root/.nix-defexpr/nixpkgs

FROM lnl7/nix:272cf5c

RUN nix-instantiate --eval -E 'fetchTarball https://github.com/NixOS/nixpkgs/archive/272cf5c.tar.gz' \
 && ln -s /nix/store/njm056f3qn77cgcnm5z1bh9amvgcvc23-272cf5c.tar.gz /root/.nix-defexpr/nixpkgs

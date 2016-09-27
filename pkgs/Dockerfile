FROM lnl7/nix:124f25b

RUN nix-instantiate --eval -E 'fetchTarball https://github.com/NixOS/nixpkgs/archive/124f25b.tar.gz' \
 && ln -s /nix/store/75wzbj70n7n9pmgwg1iynr1p7983xf7d-124f25b.tar.gz /root/.nix-defexpr/nixpkgs

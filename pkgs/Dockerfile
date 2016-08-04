FROM lnl7/nix:ea9d390

RUN nix-instantiate --eval -E 'fetchTarball https://github.com/NixOS/nixpkgs/archive/ea9d390.tar.gz' \
 && ln -s /nix/store/1nm43jpw220czwmm4l5lxb30xa2s30y1-ea9d390.tar.gz /root/.nix-defexpr/nixpkgs

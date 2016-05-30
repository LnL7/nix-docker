FROM lnl7/nix:base

ENV NIX_VERSION 1.11.2
ENV NIX_INSTALL_URL http://nixos.org/releases/nix/nix-$NIX_VERSION/nix-$NIX_VERSION-x86_64-linux.tar.bz2
ENV NIX_INSTALL_SHA256 8b208cfcd396da2bd2192fee485077618920b98fe9858105b3a7836562417d49

RUN mkdir /tmp /root

COPY passwd /etc
COPY group /etc

ENV USER root

RUN curl -fsSL $NIX_INSTALL_URL -o nix.tar.bz2 \
 && ( set -o pipefail; echo "$NIX_INSTALL_SHA256  nix.tar.bz2" | sha256sum -c - ) \
 && tar -C / -xjf nix.tar.bz2 \
 && cp -Rp nix-$NIX_VERSION-x86_64-linux/store/* /nix/store \
 && ( \
 nix="/nix/store/4z8srway6dl128dxzn5r0wwdvglz3m61-nix-1.11.2" ;\
 cacert="/nix/store/4fh4nwd11frn1a3rifrdv6kdifrxrfwn-nss-cacert-3.21" ;\
 $nix/bin/nix-store --init && \
 $nix/bin/nix-store --load-db < nix-$NIX_VERSION-x86_64-linux/.reginfo && \
 . $nix/etc/profile.d/nix.sh && \
 $nix/bin/nix-env -i "$nix" && \
 $nix/bin/nix-env -i "$cacert" && \
 $nix/bin/nix-channel --add https://nixos.org/channels/nixpkgs-unstable ) \
 && rm -r nix-$NIX_VERSION-x86_64-linux nix.tar.bz2

ENV PATH /root/.nix-profile/bin:$PATH
ENV GIT_SSL_CAINFO /root/.nix-profile/etc/ssl/certs/ca-bundle.crt
ENV SSL_CERT_FILE /root/.nix-profile/etc/ssl/certs/ca-bundle.crt

COPY docker-entrypoint.sh /
COPY vimrc /root/.vimrc

ENTRYPOINT ["/docker-entrypoint.sh"]

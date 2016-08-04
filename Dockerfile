FROM scratch
ADD nixos-system.tar.xz /

RUN ["/nix/store/hj2xmdwmhva8c4gqz4d4ql6xbx8bmhyi-system-path/bin/mkdir", "-p", "/bin", "/usr/bin", "/etc", "/var", "/tmp", "/root/.nix-defexpr", "/run/current-system", "/nix/var/nix/profiles/per-user/root"]
RUN ["/nix/store/hj2xmdwmhva8c4gqz4d4ql6xbx8bmhyi-system-path/bin/ln", "-s", "/nix/store/hj2xmdwmhva8c4gqz4d4ql6xbx8bmhyi-system-path", "/run/current-system/sw"]
RUN ["/nix/store/hj2xmdwmhva8c4gqz4d4ql6xbx8bmhyi-system-path/bin/ln", "-s", "/run/current-system/sw/bin/sh", "/bin/sh"]
RUN ["/nix/store/hj2xmdwmhva8c4gqz4d4ql6xbx8bmhyi-system-path/bin/ln", "-s", "/run/current-system/sw/bin/env", "/usr/bin/env"]
RUN ["/nix/store/hj2xmdwmhva8c4gqz4d4ql6xbx8bmhyi-system-path/bin/ln", "-s", "/nix/store/0j128g4jmav03ybzm2r1kkgfygnfhs0n-user-environment", "/nix/var/nix/profiles/per-user/root/profile-1-link"]
RUN ["/nix/store/hj2xmdwmhva8c4gqz4d4ql6xbx8bmhyi-system-path/bin/ln", "-s", "/nix/var/nix/profiles/per-user/root/profile-1-link", "/nix/var/nix/profiles/per-user/root/profile"]
RUN ["/nix/store/hj2xmdwmhva8c4gqz4d4ql6xbx8bmhyi-system-path/bin/ln", "-s", "/nix/var/nix/profiles/per-user/root/profile", "/root/.nix-profile"]

ADD group /etc
ADD passwd /etc

ENV GIT_SSL_CAINFO /run/current-system/sw/etc/ssl/certs/ca-bundle.crt
ENV SSL_CERT_FILE /run/current-system/sw/etc/ssl/certs/ca-bundle.crt
ENV PATH /root/.nix-profile/bin:/root/.nix-profile/sbin:/run/current-system/sw/bin:/run/current-system/sw/sbin
ENV MANPATH /root/.nix-profile/share/man:/run/current-system/sw/share/man
ENV NIX_PATH /root/.nix-defexpr/nixpkgs:nixpkgs=/root/.nix-defexpr/nixpkgs

RUN nix-store --init && nix-store --load-db < nix-path-registration \
 && rm env-vars pathlist nix-path-registration closure-*

CMD ["bash"]

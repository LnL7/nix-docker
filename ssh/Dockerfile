FROM lnl7/nix:2020-09-11

RUN nix-env -f '<nixpkgs>' -iA \
    gnused \
    openssh \
 && nix-store --gc

RUN mkdir -p /etc/ssh \
 && echo "sshd:x:498:65534::/var/empty:/run/current-system/sw/bin/nologin" >> /etc/passwd \
 && cp /root/.nix-profile/etc/ssh/sshd_config /etc/ssh \
 && sed -i '/^PermitRootLogin/d' /etc/ssh/sshd_config \
 && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
 && ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N "" -t rsa \
 && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N "" -t dsa \
 && echo "export NIX_PATH=$NIX_PATH" >> /etc/bashrc \
 && echo "export NIX_SSL_CERT_FILE=$NIX_SSL_CERT_FILE" >> /etc/bashrc \
 && echo "export PATH=$PATH" >> /etc/bashrc \
 && echo "source /etc/bashrc" >> /etc/profile

ADD insecure_rsa /root/.ssh/id_rsa
ADD insecure_rsa.pub /root/.ssh/authorized_keys

EXPOSE 22
CMD ["/nix/store/f772niv2vajba3fr7xhh3infynyxr7c7-openssh-8.3p1/bin/sshd", "-D", "-e"]

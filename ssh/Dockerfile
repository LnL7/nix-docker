FROM lnl7/nix:2019-05-04

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
 && echo "export SSL_CERT_FILE=$SSL_CERT_FILE" >> /etc/bashrc \
 && echo "export PATH=$PATH" >> /etc/bashrc \
 && echo "export NIX_PATH=$NIX_PATH" >> /etc/bashrc \
 && echo "source /etc/bashrc" >> /etc/profile

ADD insecure_rsa /root/.ssh/id_rsa
ADD insecure_rsa.pub /root/.ssh/authorized_keys

EXPOSE 22
CMD ["/nix/store/hfv00423097b66cw0xb2qpdq43clpgd3-openssh-7.9p1/bin/sshd", "-D", "-e"]

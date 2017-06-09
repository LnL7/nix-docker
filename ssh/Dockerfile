FROM lnl7/nix:2017-06-09

RUN nix-env -f '<nixpkgs>' -iA \
    gnused \
    openssh \
 && nix-store --gc

RUN mkdir -p /etc/ssh \
 && cp /root/.nix-profile/etc/ssh/sshd_config /etc/ssh \
 && sed -i '/^PermitRootLogin/d; /^UsePrivilegeSeparation/d' /etc/ssh/sshd_config \
 && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
 && echo "UsePrivilegeSeparation no" >> /etc/ssh/sshd_config \
 && ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N "" -t rsa \
 && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N "" -t dsa \
 && echo "export SSL_CERT_FILE=$SSL_CERT_FILE" >> /etc/bashrc \
 && echo "export PATH=$PATH" >> /etc/bashrc \
 && echo "export NIX_PATH=$NIX_PATH" >> /etc/bashrc \
 && echo "source /etc/bashrc" >> /etc/profile

ADD insecure_rsa /root/.ssh/id_rsa
ADD insecure_rsa.pub /root/.ssh/authorized_keys

EXPOSE 22
CMD ["/nix/store/qx1nldmmj47wvd4f3lji1qvza2cjkl1i-openssh-7.5p1/bin/sshd", "-D"]

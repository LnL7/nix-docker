FROM lnl7/nix:1.11.2

RUN nix-env -iA nixpkgs.openssh \
 && nix-store --optimize

RUN mkdir -p /etc/ssh \
 && cp /root/.nix-profile/etc/ssh/sshd_config /etc/ssh \
 && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
 && echo "UsePrivilegeSeparation no" >> /etc/ssh/sshd_config \
 && ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
 && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa \
 && echo "export SSL_CERT_FILE=$SSL_CERT_FILE" >> /etc/bashrc \
 && echo "export PATH=$PATH" >> /etc/bashrc \
 && echo "export NIX_PATH=$NIX_PATH" >> /etc/bashrc \
 && echo "source /etc/bashrc" >> /etc/profile

ADD insecure_rsa /root/.ssh/id_rsa
ADD insecure_rsa.pub /root/.ssh/authorized_keys

EXPOSE 22
CMD ["/nix/store/ysya5rga20dd70g9a8xxz2jngyncc8w0-openssh-7.1p2/bin/sshd", "-D"]

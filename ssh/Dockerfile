FROM nixos/nix:2.7.0

RUN echo "filter-syscalls = false" >> /etc/nix/nix.conf
RUN nix-env -f '<nixpkgs>' -iA \
    gnused \
    bash \
    openssh \
    shadow \
  && nix-store --gc

RUN mkdir -p /etc/ssh \
  && echo "sshd:x:498:65534::/var/empty:/root/.nix-profile/bin/nologin" >> /etc/passwd \
  && echo "nogroup:x:65534:" >> /etc/group \
  && echo "hosts: files dns myhostname mymachines" >> /etc/nsswitch.conf \
  && cp /root/.nix-profile/etc/ssh/sshd_config /etc/ssh \
  && mkdir -p /run \
  && mkdir -p /var/empty/sshd \
  && chmod 755 /var/empty/sshd \
  && sed -i '/^PermitRootLogin/d' /etc/ssh/sshd_config \
  && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
  && cp --remove-destination "$(readlink -f /etc/passwd)" /etc/passwd \
  && cp --remove-destination "$(readlink -f /etc/shadow)" /etc/shadow \
  && usermod -p '*' root \
  && usermod -s /root/.nix-profile/bin/bash root \
  && ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N "" -t rsa \
  && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N "" -t dsa \
  && echo "export NIX_PATH=$NIX_PATH" >> /etc/bashrc \
  && echo "export NIX_SSL_CERT_FILE=$NIX_SSL_CERT_FILE" >> /etc/bashrc \
  && echo "export PATH=$PATH" >> /etc/bashrc \
  && echo "source /etc/bashrc" >> /etc/profile

ADD insecure_rsa /root/.ssh/id_rsa
ADD insecure_rsa.pub /root/.ssh/authorized_keys

EXPOSE 22
CMD ["/root/.nix-profile/bin/sshd", "-D", "-e"]

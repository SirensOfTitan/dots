FROM nix:2.12.0
WORKDIR /root
COPY nix.conf /etc/nix/nix.conf
COPY insecure_rsa /root/.ssh/id_rsa
COPY insecure_rsa.pub /root/.ssh/authorized_keys
COPY sshd_config /etc/ssh/sshd_config
COPY flake.nix ./


RUN nix-build

# Set up SSH for nix builder
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N "" -t rsa \
    && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N "" -t dsa

EXPOSE 22
CMD ["/run/current-system/sw/bin/sshd", "-D", "-e"]

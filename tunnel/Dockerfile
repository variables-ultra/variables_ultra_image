FROM alpine:latest

RUN apk add --update --no-cache openssh tini

COPY tunnel/sshd_config /etc/ssh/sshd_config
COPY secrets/tunnel_ssh_host_key /etc/ssh/ssh_host_ed25519_key
COPY secrets/tunnel_ssh_host_key.pub /etc/ssh/ssh_host_ed25519_key.pub
COPY secrets/tunnel_ssh_key.pub /root/.ssh/authorized_keys

# 安装openssh客户端和服务器
RUN mkdir -p /root/.ssh \
    && mkdir -p /run/sshd \
    && chmod 700 /root/.ssh \
    && chmod 600 /root/.ssh/authorized_keys \
    && chmod 600 /etc/ssh/ssh_host_ed25519_key

# 暴露SSH端口
EXPOSE 22 80 443 5432

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/sbin/sshd", "-D"]

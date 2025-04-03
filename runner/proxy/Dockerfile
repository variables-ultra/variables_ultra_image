FROM alpine:latest

# 更新包列表并安装 autossh 和 openssh-client
RUN apk update && apk add --no-cache autossh openssh-client

COPY runner/proxy/proxy-entrypoint.sh /root/proxy-entrypoint.sh

COPY secrets/proxy_known_hosts /root/.ssh/known_hosts

ENTRYPOINT ["/root/proxy-entrypoint.sh"]

CMD ["-p", "22", "root@tunnel.vu.bppleman.com"]

FROM alpine:latest

# 更新包列表并安装 autossh 和 openssh-client
RUN apk update && apk add --no-cache autossh openssh-client

ENTRYPOINT ["/root/proxy-entrypoint.sh"]

CMD ["-p", "22", "root@tunnel.vu.bppleman.com"]

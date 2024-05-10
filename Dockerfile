FROM alpine:3.19

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.cloud.tencent.com/g' /etc/apk/repositories

RUN apk add --no-cache openssh openssh-sftp-server tini

ADD sshd_config /etc/ssh/sshd_config
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e"]
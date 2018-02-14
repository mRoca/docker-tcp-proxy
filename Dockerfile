FROM alpine:3.7

RUN apk add --no-cache iptables netcat-openbsd

COPY bin/* /usr/bin/

CMD ["/usr/bin/start.sh"]

HEALTHCHECK --interval=10s --timeout=3s --start-period=3s CMD nc -w 3 -vz $(cat /tmp/TARGET_IP) "$TARGET_PORT"

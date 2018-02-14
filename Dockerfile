FROM alpine:3.7

RUN apk add --no-cache iptables netcat-openbsd socat

COPY bin/* /usr/bin/

ENV PROXY_ENGINE=socat

CMD ["/usr/bin/start.sh"]

HEALTHCHECK --interval=10s --timeout=3s --start-period=3s CMD nc -w 3 -vz $(cat /tmp/TARGET_IPs 2>/dev/null || echo "0") "$TARGET_PORT"

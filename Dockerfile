FROM alpine:3.7

RUN apk add --no-cache iptables

COPY bin/* /usr/bin/

CMD ["/usr/bin/start.sh"]

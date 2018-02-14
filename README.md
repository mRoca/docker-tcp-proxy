# Docker TCP proxy

## Usage with socat (default option)

```bash
docker run --name my-proxy -t --rm -e "TARGET=my.mysql.domain.name" -e "TARGET_PORT=3306" mroca/tcp-proxy
```

or, with docker-compose:

```yaml
mysql_proxy:
    image: mroca/tcp-proxy
    environment:
      - TARGET=my-server.eu-west-1.rds.amazonaws.com
      - TARGET_PORT=3306
    ports:
      - "3306:3306"
```

Then, all the trafic comming to the defined port is forwarded to the target :
```bash
nc -vz my-proxy.docker 3306
# my.mysql.domain.name 172.16.0.1:3306) open
```

## Usage with iptables

In order to use iptables instead of socat, you must run the container with the `-e "PROXY_ENGINE=iptables" --cap-add=NET_ADMIN`

If you want to use this container on a system without `ip_forward = 1`, you will have an error. To fix it, just run the container with the `--privileged` flag.

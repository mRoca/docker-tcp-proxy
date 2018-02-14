#!/usr/bin/env sh

echo "Fetching the ${TARGET} ip..."

export TARGET_IP=$(getent hosts "${TARGET}" | awk '{ print $1 }')

if [ -z "${TARGET_IP}" ]; then
    echo "Unable to find the ${TARGET} ip"
    exit 2
fi

echo "Target ip ${TARGET_IP}"
echo ${TARGET_IP} > /tmp/TARGET_IP

if [ $(cat /proc/sys/net/ipv4/ip_forward) -ne "1" ]; then
    echo -e "\nIPv4 forwarding is disabled. Trying to enable it."
    echo 1 > /proc/sys/net/ipv4/ip_forward
    if [ $? -ne 0 ]; then
        echo -e "Unable to enable the ip_forwarding option. Please run this container with the --privileged option."
        exit 1
    fi
fi

iptables -L &>/dev/null
if [ $? -ne 0 ]; then
    echo -e "\nYou must run this container with the --cap-add=NET_ADMIN option (or the --privileged one)."
    exit 1
fi

iptables -t nat -A PREROUTING -p tcp -i eth0 --dport ${TARGET_PORT} -j DNAT --to ${TARGET_IP}:${TARGET_PORT}
iptables -A FORWARD -p tcp -i eth0 --dport ${TARGET_PORT} -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

echo "Iptables rules installed. Waiting for connections."

tail -f /dev/null

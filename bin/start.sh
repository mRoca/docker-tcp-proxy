#!/usr/bin/env sh

if [ -z "${TARGET}" ]; then
    echo "You must set the TARGET variable"
    exit 1
fi

if [ -z "${TARGET_PORT}" ]; then
    echo "You must set the TARGET_PORT variable"
    exit 1
fi

if [ $(cat /proc/sys/net/ipv4/ip_forward) -ne "1" ]; then
    echo -e "\nIPv4 forwarding is disabled. Trying to enable it."
    echo 1 > /proc/sys/net/ipv4/ip_forward
    if [ $? -ne 0 ]; then
        echo -e "Unable to enable the ip_forwarding option. Please run this container with the --privileged option."
        exit 1
    fi
fi

echo "Fetching the ${TARGET} ip..."

ip=$(getent hosts "${TARGET}" | awk '{ print $1 }')
echo "${ip}" > /tmp/TARGET_IP

if [ -z "${ip}" ]; then
    echo "Unable to find the ${TARGET} ip"
    exit 2
fi

echo "Target : ${TARGET} (ip: $ip), Port: ${TARGET_PORT}"

nc -w 3 -vz ${TARGET} ${TARGET_PORT}
if [ $? -ne 0 ]; then
    echo -e "\nUnable to access the ${TARGET}:${TARGET_PORT} port"
    exit 2
fi

iptables -L &>/dev/null
if [ $? -ne 0 ]; then
    echo -e "\nYou must run this container with the --cap-add=NET_ADMIN option (or the --privileged one)."
    exit 1
fi

iptables -t nat -A PREROUTING -p tcp -i eth0 --dport ${TARGET_PORT} -j DNAT --to ${ip}:${TARGET_PORT}
iptables -A FORWARD -p tcp -i eth0 --dport ${TARGET_PORT} -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

echo "Iptables rules installed. Waiting for connections."

tail -f /dev/null

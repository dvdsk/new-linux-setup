#!/usr/bin/env bash

cd /home/david/bin/manual-connections

sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1

sudo PIA_TOKEN=<redacted> \
	WG_SERVER_IP=212.102.35.8 WG_HOSTNAME=amsterdam438 \
	PIA_PF=true ./connect_to_wireguard_with_token.sh

PIA_TOKEN=<redacted> \
    PF_GATEWAY=212.102.35.8 \
    PF_HOSTNAME=amsterdam438 \
    ./port_forwarding.sh

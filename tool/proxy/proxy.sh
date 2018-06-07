#!/bin/bash

#sudo sslocal -c /etc/shadowsocks.json &

if [[ "$1" = "stop" ]]; then
	sudo killall ss-local
	sudo killall privoxy
else
	sudo ss-local -s $ip -p 1443 -l 1080 -k skyd@t@1234 -m chacha20-ietf-poly1305 &
	sudo privoxy /etc/privoxy/config
fi


#!/bin/sh

# Debug output
set -v

# Exit on error
set -e

chown mosquitto:mosquitto -R /mosquitto/data

if [ "$1" = 'mosquitto' ]; then
	mkdir -p '/mosquitto/config/conf.d' || true
	exec /usr/local/sbin/mosquitto -c /mosquitto/config/mosquitto.conf
fi

exec "$@"

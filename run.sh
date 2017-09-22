#!/bin/sh

# Debug output
set -v

# Exit on error
set -e

if [ "$1" = 'mosquitto-app' ]; then
	shift;
	echo Parameters: "\"$@\""
	chown mosquitto:mosquitto -R /mosquitto/data
	mkdir -p '/mosquitto/config/conf.d' || true
	exec /usr/local/sbin/mosquitto "$@"
fi

exec "$@"

#!/bin/sh

# Debug output
set -x

# Exit on error
set -e

if [ -n "$MOSQUITTO_GID" ]; then
	groupmod --gid $MOSQUITTO_GID mosquitto
	usermod --gid $MOSQUITTO_GID mosquitto
fi

if [ -n "$MOSQUITTO_UID" ]; then
	usermod --uid $MOSQUITTO_UID mosquitto
fi

if [ "$1" = 'mosquitto-app' ]; then
	shift;
	mkdir -p '/mosquitto/data' '/mosquitto/log'
	mkdir -p '/mosquitto/config/conf.d' || true
	chown -R mosquitto '/mosquitto/data' '/mosquitto/log'
	exec mosquitto "$@"
fi

exec "$@"

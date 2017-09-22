Mosquitto MQTT server Docker image for Raspberry Pi
===================================================

[![Build Status](https://travis-ci.org/monstrenyatko/docker-rpi-mosquitto-auth.svg?branch=master)](https://travis-ci.org/monstrenyatko/docker-rpi-mosquitto-auth)


About
=====

[Mosquitto](https://mosquitto.org) `MQTT` server in the `Docker` container with `Authentication` plugin.

Upstream Links
--------------
* Docker Registry @[monstrenyatko/rpi-mosquitto-auth](https://hub.docker.com/r/monstrenyatko/rpi-mosquitto-auth/)
* GitHub @[monstrenyatko/docker-rpi-mosquitto-auth](https://github.com/monstrenyatko/docker-rpi-mosquitto-auth)

Authentication plugin
---------------------
It has the [mosquitto-auth-plug](https://github.com/jpmens/mosquitto-auth-plug) to enable authentication.

List of the supported/compiled authentication back-ends:
  - MySQL
  - Redis
  - HTTP
  - JWT
  - MongoDB
  - Files

See `mosquitto-auth-plug` for configuration details.


Quick Start
===========

* Pull prebuilt `Docker` image:

	```sh
		docker pull monstrenyatko/rpi-mosquitto-auth
	```
* Create `Data` storage:

	```sh
		MQTT_DATA="mosquitto-data"
		docker volume create --name $MQTT_DATA
	```
* Prepare `Configuration` directory:

	* Create the `/etc/config/mosquitto/conf.d/` directory
	* [**OPTIONAL**] Add `auth-plugin.conf` with required settings to the `conf.d`
	* [**OPTIONAL**] Add all `.conf` files with additional `Mosquitto` configuration to the `conf.d`

* Start pre built image:

	```sh
		docker-compose up -d
	```

* Stop/Restart:

	```sh
		docker-compose stop
		docker-compose start
	```

Container is already configured for automatic restart (See `docker-compose.yml`).

Build own image
===============

```sh
		cd <path to sources>
		./build.sh <tag name>
```

FROM hypriot/rpi-alpine:3.6

MAINTAINER Oleg Kovalenko <monstrenyatko@gmail.com>

RUN addgroup -S mosquitto && \
    adduser -S -H -h /var/empty -s /sbin/nologin -D -G mosquitto mosquitto

ENV PATH=/usr/local/bin:/usr/local/sbin:$PATH

ENV MOSQUITTO_VERSION=v1.4.14
ENV MONGO_C_VERSION=1.7.0
ENV AUTH_PLUG_VERSION=0.1.2

COPY libressl.patch /
RUN buildDeps='git build-base mariadb-dev libressl-dev libwebsockets-dev c-ares-dev util-linux-dev hiredis-dev curl-dev libxslt docbook-xsl automake autoconf libtool file'; \
    apk update && \
    apk add $buildDeps mariadb-client-libs hiredis libwebsockets libuuid c-ares libressl curl ca-certificates shadow && \
    \
    git clone --depth 1 --single-branch --branch ${MONGO_C_VERSION} https://github.com/mongodb/mongo-c-driver.git mongo-c-driver && \
    cd mongo-c-driver && \
    git checkout ${MONGO_C_VERSION} && \
    sh autogen.sh --with-libbson=bundled --enable-examples=no --enable-tests=no && \
    make && \
    make install && \
    \
    cd / && \
    git clone --depth 1 --single-branch --branch ${MOSQUITTO_VERSION} https://github.com/eclipse/mosquitto.git mosquitto_src && \
    cd mosquitto_src && \
    git checkout ${MOSQUITTO_VERSION} && \
    sed -i -e "s|(INSTALL) -s|(INSTALL)|g" -e 's|--strip-program=${CROSS_COMPILE}${STRIP}||' */Makefile */*/Makefile && \
    sed -i "s@/usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl@/usr/share/xml/docbook/xsl-stylesheets-1.79.1/manpages/docbook.xsl@" man/manpage.xsl && \
    sed -i 's/ -lanl//' config.mk && \
    patch -p1 < /libressl.patch && \
    make WITH_MEMORY_TRACKING=no WITH_SRV=yes WITH_WEBSOCKETS=yes WITH_TLS_PSK=no && \
    make install && \
    \
    git clone --depth 1 --single-branch --branch ${AUTH_PLUG_VERSION} https://github.com/jpmens/mosquitto-auth-plug.git mosquitto-auth-plug && \
    cd mosquitto-auth-plug && \
    git checkout ${AUTH_PLUG_VERSION} && \
    cp config.mk.in config.mk && \
    sed -i "s/BACKEND_MYSQL ?= no/BACKEND_MYSQL ?= yes/" config.mk && \
    sed -i "s/BACKEND_REDIS ?= no/BACKEND_REDIS ?= yes/" config.mk && \
    sed -i "s/BACKEND_HTTP ?= no/BACKEND_HTTP ?= yes/" config.mk && \
    sed -i "s/BACKEND_JWT ?= no/BACKEND_JWT ?= yes/" config.mk && \
    sed -i "s/BACKEND_MONGO ?= no/BACKEND_MONGO ?= yes/" config.mk && \
    sed -i "s/BACKEND_FILES ?= no/BACKEND_FILES ?= yes/" config.mk && \
    sed -i "s/MOSQUITTO_SRC =/MOSQUITTO_SRC = ..\//" config.mk && \
    sed -i "s/EVP_MD_CTX_new/EVP_MD_CTX_create/g" cache.c && \
    sed -i "s/EVP_MD_CTX_free/EVP_MD_CTX_destroy/g" cache.c && \
    make && \
    cp auth-plug.so /usr/local/lib/ && \
    cp np /usr/local/bin/ && chmod +x /usr/local/bin/np && \
    \
    cd / && \
    rm -rf /libressl.patch /mongo-c-driver /mosquitto_src && \
    apk del $buildDeps && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

COPY run.sh /
RUN chmod +x /run.sh

COPY mosquitto.conf /mosquitto/config/mosquitto.conf

VOLUME ["/mosquitto/data", "/mosquitto/log"]

EXPOSE 1883

ENTRYPOINT ["/run.sh"]
CMD ["mosquitto-app", "-c", "/mosquitto/config/mosquitto.conf"]

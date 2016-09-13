FROM alpine:3.4

# grab gosu for easy step-down from root
# see: https://github.com/tianon/gosu
ENV GOSU_VERSION="1.9"
ENV GOSU_DOWNLOAD_URL="https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64"
ENV GOSU_DOWNLOAD_SIG="https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc"

RUN set -x \
    && apk add --no-cache --virtual .gosu-deps \
        gnupg \
        openssl \
    && wget -O /usr/local/bin/gosu $GOSU_DOWNLOAD_URL \
    && wget -O /usr/local/bin/gosu.asc $GOSU_DOWNLOAD_SIG \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps

RUN echo "@stable http://nl.alpinelinux.org/alpine/v3.4/main" >> /etc/apk/repositories \
    && apk update \
    && apk add "postgresql@stable=9.5.4-r0" "postgresql-contrib@stable=9.5.4-r0" \
    && mkdir /docker-entrypoint-initdb.d \
    && rm -rf /var/cache/apk/*

ENV LANG en_US.utf8
ENV PGDATA /var/lib/postgresql/data

VOLUME /var/lib/postgresql/data

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]

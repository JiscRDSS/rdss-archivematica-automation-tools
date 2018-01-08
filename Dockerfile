FROM python:2-alpine

MAINTAINER Arkivum Limited

RUN apk add --no-cache \
        curl \
        gcc \
        jq \
        libxml2 \
        libxml2-dev \
        libxslt \
        libxslt-dev \
        linux-headers \
        musl-dev \
    && pip install -U \
        lxml

COPY ./automation-tools /usr/lib/archivematica/automation-tools

COPY rootfs/usr/local/bin/* /usr/local/bin/

CMD ["run.sh"]

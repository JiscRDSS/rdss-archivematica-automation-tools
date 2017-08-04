FROM python:2-alpine

MAINTAINER Arkivum Limited

RUN apk update && apk add curl jq

COPY ./automation-tools /usr/lib/archivematica/automation-tools

COPY rootfs/usr/local/bin/* /usr/local/bin/

CMD ["run.sh"]

FROM python:3.13.12-alpine3.23

ARG TARGETARCH

COPY ./scripts/alpine/clean /bin/clean

ENV PIP_NO_COMPILE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_CACHE_DIR=/pip-cache \
    PIPENV_VENV_IN_PROJECT=1 \
    TEMP=/tmp \
    ENV=/etc/profile \
    CLEAN="/var/cache/apk/:/tmp/" \
    RAWEXEC="monit crond supervise sshd" \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

RUN chmod +x /bin/clean \
 && mkdir "$PIP_CACHE_DIR" && chmod a+rwx "$PIP_CACHE_DIR" \
 && apk add -u \
            libffi-dev libpq-dev openssl-dev openssl ca-certificates tzdata \
 && addgroup -g 10001 user \
 && adduser -u 10000 -S -s /bin/sh -G user user \
 && echo "user:password" | chpasswd 2>/dev/null \
 && mkdir $PIP_CACHE_DIR/* \
 && clean

FROM alpine:3.18.5

ARG TARGETARCH

# Python
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
    && apk add python3 python3-dev libffi-dev libpq-dev openssl-dev \
    && apk add sqlite-libs --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    && ln -s /usr/bin/pip3 /usr/bin/pip \
    && python3 -m ensurepip --upgrade \
    && pip install -U pip setuptools wheel \
    && addgroup -g 10001 user \
    && adduser -u 10000 -S -s /bin/sh -G user user \
    && echo "user:password" | chpasswd 2>/dev/null \
    && clean

FROM alpine:3.19.1

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
    && apk add -u python3 python3-dev py3-wheel py3-setuptools py3-pip libpq-dev libffi-dev openssl-dev gettext \
    && apk add -u cairo cairo-gobject pango gdk-pixbuf py3-lxml py3-pillow msttcorefonts-installer fontconfig zopfli \
    && apk add -u lua lua-dev lua-penlight zip \
    && apk add -u openssl ca-certificates \
    && apk add -u dbus fontconfig freetype ttf-dejavu ttf-droid ttf-freefont ttf-liberation font-noto-emoji \
    && dbus-uuidgen > /var/lib/dbus/machine-id && apk del dbus \
    && rm -rf /var/cache/apk/* /tmp/* \
    && wget -O /bin/wait-for https://raw.githubusercontent.com/eficode/wait-for/v2.2.3/wait-for && chmod a+x /bin/wait-for \
    && update-ms-fonts \
    && fc-cache -f \
    && addgroup -g 10001 user \
    && adduser -u 10000 -S -s /bin/sh -G user user \
    && echo "user:password" | chpasswd 2>/dev/null \
    && clean

# Pandoc
ENV XDG_DATA_HOME=/ \
    LUA_PATH="/pandoc/filters/?.lua;/usr/share/lua/common/?.lua;;"

RUN wget -O /tmp/pandoc.tar.gz "https://github.com/jgm/pandoc/releases/download/3.1.9/pandoc-3.1.9-linux-${TARGETARCH}.tar.gz" \
    && tar -xvzf /tmp/pandoc.tar.gz -C /tmp && mv /tmp/pandoc*/bin/pandoc /usr/local/bin/pandoc \
    && mkdir -p /pandoc/templates \
    && mkdir -p /pandoc/filters/pandocker \
    && chown -R user:user /pandoc \
    && clean

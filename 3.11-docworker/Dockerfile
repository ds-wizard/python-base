FROM alpine:3.20.2

ARG TARGETARCH

COPY ./scripts/alpine/clean /bin/clean

# Enviroment variables (Pandoc, PIP, OpenSSL)
ENV PIP_NO_COMPILE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_CACHE_DIR=/pip-cache \
    PIPENV_VENV_IN_PROJECT=1 \
    TEMP=/tmp \
    ENV=/etc/profile \
    CLEAN="/var/cache/apk/:/tmp/" \
    RAWEXEC="monit crond supervise sshd" \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    XDG_DATA_HOME=/ \
    LUA_PATH="/pandoc/filters/?.lua;/usr/share/lua/common/?.lua;;"

# Alpine Packages + Update fonts + Setup user + Pandoc + Cleanup
RUN chmod +x /bin/clean \
 && mkdir "$PIP_CACHE_DIR" && chmod a+rwx "$PIP_CACHE_DIR" \
 && apk add -u \
            python3 python3-dev py3-wheel py3-setuptools py3-pip \
            libpq-dev libffi-dev openssl openssl-dev gettext ca-certificates tzdata \
            pango cairo cairo-gobject gdk-pixbuf dbus zopfli \
            xz tar gzip zip unzip lua lua-dev  \
            fontconfig freetype msttcorefonts-installer font-droid font-noto-emoji \
 && dbus-uuidgen > /var/lib/dbus/machine-id && apk del dbus \
 && update-ms-fonts \
 && fc-cache -f \
 && addgroup -g 10001 user \
 && adduser -u 10000 -S -s /bin/sh -G user user \
 && echo "user:password" | chpasswd 2>/dev/null \
 && rm -rf /var/cache/apk/* /tmp/* $PIP_CACHE_DIR/* \
 &&  wget -O /tmp/pandoc.tar.gz "https://github.com/jgm/pandoc/releases/download/3.1.13/pandoc-3.1.13-linux-${TARGETARCH}.tar.gz" \
 && tar -xvzf /tmp/pandoc.tar.gz -C /tmp && mv /tmp/pandoc*/bin/pandoc /usr/local/bin/pandoc \
 && rm -rf /tmp/* \
 && mkdir -p /pandoc/templates /pandoc/filters/pandocker \
 && chown -R user:user /pandoc \
 && apk del msttcorefonts-installer wget \
 && clean

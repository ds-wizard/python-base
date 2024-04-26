FROM public.ecr.aws/lambda/provided:al2023

ARG TARGETARCH

# Enviroment variables (Pandoc, PIP, OpenSSL)
ENV XDG_DATA_HOME=/ \
    LUA_PATH="/pandoc/filters/?.lua;/usr/share/lua/common/?.lua;;" \
    PIP_NO_COMPILE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_CACHE_DIR=/pip-cache \
    PIPENV_VENV_IN_PROJECT=1 \
    TEMP=/tmp \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# RPM Packages + Update fonts + Setup user + Cleanup
# https://docs.aws.amazon.com/linux/al2023/release-notes/all-packages-AL2023.3.html
RUN mkdir "$PIP_CACHE_DIR" && chmod a+rwx "$PIP_CACHE_DIR" \
 && dnf install -y \
        python3.11 python3.11-devel python3.11-wheel python3.11-setuptools python3.11-pip \
        libpq-devel libffi-devel openssl openssl-devel gettext ca-certificates tzdata \
        pango cairo cairo-gobject gettext gdk-pixbuf2 zopfli \
        xz xz-lzma-compat tar gzip zip unzip lua lua-devel \
        fontconfig freetype  google-droid-fonts-all google-noto-emoji-color-fonts google-noto-emoji-fonts \
        cabextract xorg-x11-font-utils \
 && rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm \
 && fc-cache -f  \
 && ln -s /usr/bin/python3.11 /usr/bin/python \
 && ln -s /usr/bin/pip3.11 /usr/bin/pip \
 && pip install awslambdaric boto3 s3transfer \
 && dnf clean all \
 && rm -rf $PIP_CACHE_DIR/*

# Pandoc
RUN curl -L -o /tmp/pandoc.tar.gz -O "https://github.com/jgm/pandoc/releases/download/3.1.13/pandoc-3.1.13-linux-${TARGETARCH}.tar.gz" \
 && tar xvzf /tmp/pandoc.tar.gz -C /tmp \
 && mv /tmp/pandoc*/bin/pandoc /usr/local/bin/pandoc \
 && rm -rf /tmp/* \
 && mkdir -p /pandoc/templates /pandoc/filters/pandocker

FROM surnet/alpine-wkhtmltopdf:3.18.0-0.12.6-small as wkhtmltopdf
FROM alpine:3.18.4

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
    && apk add -u python3 python3-dev libpq-dev libffi-dev openssl-dev gettext \
    && apk add -u cairo cairo-gobject pango gdk-pixbuf py3-brotli py3-lxml py3-cffi py3-pillow msttcorefonts-installer fontconfig zopfli \
    && apk add -u lua lua-dev lua-penlight zip \
    && apk add -u libstdc++ libx11 libxrender libxext libssl1.1 ca-certificates dbus fontconfig freetype ttf-dejavu ttf-droid ttf-freefont ttf-liberation font-noto-emoji \
    && dbus-uuidgen > /var/lib/dbus/machine-id && apk del dbus \
    && rm -rf /var/cache/apk/* /tmp/* \
    && wget -O /bin/wait-for https://raw.githubusercontent.com/eficode/wait-for/v2.2.3/wait-for && chmod a+x /bin/wait-for \
    && update-ms-fonts \
    && fc-cache -f \
    && ln -s /usr/bin/pip3 /usr/bin/pip \
    && python3 -m ensurepip --upgrade \
    && pip install -U pip setuptools wheel \
    && addgroup -g 10001 user \
    && adduser -u 10000 -S -s /bin/sh -G user user \
    && echo "user:password" | chpasswd 2>/dev/null \
    && clean

# Pandoc
ENV XDG_DATA_HOME=/ \
    LUA_PATH="/pandoc/filters/?.lua;;"

RUN wget -O /tmp/pandoc.tar.gz "https://github.com/jgm/pandoc/releases/download/3.1.8/pandoc-3.1.8-linux-${TARGETARCH}.tar.gz" \
    && tar -xvzf /tmp/pandoc.tar.gz -C /tmp && mv /tmp/pandoc*/bin/pandoc /usr/local/bin/pandoc \
    && clean

RUN mkdir -p /pandoc/templates \
    && wget -O /pandoc/templates/eisvogel.latex https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/v2.2.0/eisvogel.tex \
    && wget -O /pandoc/templates/template-letter.tex https://raw.githubusercontent.com/aaronwolen/pandoc-letter/master/template-letter.tex \
    && wget -O /pandoc/templates/chmduquesne.tex https://raw.githubusercontent.com/mszep/pandoc_resume/master/styles/chmduquesne.tex \
    && wget -O /pandoc/templates/chmduquesne.css https://raw.githubusercontent.com/mszep/pandoc_resume/master/styles/chmduquesne.css \
    && wget -O /pandoc/templates/leaflet.latex https://gitlab.com/daamien/pandoc-leaflet-template/raw/1.0/leaflet.latex \
    && chown -R user:user /pandoc \
    && clean

RUN mkdir -p /pandoc/filters \
    && wget -O /tmp/pandoc-filters.zip https://github.com/teoric/pandoc-filters/archive/master.zip && unzip /tmp/pandoc-filters.zip -d /tmp && cd /tmp/pandoc-filters* && find . -name '*.lua' | cpio -pdm /pandoc/filters && clean \
    && wget -O /tmp/filters.zip https://github.com/pandoc/lua-filters/archive/master.zip && unzip /tmp/filters.zip -d /tmp && cp -r /tmp/lua-filters*/**/*.lua /pandoc/filters && clean\
    && wget -O /pandoc/filters/select-meta.lua https://github.com/jgm/select-meta/blob/master/select-meta.lua && clean \
    && wget -O /pandoc/filters/table.lua https://raw.githubusercontent.com/PlushBeaver/pandoc-table-filter/master/table.lua && clean \
    && wget -O /tmp/panpipe.zip https://github.com/mitinarseny/panpipe/archive/master.zip && unzip /tmp/panpipe.zip -d /tmp && cp -r /tmp/panpipe*/*.lua /pandoc/filters && clean \
    && wget -O /pandoc/filters/gls.lua https://raw.githubusercontent.com/tomncooper/pandoc-gls/master/pandoc-gls.lua && clean \
    && wget -O /tmp/pandoc-filters.zip https://github.com/a-vrma/pandoc-filters/archive/master.zip && unzip /tmp/pandoc-filters.zip -d /tmp && cp -r /tmp/pandoc-filters*/dist/*.lua /pandoc/filters && clean \
    && wget -O /tmp/pandocker-lua-filters.zip https://github.com/pandocker/pandocker-lua-filters/archive/master.zip && unzip /tmp/pandocker-lua-filters.zip -d /tmp && cp -r /tmp/pandocker-lua-filters*/lua/*.lua /pandoc/filters && clean \
    && wget -O /tmp/pandoc-odt-filters.zip https://github.com/jzeneto/pandoc-odt-filters/archive/master.zip && unzip /tmp/pandoc-odt-filters.zip -d /tmp && cp -r /tmp/pandoc-odt-filters*/*.lua /pandoc/filters && clean \
    && wget -O /tmp/pandoc-filters.zip https://github.com/hason/pandoc-filters/archive/master.zip && unzip /tmp/pandoc-filters.zip -d /tmp && cd /tmp/pandoc-filters* && find . -name '*.lua' | cpio -pdm /pandoc/filters && clean \
    && wget -O /pandoc/filters/logging.lua https://raw.githubusercontent.com/wlupton/pandoc-lua-logging/main/logging.lua \
    && chown -R user:user /pandoc \
    && clean

# WkHtmlToPdf
COPY --from=wkhtmltopdf /bin/wkhtmltopdf /bin/wkhtmltopdf

# WeasyPrint
RUN pip install weasyprint==60.1 \
    && clean

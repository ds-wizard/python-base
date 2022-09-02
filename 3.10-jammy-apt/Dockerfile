FROM ubuntu:jammy

RUN apt-get update \
 && apt-get install -y \
    python3.10-minimal \
    python3-pip \
    wget \
    libpq-dev \
    gcc \
    git \
    python-is-python3 \
 && python -m pip install --no-cache-dir -U \
    pip \
    setuptools \
    wheel \
 && apt purge -qq -y python3-setuptools

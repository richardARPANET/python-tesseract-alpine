FROM python:3.7-alpine

ENV SHELL=/bin/bash

### Install Tesseract
ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++
ENV LANG=C.UTF-8
ENV TESSDATA_PREFIX=/usr/local/share/tessdata
# Dev tools
WORKDIR /tmp
RUN apk update \
    && apk upgrade \
    && apk add --no-cache file openssl openssl-dev bash tini leptonica-dev \
        openjpeg-dev tiff-dev libpng-dev zlib-dev libgcc mupdf-dev jbig2dec-dev \
        freetype-dev openblas-dev ffmpeg-dev jasper-dev linux-headers enchant-dev aspell-dev aspell-en \
    && apk add --no-cache --virtual .dev-deps git clang clang-dev g++ make automake autoconf libtool pkgconfig cmake ninja \
    && apk add --no-cache --virtual .dev-testing-deps -X http://dl-3.alpinelinux.org/alpine/edge/testing autoconf-archive \
    && ln -s /usr/include/locale.h /usr/include/xlocale.h
# Install from master
RUN mkdir /usr/local/share/tessdata \
    && mkdir src \
    && cd src \
    && wget https://github.com/tesseract-ocr/tessdata_fast/raw/master/eng.traineddata -P /usr/local/share/tessdata \
    && git clone --depth 1 https://github.com/tesseract-ocr/tesseract.git \
    && cd tesseract \
    && ./autogen.sh \
    && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
    && make \
    && make install \
&& cd /tmp/src

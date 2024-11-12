FROM alpine:3.20.3

# Install Firefox
RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN apk --no-cache add pciutils-libs mesa-gl mesa-egl ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-opensans font-adobe-100dpi

RUN apk --no-cache add firefox

ENV FIREFOX_BIN=/usr/bin/firefox \
    FIREFOX_PATH=/usr/lib/firefox/


# Install Chromium
RUN apk --no-cache upgrade && apk add \
    libstdc++ \
    chromium \
    harfbuzz \
    nss \
    freetype \
    ttf-freefont \
    font-noto-emoji \
    wqy-zenhei \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

# Install nodejs/npm
RUN apk add --update nodejs npm bash

WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD 1

COPY package.json ./

RUN npm install

# add app
COPY . ./

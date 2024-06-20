FROM alpine:latest
MAINTAINER colino17

# ENVIRONMENT
ENV BASEURL="https://recipes.example.com"
ENV SITE_TITLE="Recipes"

# INSTALL BASICS
RUN apk update
RUN apk upgrade
RUN apk add --no-cache ca-certificates coreutils shadow gnutls-utils curl bash busybox-suid su-exec tzdata

# INSTALL HUGO
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo

# DIRECTORIES
ADD site /site

# PORTS
EXPOSE 1313

# COMMAND
CMD env HUGO_TITLE="$SITE_TITLE" hugo --watch --source "/site" --config "/site/config.toml" --baseURL "$BASEURL"

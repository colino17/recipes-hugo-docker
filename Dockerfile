FROM alpine:latest
MAINTAINER colino17

# ENVIRONMENT
ENV
ENV

# INSTALL BASICS
RUN apk update
RUN apk upgrade
RUN apk add --no-cache ca-certificates coreutils shadow gnutls-utils curl bash busybox-suid su-exec tzdata

# INSTALL HUGO
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo

# DIRECTORIES
ADD site /site

# VOLUMES
VOLUME /site/content/recipe

# PORTS
EXPOSE 7777

# COMMAND
CMD ["hugo", "server", "--bind", "0.0.0.0", "--port", "7777" "--cleanDestinationDir", "--forceSyncStatic", "--buildDrafts", "--meminterval=1h", "--memstats=/dev/stdout", "--source", "/site", "--config", "/site/config.toml"]

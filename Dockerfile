FROM alpine:latest
MAINTAINER colino17

# ENVIRONMENT
ENV BASEURL=

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
#CMD ["hugo", "server", "--bind", "0.0.0.0", "--port", "1313" "--cleanDestinationDir", "--forceSyncStatic", "--buildDrafts", "--meminterval=1h", "--memstats=/dev/stdout", "--source", "/site", "--config", "/site/config.toml"]
CMD hugo server \
    --bind 0.0.0.0 \
    --baseURL $BASEURL \
    --cleanDestinationDir \
    --source /site \
    --config /site/config.toml

FROM nginx:1.11
MAINTAINER Gonzalo Peci <gonzalo@coya.insure>
ENV DEBIAN_FRONTEND noninteractive

ENV HTPASSWD='foo:$apr1$odHl5EJN$KbxMfo86Qdve2FH4owePn.'

COPY docker/default.conf /etc/nginx/conf.d/default.conf
COPY docker/auth.htpasswd ./
COPY docker/config.js ./
COPY docker/entrypoint.sh /usr/local/bin/entrypoint

COPY build /usr/share/nginx/html

ENTRYPOINT ["entrypoint"]

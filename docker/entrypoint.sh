#!/bin/bash

set -e

envsubst <auth.htpasswd >/etc/nginx/auth.htpasswd
envsubst <config.js >/usr/share/nginx/html/javascripts/config.js

nginx -g "daemon off;"


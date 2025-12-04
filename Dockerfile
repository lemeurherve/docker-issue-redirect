FROM bash:5.3.8-alpine3.22 AS builder

WORKDIR /

COPY . .
RUN ./bin/redirects.sh

FROM nginx:1.29.3-alpine

RUN mkdir -p /etc/nginx/includes

COPY --from=builder jira-to-github-redirects.conf /etc/nginx/includes/jira-to-github-redirects.conf 

COPY docker/favicon.ico /usr/share/nginx/html/favicon.ico
COPY docker/default.conf /etc/nginx/conf.d/default.conf
COPY docker/index.html /usr/share/nginx/html/index.html

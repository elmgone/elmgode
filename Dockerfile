# FROM ubuntu
FROM golang

ENV http_proxy http://web-proxy.bbn.hpecorp.net:8080
ENV HTTP_PROXY http://web-proxy.bbn.hpecorp.net:8080
ENV https_proxy http://web-proxy.bbn.hpecorp.net:8080
ENV HTTPS_PROXY http://web-proxy.bbn.hpecorp.net:8080

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update
RUN apt-get install -y nodejs

# RUN npm help config
# RUN npm help proxy
RUN npm install -g elm

EXPOSE 8000

# ENTRYPOINT [ "elm" ]

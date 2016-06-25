# FROM ubuntu
FROM golang

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update
RUN apt-get install -y nodejs

RUN npm install -g elm

EXPOSE 8000
EXPOSE 6060

# ENTRYPOINT [ "elm" ]

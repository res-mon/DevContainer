FROM golang:1.22.1-alpine3.19 AS go



FROM node:21.7.1-alpine3.19


RUN apk add --no-cache build-base gcc musl-dev sqlite-dev git ca-certificates wget su-exec && npm install -g elm

# From https://hub.docker.com/_/golang
ENV GOLANG_VERSION=1.22.1
ENV GOTOOLCHAIN=local
ENV GOPATH=/go
ENV PATH=/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY --from=go /usr/local/go/ /usr/local/go/
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"

EXPOSE 8321
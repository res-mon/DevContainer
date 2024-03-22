FROM haskell:9.8.2-buster AS elm
RUN apt install git
RUN git clone https://github.com/elm/compiler.git /elm-src
RUN cd /elm-src && cabal build



FROM golang:1.22.1-alpine3.19 AS go



FROM node:21.7.1-alpine3.19


RUN apk add --no-cache build-base gcc musl-dev sqlite-dev git ca-certificates wget su-exec

# From https://hub.docker.com/_/golang
ENV GOLANG_VERSION=1.22.1
ENV GOTOOLCHAIN=local
ENV GOPATH=/go
ENV PATH=/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY --from=go /usr/local/go/ /usr/local/go/
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
COPY --from=elm /elm-src/elm /bin/elm

EXPOSE 8321

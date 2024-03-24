# From https://github.com/based-template/building-elm-from-source
# From https://www.haskell.org/ghcup/install/
FROM ubuntu:23.04 AS elm
ENV PATH=/root/.ghcup/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN apt update
RUN apt install -y wget build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev pkg-config zlib1g-dev
RUN rm -rf /var/lib/apt/lists/*
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
RUN ghcup install ghc 8.4.3 && ghcup install cabal 2.4.1
RUN ghcup set ghc 8.4.3 && ghcup set cabal 2.4.1
RUN wget https://github.com/elm/compiler/archive/refs/tags/0.19.1.tar.gz
RUN tar -xvzf ./0.19.1.tar.gz
RUN cd compiler-0.19.1/ && rm worker/elm.cabal && cabal new-update && cabal new-configure --ghc-option=-optl=-pthread && cabal new-build
RUN cp compiler-0.19.1/dist-newstyle/build/*/ghc-8.4.3/elm-0.19.1/x/elm/build/elm/elm /
RUN chmod 777 /elm


FROM golang:1.22.1-bookworm AS go



FROM node:21.7.1-bookworm
RUN apt update
RUN apt install -y build-essential git wget ca-certificates musl-dev gcc libc6-dev mingw-w64 gcc-arm-linux-gnueabihf gcc-aarch64-linux-gnu

# From https://hub.docker.com/_/golang
ENV GOLANG_VERSION=1.22.1
ENV GOTOOLCHAIN=local
ENV GOPATH=/go
ENV PATH=/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY --from=go /usr/local/go/ /usr/local/go/
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"

COPY --from=elm /elm /bin/elm

EXPOSE 8321

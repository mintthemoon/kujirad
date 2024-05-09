FROM golang:1.21.8-bullseye AS build
ARG branch=v1.1.0-beta
WORKDIR /build
RUN git clone \
        -c advice.detachedHead=false \
        --single-branch \
        --branch ${branch} \
        --depth 1 \
        https://github.com/Team-Kujira/core.git \
        . \
    && make install \
    && kujirad version
WORKDIR /dist
RUN mkdir bin lib \
    && mv $(ldd $(which kujirad) | grep libwasmvm.x86_64.so | awk '{print $3}') lib/ \
    && mv $(which kujirad) bin/

FROM ubuntu:jammy
COPY --from=build /dist/bin/* /usr/local/bin/
COPY --from=build /dist/lib/* /usr/lib/
COPY start.sh /usr/local/bin/
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y curl jq lz4 ca-certificates \
    && groupadd -g 3333 -r kujira \
    && useradd -m -u 3333 -g kujira -s /bin/bash -d /kujira kujira
USER kujira:kujira
WORKDIR /kujira
ENTRYPOINT ["start.sh"]

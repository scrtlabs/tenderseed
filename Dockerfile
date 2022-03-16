FROM golang:1.15.5-alpine3.12 as builder

# Set workdir
WORKDIR /sources

# Add source files
COPY cmd cmd
COPY internal internal
COPY Makefile Makefile
COPY go.mod go.mod
COPY go.sum go.sum


# Install minimum necessary dependencies
RUN apk add --no-cache make gcc libc-dev

RUN make build

COPY start.sh start.sh
# ----------------------------

FROM alpine:3.12

ARG TENDERSEED_SEEDS
ARG TENDERSEED_CHAIN_ID
ARG TENDERSEED_NODE_KEY

ENV TENDERSEED_CHAIN_ID=${TENDERSEED_CHAIN_ID}
ENV TENDERSEED_SEEDS=${TENDERSEED_SEEDS}

COPY --from=builder /sources/build/ /usr/local/bin/

RUN addgroup tendermint && adduser -S -G tendermint tendermint -h /data

USER tendermint

WORKDIR /data
RUN mkdir -p /data/.tenderseed/config

COPY --from=builder /sources/start.sh /data/start.sh

EXPOSE 26656

CMD ["sh", "-c", "/data/start.sh"]

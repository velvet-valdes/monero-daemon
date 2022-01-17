FROM ubuntu:20.04 AS build

ENV MONERO_VERSION=0.17.3.0 MONERO_SHA256=ac18ce3d1189410a5c175984827d5d601974733303411f6142296d647f6582ce


RUN apt-get update && apt-get install -y wget bzip2

WORKDIR /root

RUN wget https://dlsrc.getmonero.org/cli/monero-linux-x64-v$MONERO_VERSION.tar.bz2 && \
  echo "$MONERO_SHA256 monero-linux-x64-v$MONERO_VERSION.tar.bz2" | sha256sum -c - && \
  tar -xvf monero-linux-x64-v$MONERO_VERSION.tar.bz2 && \
  rm monero-linux-x64-v$MONERO_VERSION.tar.bz2 && \
  cp ./monero-x86_64-linux-gnu-v$MONERO_VERSION/monerod . && \
  rm -r monero-*

FROM ubuntu:20.04

RUN useradd -ms /bin/bash monero && mkdir -p /home/monero/.bitmonero && chown -R monero:monero /home/monero/.bitmonero
USER monero
WORKDIR /home/monero

COPY --chown=monero:monero --from=build /root/monerod /home/monero/monerod

# blockchain location
VOLUME /home/monero/.bitmonero

EXPOSE 18080 18081 18083

# rpc options set to listen on all addresses
ENTRYPOINT ["./monerod"]
CMD ["--zmq-pub", "tcp://0.0.0.0:18083", "--non-interactive", "--disable-dns-checkpoints", "--enable-dns-blocklist", "--restricted-rpc", "--rpc-bind-ip=0.0.0.0", "--confirm-external-bind"]
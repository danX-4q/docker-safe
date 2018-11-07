#FROM ubuntu:16.04
FROM bankledger/s-edb:2.0.0-u16.04-1

ADD ./docker-fs-root/ /
WORKDIR /home/s-ed/

ENV DEBIAN_FRONTEND noninteractive
RUN chmod +x setup-only-once.sh && \
    DOCKER_ONBUILD=true ./setup-only-once.sh

CMD ["tail", "-f", "/dev/null"]


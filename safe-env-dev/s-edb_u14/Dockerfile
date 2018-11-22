FROM ubuntu:14.04

ADD ./docker-fs-root/ /
WORKDIR /home/s-edb/

ENV DEBIAN_FRONTEND noninteractive
RUN chmod +x setup-only-once.sh && \
    DOCKER_ONBUILD=true ./setup-only-once.sh

RUN echo "Asia/Shanghai" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    locale-gen zh_CN.UTF-8 && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
ENV TZ=Asia/Shanghai LANG=zh_CN.UTF-8 LANGUAGE=zh_CN:zh LC_ALL=zh_CN.UTF-8

CMD ["tail", "-f", "/dev/null"]


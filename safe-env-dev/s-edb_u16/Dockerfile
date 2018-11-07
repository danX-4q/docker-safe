FROM ubuntu:16.04

ADD ./docker-fs-root/ /
WORKDIR /home/s-edb/

ENV DEBIAN_FRONTEND noninteractive
RUN chmod +x setup-only-once.sh && \
    DOCKER_ONBUILD=true ./setup-only-once.sh

ENV TZ=Asia/Shanghai
RUN echo "Asia/Shanghai" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

RUN locale-gen zh_CN.UTF-8 && \
  DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN locale-gen zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8

CMD ["tail", "-f", "/dev/null"]


FROM ubuntu:16.04
#16.04: Pulling from library/ubuntu
#b849b56b69e7: Pull complete 
#42986ef25bcd: Pull complete 
#d927c1b717ec: Pull complete 
#15b86ea20233: Pull complete 
#Digest: sha256:b967b9f2a5625231a22db642609e61b7b1a5481128f51fe771e91bb92e0a35d0
#Status: Downloaded newer image for ubuntu:16.04

ADD ./docker-fs-root/ /
WORKDIR /home/sc-et/

ENV DEBIAN_FRONTEND noninteractive
RUN chmod +x setup-only-once.sh && \
    DOCKER_ONBUILD=true ./setup-only-once.sh

RUN echo "Asia/Shanghai" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    locale-gen zh_CN.UTF-8 && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
ENV TZ=Asia/Shanghai LANG=zh_CN.UTF-8 LANGUAGE=zh_CN:zh LC_ALL=zh_CN.UTF-8

CMD ["tail", "-f", "/dev/null"]


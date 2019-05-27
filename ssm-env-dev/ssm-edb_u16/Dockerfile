FROM ubuntu:16.04
#16.04: Pulling from library/ubuntu
#Digest: sha256:cad5e101ab30bb7f7698b277dd49090f520fe063335643990ce8fbd15ff920ef
#Status: Image is up to date for ubuntu:16.04
#FROM ubuntu@cad5e101ab30bb7f7698b277dd49090f520fe063335643990ce8fbd15ff920ef

ADD ./docker-fs-root/ /
WORKDIR /home/ssm-edb/

ENV DEBIAN_FRONTEND noninteractive
RUN chmod +x setup-only-once.sh && \
    DOCKER_ONBUILD=true ./setup-only-once.sh

RUN echo "Asia/Shanghai" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    locale-gen zh_CN.UTF-8 && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
ENV TZ=Asia/Shanghai LANG=zh_CN.UTF-8 LANGUAGE=zh_CN:zh LC_ALL=zh_CN.UTF-8 DISPLAY=:0

CMD ["tail", "-f", "/dev/null"]


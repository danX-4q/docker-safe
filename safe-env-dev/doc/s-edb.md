# s-edb

## function & feature

* 继承bankledger/s-edb:`x.y.z`-`os`-`pack-id`。
* 检出某个版本的safe/depends目录源码(详见每个s-edb镜像的release note)，并完成四个目标平台的编译；部署在/home/s-edb/depends_bin目录。
* 提供s-edb--***系列脚本，部署在/usr/local/bin/目录，用于配合safe源码目录与depends目录相关的操作。

## docker tag规则

规则：bankledger/s-edb:`x.y.z`-`os`-`pack-id`

x.y.z：版本号

os：操作系统代号。u16.04，ubuntu16.04；u14.04，ubuntu14.04；暂无其它。

pack-id：打包流水号，从开发阶段即开始从1递增，用于在docker仓库中区分镜像名称。

## docker-compose build

```shell
cd safe-env-dev/s-edb_u16/ # or cd safe-env-dev/s-edb_u14/
docker-compose build
```

## docker-compose up

```shell
cd safe-env-dev/s-edb_u16/ # or cd safe-env-dev/s-edb_u14/
docker-compose up -d
```

* 特别说明：

  * docker-compose.yaml文件中，指定了两个docker挂载卷：

  * ./docker-mount/bankledger:/home/bankledger

  * ./docker-mount/ex-work:/home/ex-work

  可根据自己的需要，修改宿主机的挂载目录，比如，挂载到已在宿主机git clone的safe源码目录。这样，就可以在进入容器(方法见下文)后，使用s-edb编译工具及环境，对实际存放于宿主机的safe源码目录进行编译链接，最终输出对应目标平台的可执行文件。

## docker-compose exec

```shell
cd safe-env-dev/s-edb_u16/ # or cd safe-env-dev/s-edb_u14/
docker-compose exec s-edb bash #运行容器的交互式bash shell，运行环境已经进入docker容器
#默认进入容器的 /home/s-edb/ 目录
```

## s-edb编译safe源码

* 假设
  * 宿主机/home/safe目录存放safe的源码，挂载到容器的/home/bankledger/目录。
  * 宿主机已经运行容器，并进入容器。

* 操作

```shell
cd /home/bankledger/ #实际读写的是宿主机/home/safe目录。
s-edb--link-depends_bin -v
#如果镜像打包的depends源码，与当前safe源码目录下的depends源码不一致，将给出提示。
#如果执行成功，则根据目标平台执行下述对应的命令，进行configure及make。
#1. s-edb--configure-x86_64-pc-linux-gnu && make
#2. s-edb--configure-x86_64-w64-mingw32 && make
#3. s-edb--configure-i686-w64-mingw32 && make
#4. s-edb--configure-x86_64-apple-darwin11 && make
```


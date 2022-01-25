# What is Redis?


Redis is often referred to as a data structures server. What this means is that Redis provides access to mutable data structures via a set of commands, which are sent using a server-client model with TCP sockets and a simple protocol. So different processes can query and modify the same data structures in a shared way.

Data structures implemented into Redis have a few special properties:

Redis cares to store them on disk, even if they are always served and modified into the server memory. This means that Redis is fast, but that it is also non-volatile.
The implementation of data structures emphasizes memory efficiency, so data structures inside Redis will likely use less memory compared to the same data structure modelled using a high-level programming language.
Redis offers a number of features that are natural to find in a database, like replication, tunable levels of durability, clustering, and high availability.
Another good example is to think of Redis as a more complex version of memcached, where the operations are not just SETs and GETs, but operations that work with complex data types like Lists, Sets, ordered data structures, and so forth.

If you want to know more, this is a list of selected starting points:

Introduction to Redis data types. https://redis.io/topics/data-types-intro
Try Redis directly inside your browser. https://try.redis.io
The full list of Redis commands. https://redis.io/commands
There is much more inside the official Redis documentation. https://redis.io/documentation


## 目录

- [集群背景](#集群背景)
- [安装配置](#安装配置)
- [如何使用](#如何使用)
- [最佳实践](#最佳实践)
- [License](#license)

## 集群背景
![image](https://user-images.githubusercontent.com/96233798/150904170-7cdf3be2-88ab-4caa-8852-b7c0e893f287.png)

问题分析
本质上来说，在k8s上部署一个redis集群和部署一个普通应用没有什么太大的区别，但需要注意下面几个问题：

redis是一个有状态应用

这是部署redis集群时我们最需要注意的问题，当我们把redis以pod的形式部署在k8s中时，每个pod里缓存的数据都是不一样的，而且pod的IP是会随时变化，这时候如果使用普通的deployment和service来部署redis-cluster就会出现很多问题，因此需要改用StatefulSet + Headless Service来解决

数据持久化
redis虽然是基于内存的缓存，但还是需要依赖于磁盘进行数据的持久化，以便服务出现问题重启时可以恢复已经缓存的数据。在集群中，我们需要使用共享文件系统 + PV（持久卷）的方式来让整个集群中的所有pod都可以共享同一份持久化储存

概念介绍
在开始之前先来详细介绍一下几个概念和原理

Headless Service 简单的说，Headless Service就是没有指定Cluster IP的Service，相应的在k8s的dns映射里，Headless Service的解析结果不是一个Cluster IP，而是它所关联的所有Pod的IP列表

StatefulSet 参考介绍 StatefulSet是k8s中专门用于解决有状态应用部署的一种资源，总的来说可以认为它是Deployment/RC的一个变种，它有以下几个特性：

StatefulSet管理的每个Pod都有唯一的文档/网络标识，并且按照数字规律生成，而不是像Deployment中那样名称和IP都是随机的（比如StatefulSet名字为redis，那么pod名就是redis-0, redis-1 ...）

StatefulSet中ReplicaSet的启停顺序是严格受控的，操作第N个pod一定要等前N-1个执行完才可以

StatefulSet中的Pod采用稳定的持久化储存，并且对应的PV不会随着Pod的删除而被销毁

另外需要说明的是，StatefulSet必须要配合Headless Service使用，它会在Headless Service提供的DNS映射上再加一层，最终形成精确到每个pod的域名映射，格式如下：

$(podname).$(headless service name)

有了这个映射，就可以在配置集群时使用域名替代IP，实现有状态应用集群的管理

## 安装配置

This project uses [node](http://nodejs.org) and [npm](https://npmjs.com). Go check them out if you don't have them locally installed.

```sh
$ npm install --global standard-readme-spec
```

## 使用

This is only a documentation package. You can print out [spec.md](spec.md) to your console:

```sh
$ standard-readme-spec
# Prints out the standard-readme spec
```

## 最佳实践

To see how the specification has been applied, see the [example-readmes](example-readmes/).


## License

[MIT](LICENSE) © Richard Littauer

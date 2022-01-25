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

![image](https://user-images.githubusercontent.com/96233798/150905201-8402ef35-1023-44b2-a938-e1694a3510ab.png)



这是部署redis集群时我们最需要注意的问题，当我们把redis以pod的形式部署在k8s中时，每个pod里缓存的数据都是不一样的，而且pod的IP是会随时变化，这时候如果使用普通的deployment和service来部署redis-cluster就会出现很多问题，因此需要改用StatefulSet + Headless Service来解决

数据持久化
redis虽然是基于内存的缓存，但还是需要依赖于磁盘进行数据的持久化，以便服务出现问题重启时可以恢复已经缓存的数据。在集群中，我们需要使用共享文件系统 + PV（持久卷）的方式来让整个集群中的所有pod都可以共享同一份持久化储存




## 安装配置

Clone 当前仓库 yaml 文件，在 kubernetes 部署

```sh
$ kubectl apply -f ./*
```
or 

install redis-ha;
```sh
$ helm install stable/redis-ha
```
默认情况下，此图表共安装 3 个 pod
一个 pod，包含一个 redis master 和 sentinel 容器（可选的 prometheus  sidecar 可用）
两个 pod，每个 pod 包含一个 redis slave 和 sentinel 容器（可选的 prometheus sidecar 可用）
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

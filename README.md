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
- [最佳实践](#最佳实践)
- [License](#license)

## 集群背景

![image](https://user-images.githubusercontent.com/96233798/150905201-8402ef35-1023-44b2-a938-e1694a3510ab.png)


一、什么是Redis Cluster集群

1.Redis Cluster是一组Redis实例，旨在通过对数据库进行分区来扩展数据库，从而使其更具弹性。
2.群集中的每个成员（无论是主副本还是辅助副本）都管理哈希槽的子集。如果主机无法访问，则其从机将升级为主机。在由三个主节点组成的最小Redis群集中，每个主节点都有一个从节点（以实现最小的故障转移），每个主节点都分配有一个介于0到16,383之间的哈希槽范围。节点A包含从0到5000的哈希槽，节点B从5001到10000，节点C从10001到16383。
3.群集内部的通信是通过内部总线进行的，使用协议传播有关群集的信息或发现新节点。

二、在Kubernetes中部署Redis Cluster集群过程记录

1.在Kubernetes中部署Redis集群面临挑战，因为每个Redis实例都依赖于一个配置文件，该文件可以跟踪其他集群实例及其角色。为此，我们需要结合使用StatefulSets控制器和PersistentVolumes持久化存储。

三、StatefulSet的设计原理模型:

1.拓扑状态：

1.1 应用的多个实例之间不是完全对等的关系,这个应用实例的启动必须按照某些顺序启动,比如应用的主节点 A 要先于从节点 B 启动。而如果你把 A 和 B 两个Pod删除掉,他们再次被创建出来是也必须严格按照这个顺序才行,并且,新创建出来的Pod,必须和原来的Pod的网络标识一样,这样原先的访问者才能使用同样的方法,访问到这个新的Pod

2.存储状态：

2.1 应用的多个实例分别绑定了不同的存储数据.对于这些应用实例来说,Pod A第一次读取到的数据,和隔了十分钟之后再次读取到的数据,应该是同一份,哪怕在此期间Pod A被重新创建过.一个数据库应用的多个存储实例。

3.存储卷

3.1 了解statefulset状态后，应该知道要为数据准备一个存储卷了，创建方式有静态方式和动态方式，静态方式就是手动创建PV、PVC，然后POD进行进行调用即可。这里使用动态NFS作为挂载卷，需要部署NFS动态StorageClass


## 安装配置

Clone 当前（Kubernetes-Satesfulset-Gather）仓库 yaml 文件，在 kubernetes 部署

```sh
$ kubectl apply -f ./*
```
or 部署高可用 cluster redis 集群

install redis-ha 
```sh
$ helm install stable/redis-ha
```
默认情况下，此图表共安装 3 个 pod

其中 1 个 pod，包含一个 redis master 和 sentinel 容器（可选的 prometheus  sidecar 可用）

另一个 pod， pod 中包含一个 redis slave 和 sentinel 容器（可选的 prometheus sidecar 可用）


## 最佳实践

# 初始化集群

```sh
kubectl exec -it redis-cluster-0 -n redis-cluster-issac \
		-- redis-cli --cluster create \
		--cluster-replicas 1 \
$(kubectl get pods -l app=redis-cluster -n redis-cluster-issac -o jsonpath='{range.items[*]}{.status.podIP}:6379 ')
```
#  连接到 redis-0 容器
$  kubectl exec -it redis-cluster-0 -n redis-cluster-example -- /bin/bash
#  使用 redis-cli 工具连接到任意节点
$  redis-cli -c -p 6379
#  查看集群节点
$  cluster nodes	  和   cluster info



## License

[MIT](LICENSE) © Richard Littauer

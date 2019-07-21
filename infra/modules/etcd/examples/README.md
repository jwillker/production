# For tests:

Run in etcd host

    $ ETCDCTL_API=3 etcdctl --endpoints=https://etcd-b.k8s.devopxlabs.com:2379,https://etcd-a.k8s.devopxlabs.com:2379,https://etcd-c.k8s.devopxlabs.com:2379 -w table endpoint --cluster status

    $ ETCDCTL_API=3 etcdctl --endpoints=https://etcd-b.k8s.devopxlabs.com:2379,https://etcd-a.k8s.devopxlabs.com:2379,https://etcd-c.k8s.devopxlabs.com:2379 endpoint --cluster health

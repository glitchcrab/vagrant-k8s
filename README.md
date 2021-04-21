# vagrant-virtualbox-k8s

Create a Kubernetes cluster in Virtualbox for quick prototyping.

## Rationale

There are plenty of cluster bootstrap tools out there already, but none give the ability to easily attach additional disks to nodes. This method is simple to get started with and easy to modify to suit your needs. This repo was created for the purpose of testing [rook](https://github.com/rook/rook) deployment scenarios.

## Requirements

- A working install of Virtualbox.
- ~20Gb of disk space.
  - Each worker will have a 5Gb additional disk attached.

## Using

#### Create the cluster:

```bash
VAGRANT_EXPERIMENTAL="disks" vagrant up
```

Note: the `VAGRANT_EXPERIMENTAL` env var must be provided to provision
and attach the additional disks. If you omit this then the cluster will
still start fine, but you won't have the additional disks.

#### Interact with Kubernetes

```bash
export KUBECONFIG=assets/kubeconfig
kubectl get no
NAME     STATUS   ROLES                  AGE    VERSION
master   Ready    control-plane,master   102m   v1.21.0
node1    Ready    worker                 24m    v1.21.0
node2    Ready    worker                 22m    v1.21.0
node3    Ready    worker                 15m    v1.21.0
```

#### Destroy the cluster:

```bash
vagrant destroy
```

## Notes

Port `6443` is forwarded from `127.0.0.1` on the host to the Kubernetes
API server on the `master` VM.

A kubeconfig with full `system:masters` privileges is located in the
`assets` dir once the master node has been bootstrapped.

The `assets` dir is wiped out at the start of each run.

### Credits

This is a modified and updated version of [k8s-vagrant-virtualbox](https://github.com/LocusInnovations/k8s-vagrant-virtualbox)

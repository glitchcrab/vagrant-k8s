#!/bin/bash

sudo /vagrant/assets/join.sh
echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=10.0.0.${2}\"" | sudo tee -a /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
cat /vagrant/assets/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# make the kubeconfig available
mkdir -p $HOME/.kube
sudo cp -i /vagrant/assets/kubeconfig-internal $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# label the node with its role
kubectl label --overwrite=true no ${1} node-role.kubernetes.io/worker=

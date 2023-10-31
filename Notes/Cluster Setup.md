install docker
https://v1-27.docs.kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
`--pod-network-cidr=10.244.0.0/16`
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
remove taint

AWS:
* notes about machine/s
* Ubuntu 20.04
* t2.large
* 50g
* Set up as an ami after creating

Or just ubuntu and k3d
https://k3d.io/v5.4.6/usage/exposing_services/
```k3d cluster create -p "30000-30010:30000-30010@server:0" --api-port 6550 -p "8081:80@loadbalancer"```
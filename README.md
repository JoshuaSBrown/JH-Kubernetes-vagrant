******************************************************************
General Layout and Overview
******************************************************************

This vagrantbox is designed to create a cluster of a master server 
with at most 4 minions. The ip addresses asssociated with each are 
shown below:

192.168.1.10 - master
192.168.1.11 - minion1
192.168.1.12 - minion2
192.168.1.13 - minion3
192.168.1.14 - minion4

The master node will act as a kubernetes server and will have the 
following services running on it:

etcd
kube-apiserver
kube-controller-manager
kube-scheduler
kube-proxy
kubelet
flanneld
docker

Each minion will have the following services running:

kube-proxy
kubelet
flanneld
docker

******************************************************************
Service Descriptions
******************************************************************

A brief descritption of what each service is doing is now provided. 

etcd
******************************************************************

This is the backbone of kubernetes it uses the raft protocol which
is ideal for distributed computing. It ensures that the machines 
reach a consensus on the state of cluster as a whole. It allows the
system to maintain stability even when a minority of the nodes fail.
It is used within the kubernetes framework as a backing store. 
Basically all the cluser data is stored with etcd. 

kube-apiserver
******************************************************************

This service exposes the kubernetes api. It is the front-end or means
by which user interacts with the kubernetes package. It scales by 
deploying more instances (scales horizontally).

kube-controller-manager
******************************************************************

This service runs controllers; they are the baground threads that 
handle routine tasks in the cluster. Each controller is a seperate 
process but they are all compiled in a single binary for 
simplicity. The controllers include:

 * Node Controller - Responsible for noticing and responding when
                     nodes crash.

 * Replication Controller - Responsible for maintaining the correct
                     number of pods for every replication
                     controller object in the system.

 * Endpoints Controller - Populates the Endpoints object (That is 
                     joins services and pods)

 * Service Account & Token Controllers - Create default accounts
                     and API access tokens for new namespaces. 

kube-scheduler
******************************************************************

This service watches newly created pods that have no node assigned,
and selects a node for them to run on. 

flanneld
******************************************************************

Flannel runs a small, single binary agent called flanneld on each 
host, and is responsible for allocating a subnet lease to each host 
out of a larger, preconfigured address space. Flannel uses either 
the Kubernetes API or etcd directly to store the network 
configuration, the allocated subnets, and any auxiliary data (such as 
the host's public IP). Packets are forwarded using one of several 
backend mechanisms including VXLAN and various cloud integrations.

Every instance of flannel is designed to communicate with etcd on located
on the master node and listening at port 2379

For more information refer to: 

https://kubernetes.io/docs/concepts/overview/components/

Access to juypter notebooks is provided through port 8888 make sure you use
https and not http to access the notebook. This is when you actually start a 
notebook server

Currently jupyterhub is configured through port 8000. So when the jupyterhub 
server is running you can access it through port 8000.  

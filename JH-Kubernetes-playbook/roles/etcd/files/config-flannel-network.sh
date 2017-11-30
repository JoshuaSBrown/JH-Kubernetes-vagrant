#!/bin/bash

# Remove the key if it exists
etcdctl rm /atomic.io/network/config
# Create key value pair in etcd to be used by flannel
# This tells us that it is a class B network the first
# 16 bits are reserved for the netmask and the following
# 16 bits can be used to describe the hosts 
etcdctl mk /atomic.io/network/config '{"Network":"192.168.0.0/16"}'

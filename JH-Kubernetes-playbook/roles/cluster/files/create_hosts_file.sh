#!/bin/bash

host_name=$(hostname)
host_ip=$(hostname -I | awk '{ print $2 }')

echo "127.0.0.1    $host_name $host_name" > /etc/hosts
echo "127.0.0.1    localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/hosts
echo "127.0.0.1    localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
echo "$host_ip localhost" >> /etc/hosts

# Add the master ip address and name to the hosts file if on a minion
if [ "$host_name" == "jupyterhub" ]; then
  echo "192.168.1.11 JH-Kubernetes-master" >> /etc/hosts
elif [ "$host_name" == "JH-Kubernetes-master" ]; then
  echo "192.168.1.10 jupyterhub" >> /etc/hosts
else
  echo "192.168.1.10 jupyterhub" >> /etc/hosts
  echo "192.168.1.11 JH-Kubernetes-master" >> /etc/hosts
fi

# Add all the minion ip addresses except for the ip address associated
# with the current node if it is a minion because it has already been 
# added at this point. 
for i in {1..4}; do 
  name="JH-Kubernetes-minion-"$i
  if [ "$name" != "$host_name" ];then
    j=$(expr $i + 1)
    echo "192.168.1.1$j $name" >> /etc/hosts
  fi
done

exit 0

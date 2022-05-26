# Deploy NFS Server First on kmaster or on separate server any way

```
$ sudo apt -y install nfs-kernel-server
```
## edit file
```
$ sudo vi /etc/idmapd.conf
# line 6: uncomment and change to your domain name
Domain = kmaster.example.com
```

## Edit exports
- sudo vi /etc/exports

```
#/data/nfsshare  *(rw,sync,no_root_squash,no_subtree_check)
#/home/nfsshare 192.168.10.0/24(rw,no_root_squash)
/data/nfsshare *(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)
```

## Create shared Dir.

```
$ mkdir -p /data/nfsshare
$ chown -R nobody /data/nfsshare
$ systemctl restart nfs-server
```

## On Worker Nodes install nfs clients or nfs-server and disable service nfs-server

########################################################################
##  HELM 3 Install and repo + kubernetes > 1.20+
######################################################################

```
$ helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/


$ helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=172.16.100.1 \
    --set nfs.path=/data/nfsshare
```

## On K9S Nodes just for testing
```
$ sudo  mount -t nfs 172.16.100.1:/data/nfsshare /mnt
```

## Deploy pod to test nfs storage for PersistentVolumeClaim
```
$ kubectl apply -f ./
$ kubectl get pv,pvc,pods -A
```

## Enter in nginx-web pod shell
```
$ cd /usr/share/nginx/html
    
$ echo "Hallo World" > index.html
$ cat index.html 
$ curl localhost
$ exit
```
## On K8S nodes we can find mounted volumeClaim data (code like index.html etc)
```
$ ls /mnt/awx-web-provisioner-pvc-89821e19-5a11-4a31-9ad5-49c873e5f8b2/
index.html
```

## to clean 
```
$ kubectl delete -f ./
```

# Blackbox Monitoring with Alerts On K8S  
Custom Setup Prometheus, Alertmanager & blackbox on Kubernetes  

# Adjust AWS Keys & SLAK-API-URL in files  

- vi prometheus/k8s-blackboxstack/kubernetes-prometheus/01-prometheus-configmap.yaml
```
- vi prometheus/k8s-blackboxstack/kubernetes-alert-manager/AlertManagerConfigmap.yaml

# Setup BlackBox On K8S 
- Follow the steps to setup blackbox monitoring stack  

# Prometheus with statefullset 

kubectl create ns blackbox
cd prometheus/k8s-blackboxstack/kubernetes-prometheus/
kubectl apply -f ./ -n blackbox

cd ../kubernetes-alert-manager/
kubectl apply -f ./ -n blackbox

cd ../kubernetes-blackbox/
kubectl apply -f ./ -n blackbox

cd ../kubernetes-grafana/
kubectl apply -f ./ -n blackbox

```

# Setup kube-exporter (kube-state-metrics)
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm install kube-exporter prometheus-community/kube-state-metrics  -n kube-system
```

# Accessing services on Web
```
# prometheus web ui
kubectl get pods -n blackbox |grep prometheus
kubectl port-forward prometheus-deployment-ID 9090:9090 -n blackbox

# grafana web ui
kubectl get pods -n blackbox |grep grafana
kubectl port-forward grafana-5f9587668c-l2wxf 3000:3000 -n blackbox
```
# Adding dashboards in grafana
- Copy IDs from grafana community site.

# Deploy for aws/kube & net tools for managing & troubleshotting 
```
kubectl create deploy nginx --image nginx:latest
kubectl get pods 
```

## Access management deployment pod and configure for troubleshoot etc
```
kubectl exec -it nginx-85b98978db-5f8fd -- bash
root@nginx-85b98978db-5f8fd:/# apt update && apt install -y telnet wget curl net-tools iputils-ping lsof
root@nginx-85b98978db-5f8fd:/# wget URL[kubectl|helm|fluxd|kustomize| etc]

root@nginx-85b98978db-5f8fd:/# telnet prometheus-service.blackbox.svc 8080
root@nginx-85b98978db-5f8fd:/# curl -X POST http://prometheus-service.blackbox.svc:8080/-/reload
```

# Updating prometheus.yml, rules.yml & alertmanager.yml etc
```  
# to update configurations apply required manifests

kubectl apply -f manifest-file.yaml -n blackbox
```

# reload configurations after update config files
```
# Note that as of Prometheus 2.0, the --web.enable-lifecycle command line flag must be passed for HTTP reloading to work.

kubectl get pods -n blackbox |grep prometheus
kubectl port-forward prometheus-monitoring-ID 9090:9090 -n blackbox

curl -X POST http://localhost:9090/-/reload
# OR just delete prometheus pod it will re create with updated configs

# for alertmanager

```

# Adding pushgateway & prometheus proxy
```  
# deployment

```

# Clean up whole setup.
```
cd prometheus/k8s-blackboxstack/kubernetes-prometheus/
kubectl delete -f ./ -n blackbox

cd ../kubernetes-alert-manager/
kubectl delete -f ./ -n blackbox

cd ../kubernetes-blackbox/
kubectl delete -f ./ -n blackbox

cd ../kubernetes-grafana/
kubectl delete -f ./ -n blackbox

helm uninstall kube-exporter -n kube-system

kubectl delete ns blackbox

```


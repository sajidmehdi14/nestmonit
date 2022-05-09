# nestmonit for Innowi Inc. Ltd.
Management, Administration, Monitoring, Measuring, Observability, Anomaly , Corelation , security scaning &amp; Alerting of AWS EC2 Instances, ECS, Kubernetes clusters, Apps & Kubernetes services.

# Administration, controllers & Monitoring Servers installed, configured & deployed.
- K8S Cluster (minikube) on EC2 Instance ( t2.large ) percona   
  OR 
```
 AWS EKS on separate vpc and node groups deplyed.
```

- On K8S Clusters Deploy -> AWX, Prometheus blackbox stack
- Ansible controller on Local system for development purposes.
- IaaC on github repo -> nestmonit

# Servers & Apps to be monitored
- AWS EC2 Instances
- Kubernetes Nodes
- EKS Nodes
- K8S Clusters with services/pods, microservices etc
- EKS Clusters with services/pods & microservices etc
- short lived jobs like AWS Lambda, AWS Jobs, jenkins jobs

# Monitoring Stacks to be deployed On Kubernetes
- Prometheus Stack with grafana ( To PULL metrics Pull Model like Nagios)
- Prometheus Proxies set up (To Push metrics to proxies For Nated clients)

- IinfluxDB-1.x & InfluxDB-2.x to clollect metrics Push model (Good for Nated clients)

- ELK/ FLuent to collect Logs of EC2 Instances, Kubernetes clusters & Apps

- Istio & zipkin for observability of microservices

# Reporting
- Alerting, Analytics, Capicity Planning, Security Loops, Trends, & AI based Alerts
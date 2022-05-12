# Pre-Reqs: Deployment Monitoring Stack

## Step 1: Install exporters / agents / clients on EC2 Instances / K8S nodes etc
- Install node_exporter on EC2 Nodes with Ansible 2.12+ playbook.

- Manintain a Dynamic Inventory For AWS EC2 Nodes
- Open Port 9100 For Prometheus EC2 / K8S Nodes dynamically As nodes may add remove periodically.

```
# Install ansible, awscli & python3-boto3 On Controller server
git clone https://github.com/sajidmehdi14/nestmonit
cd nestmonit/playbooks-node-exporter-ec2/
bash run-playbook.sh

```


## Step 2:
```
git clone https://github.com/sajidmehdi14/nestmonit
cd nestmonit/
```
Modify following file for AWS Keys
- vi prometheus/k8s-blackboxstack/kubernetes-prometheus/01-prometheus-configmap.yaml  

Modify following file for SLACK-API-URL
-  vi prometheus/k8s-blackboxstack/kubernetes-alert-manager/AlertManagerConfigmap.yaml

- Deloy Prometheus blackbox On K8S (minikube / EKS)
- Modify prometheus configs and update monitoring K8S manifests
- Provide GitOps CICD to update prometheus on Kubernetes using FLUX v2

```
# Follow: steps
git clone https://github.com/sajidmehdi14/nestmonit
cd nestmonit/prometheus/k8s-blackboxstack/
cat README-blackbox-k8s.md

```
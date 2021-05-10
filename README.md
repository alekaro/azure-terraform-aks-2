# azure-terraform-aks

## General informations

This project was created as a solution for exercise containing given scenario:

**Create manifests to launch simple static web-site environment on Azure Cloud:**

1. Create Azure Storage Account with private-only access
1. Copy local static web-site files to ASA
1. Create Azure Kubernetes Service Cluster (AKS Cluster) using default Linux image:
    * Every new pod should have installed Apache web server
    * Every pod should copy static website files from ASA to
    its Apache web server root directory (Use aadPodIdentity)
1. Set number of containers (pods) for auto-scaling: min=1, max=10
1. Add Gateway on top of AKS to have one point of entry

---

## Solution

### (root-module)
> Root module glues every other module together and is responsible for other operations (like Role assignments)

### aks-cluster
> Azure Kubernetes Service Cluster module.

### application-gateway
> Application Gateway module.


---
## Launch instruction
---
0. Preparation (if service principal is being created through azure portal):
* Home -> Azure Active Directory -> App registrations -> New registration -> insert name and create
* Certificates & secrets -> New client secret -> Add
* **Application (client) ID** = aks-cluster: client_id
  
  Newly created secret value = aks-cluster: client_secret

  Needed to role assignments service principal object ID =

  ```az ad sp show --id <app_id>```
  
  executed in `AzureCLI`

  (**Object ID** under **Application (client) ID** in **App registrations** bookmark is wrong value)
---
1. in root module
```
    terraform apply
```
2. Open `AzureCLI` on Azure Portal and connect to newly created AKS Cluster

![Image not found](./readme-res/aks-connect.png "Connecting to AKS Cluster")

3. In that same `AzureCLI` insert lines below to enable the AGIC add-on on existing AKS Cluster and Application Gateway (after establishing connection with aks cluster)

```
appgwId=$(az network application-gateway show -n cluster-gw -g cluster-rg -o tsv --query "id") 
az aks enable-addons -n cluster-aks -g cluster-rg -a ingress-appgw --appgw-id $appgwId
```

4. install AAD Pod Identity on a cluster through Helm
```
helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts
helm install aad-pod-identity aad-pod-identity/aad-pod-identity
```

5. Configure AzureIdentity<sup>[1]</sup> and AzureIdentityBinding<sup>[2]</sup> through commandline or use automaticly made files via `config.tf` file
  * copy content form `azureidentity_deploy.yml` file into your AzureCLI, the same goes with `azureidentitybinding_deploy.yml`
  * in AzureCLI execute:
  ```
  kubectl apply -f azureidentity_deploy.yml
  kubectl apply -f azureidentitybinding_deploy.yml
  ```

6. Create docker image and push it to Azure Container Registry

  * in your terminal (not AzureCLI because *This command requires running the docker daemon, which is not supported in Azure Cloud Shell...*) execute:
  ```
  ACR=<YOUR_ACR>
  IMG=$ACR.azurecr.io/azure-storage-example:1

  az acr login --name $ACR

  docker build -t $IMG .
  docker push $IMG
  ```
  or just execute generated script
  ```
  /bin/bash image_deploy.sh
  ```

7. Don't forget to upload `index.html` file to ASA, it can using below scrip aswell:
```
/bin/bash push_to_storage.sh
```


8. Copy deployment YAML file and deploy sample application in the AKS Cluster
```
kubectl apply -f autoscaler_deployment.yml
```


useful links:

* https://docs.microsoft.com/en-us/azure/application-gateway/tutorial-ingress-controller-add-on-existing#enable-the-agic-add-on-in-existing-aks-cluster-through-azure-cli
* https://docs.microsoft.com/en-us/azure/application-gateway/ingress-controller-autoscale-pods
* https://registry.terraform.io/modules/claranet/aks/azurerm/latest/submodules/agic
* https://github.com/Azure/aad-pod-identity
* https://github.com/cloudcommons/terraform-kubernetes-aad-pod-identity-rbac
* https://github.com/Azure/terraform-azurerm-appgw-ingress-k8s-cluster
* https://azure.github.io/aad-pod-identity/docs/demo/java-blob/ (Don't use it too much)

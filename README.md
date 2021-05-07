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

7. Deploy sample application in the AKS Cluster
```
kubectl apply -f https://raw.githubusercontent.com/Azure/application-gateway-kubernetes-ingress/master/docs/examples/aspnetapp.yaml
```


useful links:

* https://docs.microsoft.com/en-us/azure/application-gateway/tutorial-ingress-controller-add-on-existing#enable-the-agic-add-on-in-existing-aks-cluster-through-azure-cli
* https://docs.microsoft.com/en-us/azure/application-gateway/ingress-controller-autoscale-pods
* https://registry.terraform.io/modules/claranet/aks/azurerm/latest/submodules/agic
* https://github.com/Azure/aad-pod-identity
* https://github.com/cloudcommons/terraform-kubernetes-aad-pod-identity-rbac
* https://github.com/Azure/terraform-azurerm-appgw-ingress-k8s-cluster
* https://azure.github.io/aad-pod-identity/docs/demo/java-blob/ (Don't use it too much)


<h2 style="color: yellow">TODO:</h2>

1. Try to install AGIC ingress controller other way than through add-on in AzureCLI - https://github.com/claranet/terraform-azurerm-aks/tree/v4.1.0/modules/tools/agic
2. aad-pod-identity is for pods to reach out for ASA container content - https://github.com/Azure/aad-pod-identity
3. Add `kubernetes_horizontal_pod_autoscaler` and scale AKS cluster using Application Gateway Metrics - https://docs.microsoft.com/en-us/azure/application-gateway/ingress-controller-autoscale-pods
4. test that once again - https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-aks-applicationgateway-ingress
5. Go along this tutorial but on your own https://azure.github.io/aad-pod-identity/docs/demo/java-blob/ (install aad-pod-id through helm e.g. https://github.com/Azure/aad-pod-identity)
6. Manage kubernetes through commandline (normally you would do it through gitlab pipeline but for now CLI) = delete kubernetes.tf
7. hardware - terraform (cloud), middleware - gitlab pipeline
8. Set user assigned managed identity for AKS cluster and make it somehow to be in special resource group dedicated for AKS


<!-- ```
helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts
helm install aad-pod-identity aad-pod-identity/aad-pod-identity
```

```
helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/
helm repo update
```

```
wget https://raw.githubusercontent.com/Azure/application-gateway-kubernetes-ingress/master/docs/examples/sample-helm-config.yaml -O helm-config.yaml

nano helm-config.yaml
```

```
helm install ingress-azure \
  -f helm-config.yaml \
  application-gateway-kubernetes-ingress/ingress-azure \
  --version 1.3.0
``` -->
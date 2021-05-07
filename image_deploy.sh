ACR=storage45790acr
IMG=$ACR.azurecr.io/azure-storage-example:1
az acr login --name $ACR
docker build -t $IMG .
docker push $IMG

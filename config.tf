resource "null_resource" "post-config" {

    depends_on  = [module.aks]

    provisioner "local-exec" {
        command = <<EOT
echo 'apiVersion: "aadpodidentity.k8s.io/v1"'   > ${var.azure_identity_file_name}.yml
echo 'kind: AzureIdentity'                      >> ${var.azure_identity_file_name}.yml
echo 'metadata:'                                >> ${var.azure_identity_file_name}.yml
echo '  name: ${var.azure_identity_name}'       >> ${var.azure_identity_file_name}.yml
echo 'spec:'                                    >> ${var.azure_identity_file_name}.yml
echo '  type: 0'                                >> ${var.azure_identity_file_name}.yml
echo '  resourceID: "${module.aks.kubelet_identity_user_assigned_identity_id}"'      >> ${var.azure_identity_file_name}.yml
echo '  clientID: "${module.aks.kubelet_identity_client_id}"'  >> ${var.azure_identity_file_name}.yml

echo 'apiVersion: "aadpodidentity.k8s.io/v1"'           > ${var.azure_identity_binding_file_name}.yml
echo 'kind: AzureIdentityBinding'                       >> ${var.azure_identity_binding_file_name}.yml
echo 'metadata:'                                        >> ${var.azure_identity_binding_file_name}.yml
echo '  name: ${var.azure_identity_binding_name}'       >> ${var.azure_identity_binding_file_name}.yml
echo 'spec:'                                            >> ${var.azure_identity_binding_file_name}.yml
echo '  azureIdentity: ${var.azure_identity_name}'    >> ${var.azure_identity_binding_file_name}.yml
echo '  selector: ${var.selector}'                    >> ${var.azure_identity_binding_file_name}.yml

echo 'ACR=${module.asa.container_registry_name}'        > ${var.image_deploy_script_name}.sh
echo 'IMG=$ACR.azurecr.io/azure-storage-example:1'       >> ${var.image_deploy_script_name}.sh
echo 'az acr login --name $ACR'                         >> ${var.image_deploy_script_name}.sh
echo 'docker build -t $IMG .'                           >> ${var.image_deploy_script_name}.sh
echo 'docker push $IMG'                                 >> ${var.image_deploy_script_name}.sh

echo 'azcopy login --identity'        > ${var.init_script_name}.sh
echo 'azcopy copy "https://${module.asa.storage_account_name}.blob.core.windows.net/${module.asa.storage_container_name}/index.html" "/usr/share/nginx/html/index.html"'        >> ${var.init_script_name}.sh
echo '# TOKEN=$(curl -s 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fstorage.azure.com%2F' -H Metadata:true | python3 -c "import sys, json; print(json.load(sys.stdin)['access_token'])")'        >> ${var.init_script_name}.sh
echo '# curl "https://${module.asa.storage_account_name}.blob.core.windows.net/${module.asa.storage_container_name}/index.html" -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $${TOKEN}" > /var/www/html/index.html'        >> ${var.init_script_name}.sh

echo 'azcopy "./index.html" "https://${module.asa.storage_account_name}.blob.core.windows.net/${module.asa.storage_container_name}/"'        > ${var.storage_content_push_script_name}.sh

echo 'apiVersion: apps/v1'                  > ${var.deployment_file_name}.yml
echo 'kind: Deployment'                     >> ${var.deployment_file_name}.yml
echo 'metadata:'                            >> ${var.deployment_file_name}.yml
echo '  name: dep-example'                  >> ${var.deployment_file_name}.yml
echo '  labels:'                            >> ${var.deployment_file_name}.yml
echo '    app: example-app'                 >> ${var.deployment_file_name}.yml
echo 'spec:'                                >> ${var.deployment_file_name}.yml
echo '  replicas: 1'                        >> ${var.deployment_file_name}.yml
echo '  selector:'                          >> ${var.deployment_file_name}.yml
echo '    matchLabels:'                     >> ${var.deployment_file_name}.yml
echo '      app: example-app'               >> ${var.deployment_file_name}.yml
echo '  template:'                          >> ${var.deployment_file_name}.yml
echo '    metadata:'                        >> ${var.deployment_file_name}.yml
echo '      labels:'                        >> ${var.deployment_file_name}.yml
echo '        app: example-app'             >> ${var.deployment_file_name}.yml
echo '        aadpodidbinding: ${var.selector}'        >> ${var.deployment_file_name}.yml
echo '    spec:'                            >> ${var.deployment_file_name}.yml
echo '      containers:'                    >> ${var.deployment_file_name}.yml
echo '      - name: example-container'      >> ${var.deployment_file_name}.yml
echo '        image: ${module.asa.container_registry_name}.azurecr.io/azure-storage-example:1'        >> ${var.deployment_file_name}.yml
echo '        env:'                         >> ${var.deployment_file_name}.yml
echo '        ports: '                      >> ${var.deployment_file_name}.yml
echo '        - containerPort: 80'          >> ${var.deployment_file_name}.yml
echo ''                                     >> ${var.deployment_file_name}.yml
echo '---'                                  >> ${var.deployment_file_name}.yml
echo ''                                     >> ${var.deployment_file_name}.yml
echo 'apiVersion: v1'                       >> ${var.deployment_file_name}.yml
echo 'kind: Service'                        >> ${var.deployment_file_name}.yml
echo 'metadata:'                            >> ${var.deployment_file_name}.yml
echo '  name: ser-example'                  >> ${var.deployment_file_name}.yml
echo 'spec:'                                >> ${var.deployment_file_name}.yml
echo '  selector:'                          >> ${var.deployment_file_name}.yml
echo '    app: example-app'                 >> ${var.deployment_file_name}.yml
echo '  ports:'                             >> ${var.deployment_file_name}.yml
echo '  - protocol: TCP'                    >> ${var.deployment_file_name}.yml
echo '    port: 80'                         >> ${var.deployment_file_name}.yml
echo '    targetPort: 80'                   >> ${var.deployment_file_name}.yml
echo ''                                     >> ${var.deployment_file_name}.yml
echo '---'                                  >> ${var.deployment_file_name}.yml
echo ''                                     >> ${var.deployment_file_name}.yml
echo 'apiVersion: extensions/v1beta1'       >> ${var.deployment_file_name}.yml
echo 'kind: Ingress'                        >> ${var.deployment_file_name}.yml
echo 'metadata:'                            >> ${var.deployment_file_name}.yml
echo '  name: ingr-example'                 >> ${var.deployment_file_name}.yml
echo '  annotations:'                       >> ${var.deployment_file_name}.yml
echo '    kubernetes.io/ingress.class: azure/application-gateway'      >> ${var.deployment_file_name}.yml
echo 'spec:'                                >> ${var.deployment_file_name}.yml
echo '  rules:'                             >> ${var.deployment_file_name}.yml
echo '  - http:'                            >> ${var.deployment_file_name}.yml
echo '      paths:'                         >> ${var.deployment_file_name}.yml
echo '      - path: /'                      >> ${var.deployment_file_name}.yml
echo '        backend:'                     >> ${var.deployment_file_name}.yml
echo '          serviceName: ser-example'   >> ${var.deployment_file_name}.yml
echo '          servicePort: 80'            >> ${var.deployment_file_name}.yml
EOT
  }
}
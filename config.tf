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
echo '  resourceID: "${module.aks.user_assigned_identity_id}"'      >> ${var.azure_identity_file_name}.yml
echo '  clientID: "${module.aks.user_assigned_identity_client_id}"'  >> ${var.azure_identity_file_name}.yml

echo 'apiVersion: "aadpodidentity.k8s.io/v1"'           > ${var.azure_identity_binding_file_name}.yml
echo 'kind: AzureIdentityBinding'                       >> ${var.azure_identity_binding_file_name}.yml
echo 'metadata:'                                        >> ${var.azure_identity_binding_file_name}.yml
echo '  name: ${var.azure_identity_binding_name}'       >> ${var.azure_identity_binding_file_name}.yml
echo 'spec:'                                            >> ${var.azure_identity_binding_file_name}.yml
echo '  azureIdentity: "${var.azure_identity_name}"'    >> ${var.azure_identity_binding_file_name}.yml
echo '  selector: "${var.selector}"'                    >> ${var.azure_identity_binding_file_name}.yml

echo 'ACR=${module.asa.container_registry_name}'        > ${var.image_deploy_script_name}.sh
echo 'IMG=$ACR.azurecr.io/azure-storage-example:1'       >> ${var.image_deploy_script_name}.sh
echo 'az acr login --name $ACR'                         >> ${var.image_deploy_script_name}.sh
echo 'docker build -t $IMG .'                           >> ${var.image_deploy_script_name}.sh
echo 'docker push $IMG'                                 >> ${var.image_deploy_script_name}.sh
EOT
  }
}
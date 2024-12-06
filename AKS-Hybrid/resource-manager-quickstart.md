---
title: Deploy a Kubernetes (AKS) cluster using an Azure Resource Manager template
description: Learn how to deploy a Kubernetes cluster in AKS enabled by Azure Arc using an Azure Resource Manager template.
ms.topic: quickstart-arm
ms.custom: devx-track-arm-template, devx-track-azurecli
ms.date: 12/06/2024
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 01/31/2024
ms.reviewer: rbaziwane
---

# Quickstart: deploy a Kubernetes cluster using an Azure Resource Manager template

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This quickstart shows how to deploy a Kubernetes cluster in AKS Arc using an Azure Resource Manager template. Azure Arc extends Azure management capabilities to Kubernetes clusters anywhere, providing a unified approach to managing different environments.

## Before you begin

This article assumes a basic understanding of Kubernetes concepts.

To deploy a Resource Manager template, you need write access on the resources you're deploying, and access to all operations on the **Microsoft.Resources/deployments** resource type. For example, to deploy a virtual machine, you need **Microsoft.Compute/virtualMachines/write** and **Microsoft.Resources/deployments/\*** permissions. For a list of roles and permissions, see [Azure built-in roles](/azure/role-based-access-control/built-in-roles).

### Prerequisites

- An Azure account with an active subscription.
- An Azure Local, version 23H2 cluster.
- The latest Azure CLI version.

## Step 1: Prepare your Azure account

1. Sign in to Azure: open your terminal or command prompt and sign in to your Azure account using the Azure CLI:

   ```azurecli
   az login
   ```

1. Set your subscription: replace `<your-subscription-id>` with your subscription ID:

   ```azurecli
   az account set --subscription "<your-subscription-id>"
   ```

## Step 2: Create an SSH key pair using Azure CLI

```azurecli
az sshkey create --name "mySSHKey" --resource-group "myResourceGroup"
```

or, create an SSH key pair using **ssh-keygen**:

```cmd
ssh-keygen -t rsa -b 4096
```

To deploy the template, you must provide the public key from the SSH pair. To retrieve the public key, use the `az sshkey show` command:

```azurecli
az sshkey show --name "mySSHKey" --resource-group "myResourceGroup" --query "publicKey"
```

By default, the SSH key files are created in the **~/.ssh** directory. Run the `az sshkey create` or `ssh-keygen` command to overwrite any existing SSH key pair with the same name.

For more information about creating SSH keys, see [Create and manage SSH keys for authentication in Azure](/azure/virtual-machines/linux/create-ssh-keys-detailed).

## Step 3: Review the template

Create one file on your local machine named **azuredeploy.json** and another one named **parameters.json**. Make sure all the default values and input parameters are correct:

### azuredeploy.json

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
      "provisionedClusterName": {
          "type": "string",
          "defaultValue": "aksarc-armcluster",
          "metadata": {
              "description": "The name of the AKS Arc cluster resource."
          }
      },
      "location": {
          "type": "string",
          "defaultValue": "eastus",
          "metadata": {
              "description": "The location of the AKS Arc cluster resource."
          }
      },
      "resourceTags": {
            "type": "object",
            "defaultValue": {}
        },
        "connectedClustersApiVersion": {
            "type": "String",
            "defaultValue": ""
        },
        "provisionedClustersApiVersion": {
            "type": "String",
            "defaultValue": ""
        },

      "sshRSAPublicKey": {
          "type": "string",
          "metadata": {
              "description": "Configure all linux machines with the SSH RSA public key string. Your key should include three parts, for example 'ssh-rsa AAAAB...snip...UcyupgH '"
          }
      },
       "enableAHUB": {
            "type": "string",
            "defaultValue": "NotApplicable",
            "metadata": {
                "description": "Azure Hybrid Benefit for Windows Server licenses. NotApplicable, True, False."
            }
        },
       "agentName": {
              "type": "string",
              "defaultValue": "nodepool",
              "metadata": {
                  "description": "The name of the node pool."
              }
          },
        "agentVMSize": {
            "type": "string",
            "defaultValue": "Standard_A4_v2",
            "metadata": {
                  "description": "The VM size for node pool."
            }
        },
        "agentCount": {
              "type": "int",
              "defaultValue": 1,
              "minValue": 1,
              "maxValue": 50,
              "metadata": {
                  "description": "The size of the node pool"
              }
          },
          "agentOsType": {
              "type": "string",
              "defaultValue": "Linux",
              "metadata": {
                  "description": "The OS Type for the node pool. The values can be Linux or Windows."
              }
          },
         "loadBalancerCount": {
            "type": "int",
            "defaultValue": 0,
            "metadata": {
                "description": "The number of load balancers."
            }
        },
          "kubernetesVersion": {
              "type": "string",
              "metadata": {
                  "description": "The version of Kubernetes."
              }
          },
          "controlPlaneNodeCount": {
              "type": "int",
              "defaultValue": 1,
              "minValue": 1,
              "maxValue": 5,
              "metadata": {
                  "description": "The number of control plane nodes."
              }
          },
          "controlPlaneIp": {
            "type": "string",
            "defaultValue": "<default_value>",
              "metadata": {
                  "description": "Control plane IP address. This parameter is optional."
              }
         },
          "controlPlaneVMSize": {
              "type": "string",
              "defaultValue": "Standard_A4_v2",
              "metadata": {
                  "description": "The VM size for control plane nodes."
              }
          },
          "vnetSubnetIds": {
              "type": "array",
              "metadata": {
                  "description": "List of subnet IDs for the AKS cluster."
              }
          },
          "podCidr": {
            "type": "string",
            "defaultValue": "10.244.0.0/16",
            "metadata": {
                  "description": "The CIDR notation IP ranges from which to assign pod IPs."
              }
          },
          "networkPolicy": {
            "type": "string",
            "defaultValue": "calico",
            "metadata": {
                  "description": "Network policy to use for Kubernetes pods. Calico is the only supported option."
              }
          },
          "customLocation": {
            "type": "string",
            "metadata": {
                  "description": "The Azure Resource Manager ID of the custom location in the target Azure Local cluster."
              }
          }
      },
      "resources": [
      {
          "apiVersion": "[parameters('connectedClustersApiVersion')]",
          "type": "Microsoft.Kubernetes/ConnectedClusters",
          "kind": "ProvisionedCluster",
          "location": "[parameters('location')]",
          "name": "[parameters('provisionedClusterName')]",
          "tags": "[parameters('resourceTags')]",
          "identity": {
              "type": "SystemAssigned"
          },
          "properties": {
              "agentPublicKeyCertificate":"" ,
              "aadProfile": {
                  "enableAzureRBAC": false
              },
              "securityProfile": {
                   "workloadIdentity": {
                        "enabled": true
                    }
              },
              "oidcIssuerProfile" : {
                "enabled" : true
              }
          }
      },
      {
          "apiVersion": "[parameters('provisionedClustersApiVersion')]",
          "type": "microsoft.hybridcontainerservice/provisionedclusterinstances",
          "name": "default",
          "scope": "[concat('Microsoft.Kubernetes/ConnectedClusters', '/', parameters('provisionedClusterName'))]",
          "dependsOn": [
              "[resourceId('Microsoft.Kubernetes/ConnectedClusters', parameters('provisionedClusterName'))]"
          ],
          "properties": {
          "agentPoolProfiles": [
            {
              "count": "[parameters('agentCount')]",
              "name":"[parameters('agentName')]",
              "osType": "[parameters('agentOsType')]",
              "vmSize": "[parameters('agentVMSize')]"
            }
          ],
          "cloudProviderProfile": {
            "infraNetworkProfile": {
                  "vnetSubnetIds": "[parameters('vnetSubnetIds')]"
            }
          },
          "controlPlane": {
            "count": "[parameters('controlPlaneNodeCount')]",
            "controlPlaneEndpoint": {
                        "hostIP": "[parameters('controlPlaneIp')]"
                    },
            "vmSize": "[parameters('controlPlaneVMSize')]"
          },
         "licenseProfile": {
            "azureHybridBenefit": "[parameters('enableAHUB')]"
         },
          "kubernetesVersion": "[parameters('kubernetesVersion')]",
          "linuxProfile": {
            "ssh": {
              "publicKeys": [
                {
                  "keyData": "[parameters('sshRSAPublicKey')]"
                }
              ]
            }
          },
        "networkProfile": {
          "loadBalancerProfile": {
            "count": "[parameters('loadBalancerCount')]"
          },
          "networkPolicy": "[parameters('networkPolicy')]",
          "podCidr": "[parameters('podCidr')]"
        },
        "storageProfile": {
          "nfsCsiDriver": {
            "enabled": true
          },
          "smbCsiDriver": {
            "enabled": true
          }
        }
        },
         "extendedLocation": {
             "name": "[parameters('customLocation')]",
             "type": "CustomLocation"
        }
      }
    ]
  }
```

### parameters.json

```json
{
   "$schema":"https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
   "contentVersion":"1.0.0.0",
   "parameters":{
      "provisionedClusterName":{
         "value":"AKSArc_Cluster_Name"
      },
      "location":{
         "value":"eastus"
      },
      "sshRSAPublicKey":{
         "value":"Your_SSH_RSA_Public_Key"
      },
      "provisionedClustersApiVersion":{
         "value":"2024-01-01"
      },
      "connectedClustersApiVersion":{
         "value":"2024-07-15-preview"
      },
      "vnetSubnetIds":{
         "value":[
            "VNET_Subnet_ARM_ID"
         ]
      },
      "customLocation":{
         "value":"Custom_Location_ARM_ID"
      }
   }
}
```

## Step 4: Deploy the template

To deploy the Kubernetes cluster, run the following command:

```azurecli
az deployment group create \
--name "<deployment-name>" \
--resource-group "<resource-group-name>" \
--template-file "azuredeploy.json" \
--parameters "parameters.json"
```

It takes a few minutes to create the cluster. Wait for the cluster to be successfully deployed before you move on to the next step.

## Step 5: Verify the deployment

Once the deployment is complete, use the following command to verify that your Kubernetes cluster is up and running:

```azurecli
az aksarc show --resource-group "<resource-group-name>" --name "<cluster-name>" --output table
```

## Step 6: Connect to the cluster

1. To connect to the cluster, run the `az connectedk8s proxy` command. The command downloads and runs a proxy binary on the client machine, and fetches a **kubeconfig** file associated with the cluster:

   ```azurecli
   az connectedk8s proxy --name <cluster name> -g <resource group>
   ```

   Or, use the Kubernetes command-line client, **kubectl**. If you use Azure Cloud Shell, **kubectl** is already installed. To install and run **kubectl** locally, run the `az aksarc install-cli` command.

   Configure **kubectl** to connect to your Kubernetes cluster using the `az aksarc get-credentials` command. This command downloads credentials and configures the Kubernetes CLI to use them:

   ```azurecli
   az aksarc get-credentials --resource-group "<resource-group-name>" --name "<cluster-name>"
   ```

1. Verify the connection to your cluster using the `kubectl get` command. This command returns a list of the cluster nodes:

   ```cmd
   kubectl get nodes -A --kubeconfig .\<path to kubecofig> 
   ```

   The following example output shows the three nodes created in the previous steps. Make sure the node status is **Ready**:

   ```output
   NAME                                STATUS   ROLES   AGE   VERSION
   aks-agentpool-27442051-vmss000000   Ready    agent   10m   v1.27.7
   aks-agentpool-27442051-vmss000001   Ready    agent   10m   v1.27.7
   aks-agentpool-27442051-vmss000002   Ready    agent   11m   v1.27.7
   ```

## Step 7: Deploy node pool using an Azure Resource Manager template (optional)

You can also deploy the node pool resource using an Azure Resource Manager template. Save the following template locally as **azuredeploy.json**:

```json
{
   "$schema":"https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
   "contentVersion":"1.0.0.0",
   "parameters":{
      "provisionedClusterName":{
         "type":"string"
      },
      "agentName":{
         "type":"string"
      },
      "agentVMSize":{
         "type":"string"
      },
      "agentCount":{
         "type":"int"
      },
      "agentOsType":{
         "type":"string"
      },
      "location":{
         "type":"string"
      }
   },
   "resources":[
      {
         "type":"Microsoft.Kubernetes/connectedClusters",
         "apiVersion":"2024-01-01",
         "name":"[parameters('provisionedClusterName')]",
         "location":"[parameters('location')]",
         "condition":false
      },
      {
         "type":"Microsoft.HybridContainerService/provisionedClusterInstances/agentPools",
         "apiVersion":"2024-01-01",
         "name":"[concat('default/', parameters('agentName'))]",
         "dependsOn":[
            "[resourceId('Microsoft.Kubernetes/connectedClusters', parameters('provisionedClusterName'))]"
         ],
         "properties":{
            "count":"[parameters('agentCount')]",
            "osType":"[parameters('agentOsType')]",
            "vmSize":"[parameters('agentVMSize')]"
         }
      }
   ]
}
```

### Deploy the template and validate results using Azure CLI (optional)

Review and apply the template. This process takes a few minutes to complete. You can use the Azure CLI to validate that the node pool is created successfully:

```azurecli
az deployment group create \
--name "<deployment-name>" \
--resource-group "<resource-group-name>" \
--template-file "azuredeploy.json" \
--parameters provisionedClusterName=<cluster-name> agentName=<nodepool-name> agentVMSize=Standard_A4_v2 agentCount=3 agentOsType=Linux location=eastus
```

```azurecli
az aksarc nodepool show --cluster-name "<cluster-name>" --resource-group "<resource-group-name>" --name "<nodepool-name>"
```

## Template resources

### connectedClusters

| Name             | Description                                         | Value                                                        |
| :--------------- | :-------------------------------------------------- | :----------------------------------------------------------- |
| `type`             | The resource type.                                   | **Microsoft.Kubernetes/ConnectedClusters**                 |
| `apiVersion`       | The resource API version.                            | **2024-01-01**                                                 |
| `name`             | The resource name.                                   | String (required)<br> Character limit: 1-63 <br> Valid characters: Alphanumerics, underscores, and hyphens. <br> Start and end with alphanumeric. |
| `location`         | The geo-location in which the resource lives.           | String (required).                                            |
| `tags`             | Resource tags.                                      | Dictionary of tag names and values. See [Tags in templates](/azure/azure-resource-manager/management/tag-resources-templates). |
| `extendedLocation` | The extended location of the virtual machine.       | [ExtendedLocation](/azure/templates/microsoft.containerservice/managedclusters?pivots=deployment-language-arm-template#extendedlocation-1) |
| `identity`         | The identity of the connected cluster, if configured. |  |
| `properties`       | Properties of a connected cluster.                    |  |

### ProvisionedClusterInstances

| Name             | Description                                         | Value                                                        |
| :--------------- | :-------------------------------------------------- | :----------------------------------------------------------- |
| `type`             | The resource type                                   | **microsoft.hybridcontainerservice/provisionedclusterinstances**                 |
| `apiVersion`       | The resource API version                            | **2024-01-01**                                                 |
| `name`             | The resource name                                   | String (required). Don't change this from **default**. |
| `properties`       | Properties of a connected cluster.                    |  |
| `extendedLocation` | The extended location of the cluster.       | [ExtendedLocation](/azure/templates/microsoft.containerservice/managedclusters?pivots=deployment-language-arm-template#extendedlocation-1) |

### ExtendedLocation

| Name | Description                        | Value      |
| :--- | :--------------------------------- | :--------- |
| `name` | The ID of the extended location. | string     |
| `type` | The type of the extended location. | **CustomLocation** |

## Next steps

[AKS Arc overview](overview.md)

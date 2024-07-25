---
title: Enable Insights for Azure Stack HCI at scale using Azure policies
description: How to use Insights to monitor the health, performance, and usage of multiple Azure Stack HCI clusters.
author: sethmanheim
ms.author: sethm
ms.reviewer: saniyaislam
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 01/31/2024
---

# Enable Insights for Azure Stack HCI clusters at scale using Azure policies

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This document describes how to enable Insights for Azure Stack HCI at scale using Azure policies. To enable Insights for a single Azure Stack HCI cluster, see [Monitor Azure Stack HCI with Insights](./monitor-hci-single.md).

## About Azure policies to enable Insights at scale

In order to monitor Azure Stack HCI systems at scale with Insights, you need to enable Insights for each cluster. To simplify the process, you can use Azure policies to automatically enable Insights at scale at the subscription or resource group level. This section describes the sample policies and provide the policy definition that you can use to create policies for your scenarios.

### Policy to repair AMA

For Azure Stack HCI clusters registered before Nov 2023, you need to repair cluster registration and Azure Monitor Agent (AMA) before configuring Insights again. For details, see [Troubleshoot clusters registered before November 2023](#troubleshoot-clusters-registered-before-november-2023).

To repair the cluster, uninstall AMA and then apply the repair Azure policy.

The repair policy removes the registry key, if present, which determines the resource ID for which AMA collects data.

Keep in mind the following things before applying this policy:

- This policy is applicable only to Azure Stack HCI, version 22H2 clusters. Apply it before any other policies to ensure AMA picks up the correct resource ID.
- Uninstall AMA before applying this policy to set the correct resource ID. If AMA isn't uninstalled first, data might not appear.

<details>
  <summary>Expand to view the repair policy code in JSON.</summary>

```json
{
  "mode": "INDEXED",
  "policyRule": {
   "then": { 
        "effect": "deployIfNotExists", 
        "details": { 
          "type": "Microsoft.GuestConfiguration/guestConfigurationAssignments", 
          "existenceCondition": { 
            "allOf": [ 
              { 
                "field": "Microsoft.GuestConfiguration/guestConfigurationAssignments/complianceStatus", 
                "equals": "Compliant" 
              }, 
              { 
                "field": "Microsoft.GuestConfiguration/guestConfigurationAssignments/parameterHash", 
                "equals": "[base64(concat('[RepairClusterAMA]RepairClusterAMAInstanceName;Path', '=', parameters('Path'), ',', '[RepairClusterAMA]RepairClusterAMAInstanceName;Content', '=', parameters('Content')))]" 
              } 
            ] 
          }, 
          "roleDefinitionIds": [ 
            "/providers/Microsoft.Authorization/roleDefinitions/088ab73d-1256-47ae-bea9-9de8e7131f31" 
          ], 
          "deployment": { 
            "properties": { 
              "parameters": { 
                "type": { 
                  "value": "[field('type')]" 
                }, 
                "location": { 
                  "value": "[field('location')]" 
                }, 
                "vmName": { 
                  "value": "[field('name')]" 
                }, 
                "assignmentName": { 
                  "value": "[concat('RepairClusterAMA$pid', uniqueString(policy().assignmentId, policy().definitionReferenceId))]" 
                }, 
                "Content": { 
                  "value": "[parameters('Content')]" 
                }, 
                "Path": { 
                  "value": "[parameters('Path')]" 
                } 
              }, 
              "mode": "incremental", 
              "template": { 
                "parameters": { 
                  "type": { 
                    "type": "string" 
                  }, 
                  "location": { 
                    "type": "string" 
                  }, 
                  "vmName": { 
                    "type": "string" 
                  }, 
                  "assignmentName": { 
                    "type": "string" 
                  }, 
                  "Content": { 
                    "type": "string" 
                  }, 
                  "Path": { 
                    "type": "string" 
                  } 
                }, 
                "contentVersion": "1.0.0.0", 
                "resources": [ 
                  { 
                    "type": "Microsoft.Compute/virtualMachines/providers/guestConfigurationAssignments", 
                    "properties": { 
                      "guestConfiguration": { 
                        "version": "1.0.0", 
                        "name": "RepairClusterAMA", 
                        "configurationParameter": [ 
                          { 
                            "value": "[parameters('Path')]", 
                            "name": "[RepairClusterAMA]RepairClusterAMAInstanceName;Path" 
                          }, 
                          { 
                            "value": "[parameters('Content')]", 
                            "name": "[RepairClusterAMA]RepairClusterAMAInstanceName;Content" 
                          } 
                        ], 
                        "contentHash": "7EA99B10AE79EA5C1456A134441270BC48F5208F3521BFBFDCAE5EF7B6A9D9BD", 
                        "contentUri": "https://guestconfiguration4.blob.core.windows.net/guestconfiguration/RepairClusterAMA.zip", 
                        "contentType": "Custom", 
                        "assignmentType": "ApplyAndAutoCorrect" 
                      } 
                    }, 
                    "location": "[parameters('location')]", 
                    "apiVersion": "2018-11-20", 
                    "name": "[concat(parameters('vmName'), '/Microsoft.GuestConfiguration/', parameters('assignmentName'))]", 
                    "condition": "[equals(toLower(parameters('type')), toLower('Microsoft.Compute/virtualMachines'))]" 
                  }, 
                  { 
                    "type": "Microsoft.HybridCompute/machines/providers/guestConfigurationAssignments", 
                    "properties": { 
                      "guestConfiguration": { 
                        "version": "1.0.0", 
                        "name": "RepairClusterAMA", 
                        "configurationParameter": [ 
                          { 
                            "value": "[parameters('Path')]", 
                            "name": "[RepairClusterAMA]RepairClusterAMAInstanceName;Path" 
                          }, 
                          { 
                            "value": "[parameters('Content')]", 
                            "name": "[RepairClusterAMA]RepairClusterAMAInstanceName;Content" 
                          } 
                        ], 
                        "contentHash": "7EA99B10AE79EA5C1456A134441270BC48F5208F3521BFBFDCAE5EF7B6A9D9BD", 
                        "contentUri": "https://guestconfiguration4.blob.core.windows.net/guestconfiguration/RepairClusterAMA.zip", 
                        "contentType": "Custom", 
                        "assignmentType": "ApplyAndAutoCorrect" 
                      } 
                    }, 
                    "location": "[parameters('location')]", 
                    "apiVersion": "2018-11-20", 
                    "name": "[concat(parameters('vmName'), '/Microsoft.GuestConfiguration/', parameters('assignmentName'))]", 
                    "condition": "[equals(toLower(parameters('type')), toLower('Microsoft.HybridCompute/machines'))]" 
                  }, 
                  { 
                    "type": "Microsoft.Compute/virtualMachineScaleSets/providers/guestConfigurationAssignments", 
                    "properties": { 
                      "guestConfiguration": { 
                        "version": "1.0.0", 
                        "name": "RepairClusterAMA", 
                        "configurationParameter": [ 
                          { 
                            "value": "[parameters('Path')]", 
                            "name": "[RepairClusterAMA]RepairClusterAMAInstanceName;Path" 
                          }, 
                          { 
                            "value": "[parameters('Content')]", 
                            "name": "[RepairClusterAMA]RepairClusterAMAInstanceName;Content" 
                          } 
                        ], 
                        "contentHash": "7EA99B10AE79EA5C1456A134441270BC48F5208F3521BFBFDCAE5EF7B6A9D9BD", 
                        "contentUri": "https://guestconfiguration4.blob.core.windows.net/guestconfiguration/RepairClusterAMA.zip", 
                        "contentType": "Custom", 
                        "assignmentType": "ApplyAndAutoCorrect" 
                      } 
                    }, 
                    "location": "[parameters('location')]", 
                    "apiVersion": "2018-11-20", 
                    "name": "[concat(parameters('vmName'), '/Microsoft.GuestConfiguration/', parameters('assignmentName'))]", 
                    "condition": "[equals(toLower(parameters('type')), toLower('Microsoft.Compute/virtualMachineScaleSets'))]" 
                  } 
                ], 
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#" 
              } 
            } 
          }, 
          "name": "[concat('RepairClusterAMA$pid', uniqueString(policy().assignmentId, policy().definitionReferenceId))]" 
        } 
      }, 
      "if": { 
        "anyOf": [ 
          { 
            "allOf": [ 
              { 
                "anyOf": [ 
                  { 
                    "field": "type", 
                    "equals": "Microsoft.Compute/virtualMachines" 
                  }, 
                  { 
                    "field": "type", 
                    "equals": "Microsoft.Compute/virtualMachineScaleSets" 
                  } 
                ] 
              }, 
              { 
                "field": "tags['aks-managed-orchestrator']", 
                "exists": "false" 
              }, 
              { 
                "field": "tags['aks-managed-poolName']", 
                "exists": "false" 
              }, 
              { 
                "anyOf": [ 
                  { 
                    "field": "Microsoft.Compute/imagePublisher", 
                    "in": [ 
                      "esri", 
                      "incredibuild", 
                      "MicrosoftDynamicsAX", 
                      "MicrosoftSharepoint", 
                      "MicrosoftVisualStudio", 
                      "MicrosoftWindowsDesktop", 
                      "MicrosoftWindowsServerHPCPack" 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "MicrosoftWindowsServer" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageSKU", 
                        "notLike": "2008*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "MicrosoftSQLServer" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "notLike": "SQL2008*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "microsoft-dsvm" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "like": "dsvm-win*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "microsoft-ads" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "in": [ 
                          "standard-data-science-vm", 
                          "windows-data-science-vm" 
                        ] 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "batch" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "equals": "rendering-windows2016" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "center-for-internet-security-inc" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "like": "cis-windows-server-201*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "pivotal" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "like": "bosh-windows-server*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "cloud-infrastructure-services" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "like": "ad*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "anyOf": [ 
                          { 
                            "field": "Microsoft.Compute/virtualMachines/osProfile.windowsConfiguration", 
                            "exists": true 
                          }, 
                          { 
                            "field": "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType", 
                            "like": "Windows*" 
                          }, 
                          { 
                            "field": "Microsoft.Compute/VirtualMachineScaleSets/osProfile.windowsConfiguration", 
                            "exists": true 
                          }, 
                          { 
                            "field": "Microsoft.Compute/virtualMachineScaleSets/virtualMachineProfile.storageProfile.osDisk.osType", 
                            "like": "Windows*" 
                          } 
                        ] 
                      }, 
                      { 
                        "anyOf": [ 
                          { 
                            "field": "Microsoft.Compute/imageSKU", 
                            "exists": false 
                          }, 
                          { 
                            "allOf": [ 
                              { 
                                "field": "Microsoft.Compute/imageOffer", 
                                "notLike": "SQL2008*" 
                              }, 
                              { 
                                "field": "Microsoft.Compute/imageSKU", 
                                "notLike": "2008*" 
                              } 
                            ] 
                          } 
                        ] 
                      } 
                    ] 
                  } 
                ] 
              } 
            ] 
          }, 
          { 
            "allOf": [ 
              { 
                "equals": true, 
                "value": "[parameters('IncludeArcMachines')]" 
              }, 
              { 
                "anyOf": [ 
                  { 
                    "allOf": [ 
                      { 
                        "field": "type", 
                        "equals": "Microsoft.HybridCompute/machines" 
                      }, 
                      { 
                        "field": "Microsoft.HybridCompute/imageOffer", 
                        "like": "windows*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "type", 
                        "equals": "Microsoft.ConnectedVMwarevSphere/virtualMachines" 
                      }, 
                      { 
                        "field": "Microsoft.ConnectedVMwarevSphere/virtualMachines/osProfile.osType", 
                        "like": "windows*" 
                      } 
                    ] 
                  } 
                ] 
              } 
            ] 
          } 
        ] 
      }
  },
  "parameters": {
 "IncludeArcMachines": { 
        "allowedValues": [ 
          "true", 
          "false" 
        ], 
        "defaultValue": "false", 
        "metadata": { 
          "description": "By selecting this option, you agree to be charged monthly per Arc connected machine.", 
          "displayName": "Include Arc connected machines", 
          "portalReview": true
        }, 
        "type": "String"
      }, 
      "Content": {  
        "defaultValue": "File content XYZ", 
        "metadata": { 
          "description": "File content", 
          "displayName": "Content" 
        }, 
        "type": "String"
      }, 
      "Path": { 
        "defaultValue": "C:\\DSC\\CreateFileXYZ.txt", 
        "metadata": { 
          "description": "Path including file name and extension", 
          "displayName": "Path" 
        }, 
        "type": "String" 
      }
  }
}
```
</details>

### Policy to install AMA

The policy to install AMA performs the following functions:

- Evaluates if new Azure Stack HCI clusters have the the `AzureMonitoringAgent` extension installed.

- Enforces a remediation task to install AMA on clusters that aren't compliant with the policy.

<details>
  <summary>Expand to view the install AMA policy code in JSON.</summary>

```json
{
  "mode": "Indexed",
  "policyRule": {
     "if": {
          "field": "type",
          "equals": "Microsoft.AzureStackHCI/clusters"
        },
        "then": {
          "effect": "[parameters('effect')]",
          "details": {
            "type": "Microsoft.AzureStackHCI/clusters/arcSettings/extensions",
            "name": "[concat(field('name'), '/default/AzureMonitorWindowsAgent')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "existenceCondition": {
              "field": "Microsoft.AzureStackHCI/clusters/arcSettings/extensions/extensionParameters.type",
              "equals": "AzureMonitorWindowsAgent"
            },
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "clusterName": {
                      "type": "string",
                      "metadata": {
                        "description": "The name of Cluster."
                      }
                    }
                  },
                  "resources": [
                    {
                      "type": "Microsoft.AzureStackHCI/clusters/arcSettings/extensions",
                      "apiVersion": "2023-08-01",
                      "name": "[concat(parameters('clusterName'), '/default/AzureMonitorWindowsAgent')]",
                      "properties": {
                        "extensionParameters": {
                          "publisher": "Microsoft.Azure.Monitor",
                          "type": "AzureMonitorWindowsAgent",
                          "autoUpgradeMinorVersion": false,
                          "enableAutomaticUpgrade": false
                        }
                      }
                    }
                  ]
                },
                "parameters": {
                  "clusterName": {
                    "value": "[field('Name')]"
                  }
                }
              }
            }
          }
        }
  },
  "parameters": {
   "effect": {
          "type": "String",
          "metadata": {
            "displayName": "Effect",
            "description": "Enable or disable the execution of the policy"
          },
          "allowedValues": [
            "DeployIfNotExists",
            "Disabled"
          ],
          "defaultValue": "DeployIfNotExists"
        }
  }
}
```
</details>

### Policy to configure DCR association

This policy is applied to each server in the Azure Stack HCI cluster and performs the following function:

- Takes the `dataCollectionResourceId` as input and associates the Data Collection Rule (DCR) with each server.

> [!NOTE]
> This policy doesn’t create Data Collection Endpoint (DCE). If you're using private links, you must create DCE to ensure there's data available in Insights. For more information, see [Enable network isolation for Azure Monitor Agent by using Private Link](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-private-link).
 
<details>
  <summary>Expand to view the policy code in JSON.</summary>

```json
{
  "mode": "INDEXED",
  "policyRule": {
     "if": {
          "field": "type",
          "equals": "Microsoft.HybridCompute/machines"
        },
        "then": {
          "effect": "[parameters('effect')]",
          "details": {
            "type": "Microsoft.Insights/dataCollectionRuleAssociations",
            "name": "[concat(field('name'), '-dataCollectionRuleAssociations')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "machineName": {
                      "type": "string",
                      "metadata": {
                        "description": "The name of the machine."
                      }
                    },
                    "dataCollectionResourceId": {
                      "type": "string",
                      "metadata": {
                        "description": "Resource Id of the DCR"
                      }
                    }
                  },
                  "resources": [
                    {
                      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
                      "apiVersion": "2022-06-01",
                      "name": "[concat(parameters('machineName'), '-dataCollectionRuleAssociations')]",
                      "scope": "[format('Microsoft.HybridCompute/machines/{0}', parameters('machineName'))]",
                      "properties": {
                        "description": "Association of data collection rule. Deleting this association will break the data collection for this machine",
                        "dataCollectionRuleId": "[parameters('dataCollectionResourceId')]"
                      }
                    }
                  ]
                },
                "parameters": {
                  "machineName": {
                    "value": "[field('Name')]"
                  },
                  "dataCollectionResourceId": {
                    "value": "[parameters('dcrResourceId')]"
                  }
                }
              }
            }
          }
        }
  },
  "parameters": { "effect": {
        "type": "String",
        "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
        },
        "allowedValues": [
        "DeployIfNotExists",
        "Disabled"
        ],
        "defaultValue": "DeployIfNotExists"
    },
    "dcrResourceId": {
        "type": "String",
        "metadata": {
        "displayName": "dcrResourceId",
        "description": "Resource Id of the DCR"
        }
    }

  }
}
```
</details>

## Enable Insights at scale using Azure policies

This section describes how to enable Insights for Azure Stack HCI at scale using Azure policies.

### Prerequisites

Here are the prerequisites for enabling Insights for Azure Stack HCI at scale using Azure policies:

- You must have access to Azure Stack HCI clusters on which you want to enable Insights. These clusters must be deployed and registered.
- You must have the managed identity for the Azure resources enabled. For more information, see [Enabled enhanced management](azure-enhanced-management-managed-identity.md).
- You must have the **Guest Configuration Resource Contributor** role in your Azure subscription.

### Order of policy application

Apply the Azure policies in the following order to enable Insights at scale for Azure Stack HCI clusters:

1. (For Azure Stack HCI, version 22H2 clusters only) Apply the policy to repair AMA before applying any other policy. This step isn't required for Azure Stack HCI, version 23H2 clusters. For policy definition, see [Policy to repair AMA](#policy-to-repair-ama).
1. Apply policy to install AMA. For policy definition, see [Policy to install AMA](#policy-to-install-ama).
1. Apply policy to configure DCR. For policy definition, see [Policy to configure DCR association](#policy-to-configure-dcr-association).

### Workflow to apply policies

Here's the workflow to apply each policy:

1. Create the policy definition.
1. Create the policy assignment.
1. Identify non-compliant resources.
1. Remediate non-compliant resources.

### Create the policy definition

To create a policy definition, follow these steps:

1. In the Azure portal, navigate to the Azure Policy service.
1. Under the **Authoring** section, select **Definitions**.
1. Select **+ Policy definition** to create a new policy definition.
1. Select **Add policy definition** to create a new policy definition.
1. On the **Policy definition** page, specify the following values:

    :::image type="content" source="./media/monitor-hci-multi-azure-policies/policy-definition.png" alt-text="Screenshot of the Policy definition page to create a new policy definition." lightbox="./media/monitor-hci-multi-azure-policies/policy-definition.png":::

    1. For the **Definition location** field, select the ellipses (...) to specify where the policy resouce is located. On the **Definition location** pane, select the Azure subscription and then select **Select**.
    1. Specify a friendly name for the policy. You can optionally specify a description and category.
    1. Under **POLICY RULE**, delete the prepopulated policy definition. Copy and paste the content from the JSON file for your policy. To find the JSON files for each policy, see the [About Azure policies to enable Insights at scale](#about-azure-policies-to-enable-insights-at-scale) section.
    1. From the **Role definitions** list, select **Guest Configuration Resource Contributor**.
    1. Select **Save**.
1. You'll see a notification that the policy definition creation was successful. You can then proceed to create the policy assignment.

### Create the policy assignment

Next, you create a policy assignment to assign the policy to a resource. The scope of the policy corresponds to that resource and any resources beneath it. For more information on policy assignment, see [Azure Policy assignment structure](/azure/governance/policy/concepts/assignment-structure).

To assign the policy, follow these steps:

1. In the Azure portal, navigate to the Azure Policy service.
1. Under the **Authoring** section, select **Assignments**.
1. Select **Assign policy** to create a new policy assignment.
1. On the **Assign policy** page, specify the following values:

    :::image type="content" source="./media/monitor-hci-multi-azure-policies/policy-definition.png" alt-text="Screenshot of the Policy definition page to create a new policy definition." lightbox="./media/monitor-hci-multi-azure-policies/policy-definition.png":::

    1. For the **Scope** field, select the ellipsis (...) and then select a **Subscription** and optionally select a **Resource Group**. Then select **Select** to apply the scope.
    1. (Optional) If you've selected a resource group in the previous step, optionally select the resources to exclude from the policy assignment by selecting the ellipses (...) for the **Exclusions** field.
    1. For the **Policy definition** field, select the ellipsis (...) to open the list of available definitions. Filter the results based on the policy defined in the previous step, select the policy and select **Add**.
    1. The **Assignment name** field displays the default name of the selected policy. You can change it if you want. The description is optional.
    1. Leave **Policy enforcement** set to **Enabled**.
1. (Optional) Select **Next** to view each tab for **Advanced**, **Parameters**, and **Remediation**. The sample policies already have parameters and remediation tasks defined in their definitions. No changes are needed for this example.
1. Select **Review + create** to review the assignment.
1. Select **Create** to create the assignment.

  The configuration is then applied to new Azure Stack HCI clusters created within the scope of policy assignment. For existing clusters, you might need to manually run a remediation task. This task typically takes 10 to 20 minutes for the policy assignment to take effect.

Once the assignment is created, the Azure Policy engine identifies all Azure Stack HCI clusters located within the scope and applies the policy configuration to each cluster.

### Identify non-compliant resources

After you've assigned the policy, you can view the compliance report. The compliance state for a new policy assignment takes a few minutes to become active and provide results about the policy's state.

To view the non-compliant resources in the Azure portal, follow these steps:

1. In the Azure portal, navigate to the Azure Policy service.
1. Select **Compliance**.
1. Filter the results for the name of the policy assignment that you created in the previous step. The report shows resources that are not in compliance with the policy.

    :::image type="content" source="./media/monitor-hci-multi-azure-policies/policy-compliance.png" alt-text="Screenshot of the Policy Compliance that highlights a non-compliant policy assignment." lightbox="./media/monitor-hci-multi-azure-policies/policy-compliance.png":::

1. The policy assignment shows resources that aren't compliant with a **Compliance state** of **Non-compliant**. To get more details, select the policy assignment name to view the **Resource Compliance**. For example, if you are assigning the policy to install AMA, this will show the resources that don't have the AMA installed.

### Remediate resources

The resources that aren't compliant with the policy rule you selected, you can create remediation task for them.

To remediate the resources, follow these steps:

1. In the Azure portal, navigate to the Azure Policy service.
1. Select **Remediation**.
1. Filter the results for the name of the policy assignment that you created in the previous step. 

## Next steps

For related information, see:

- [Configure Azure portal to monitor Azure Stack HCI clusters](/azure-stack/hci/manage/monitor-hci-single)
- [Monitor Azure Stack HCI clusters from Windows Admin Center](monitor-cluster.md)
- [Troubleshooting workbook-based insights](/azure/azure-monitor/insights/troubleshoot-workbooks)

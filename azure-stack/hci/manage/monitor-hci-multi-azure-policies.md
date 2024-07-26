---
title: Enable Insights for Azure Stack HCI at scale using Azure policies
description: How to enable Insights for Azure Stack HCI clusters at scale using Azure policies.
author: ManikaDhiman
ms.author: v-manidhiman
ms.reviewer: saniyaislam
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 07/25/2024
---

# Enable Insights for Azure Stack HCI clusters at scale using Azure policies

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This document describes how to enable Insights for Azure Stack HCI at scale using Azure policies. To enable Insights for a single Azure Stack HCI cluster, see [Monitor Azure Stack HCI with Insights](./monitor-hci-single-23H2.md).

## About using Azure policies to enable Insights at scale

To monitor Azure Stack HCI systems at scale with Insights, you need to enable Insights for each cluster individually. To simplify this process, you can use Azure policies to automatically enable Insights at the subscription or resource group level. These policies check the compliance of resources within their scope based on defined rules. You can remediate any non-compliant resources through remediation tasks. This section describes the sample policy definitions that you can use to create policy definitions for your scenario.

### Policy to repair AMA

For Azure Stack HCI clusters registered before Nov 2023, you need to repair cluster registration and Azure Monitor Agent (AMA) before configuring Insights again. For details, see [Troubleshoot clusters registered before November 2023](./monitor-hci-single.md#troubleshoot-clusters-registered-before-november-2023).

To repair the cluster, uninstall AMA and then apply the repair Azure policy.

The repair policy removes the registry key, if present, which determines the resource ID for which AMA collects data.

Before applying this policy, keep in mind the following things:

- This policy is applicable only to Azure Stack HCI, version 22H2 clusters. Apply it before any other policies to ensure AMA picks up the correct resource ID.
- Uninstall AMA before applying this policy to set the correct resource ID. If AMA isn't uninstalled first, data might not appear.

<details>
  <summary>Expand this section to see the policy definition in JSON.</summary>

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

- Evaluates if new Azure Stack HCI clusters have the `AzureMonitoringAgent` extension installed.

- Enforces a remediation task to install AMA on clusters that aren't compliant with the policy.

<details>
  <summary>Expand this section to see the policy definition in JSON.</summary>

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
> This policy doesn’t create Data Collection Endpoint (DCE). If you're using private links, you must create DCE to ensure there's data available in Insights. For more information, see [Enable network isolation for Azure Monitor Agent by using Private Link](/azure/azure-monitor/agents/azure-monitor-agent-private-link).
 
<details>
  <summary>Expand this section to see the policy definition in JSON.</summary>

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

1. (For Azure Stack HCI, version 22H2 clusters only) Policy to repair AMA before applying any other policy. This step isn't required for Azure Stack HCI, version 23H2 clusters. For policy definition, see [Policy to repair AMA](#policy-to-repair-ama).
1. Policy to install AMA. For policy definition, see [Policy to install AMA](#policy-to-install-ama).
1. Policy to configure DCR. For policy definition, see [Policy to configure DCR association](#policy-to-configure-dcr-association).

### Workflow to apply policies

Here's the workflow to apply each policy:

1. [Create a policy definition](#create-a-policy-definition).
1. [Create a policy assignment](#create-a-policy-assignment).
1. [View compliance status](#view-compliance-status).
1. [Remediate non-compliant resources](#remediate-non-compliant-resources).

### Create a policy definition

To create a policy definition, follow these steps:

1. In the Azure portal, navigate to the Azure Policy service.
1. Under the **Authoring** section, select **Definitions**.
1. Select **+ Policy definition** to create a new policy definition.
1. Select **Add policy definition** to create a new policy definition.
1. On the **Policy definition** page, specify the following values:

   | Field | Action |
   | ---- | ---- |
   | **Definition location** |  Select the ellipsis (`...`) to specify where the policy resource is located. On the **Definition location** pane, select the Azure subscription and then select **Select**. |
   | **Name** | Specify a friendly name for the policy. You can optionally specify a description and category. |
   | **POLICY RULE** | The JSON edit box is prepopulated with a policy definition template. Replace this template with the policy definition template you want to apply. For the definition templates for Insights policies in JSON format, see the [About using Azure policies to enable Insights at scale](#about-using-azure-policies-to-enable-insights-at-scale) section. |
   | **Role definitions** | Select **Guest Configuration Resource Contributor**. |

      :::image type="content" source="./media/monitor-hci-multi-azure-policies/policy-definition.png" alt-text="Screenshot of the Policy definition page to create a new policy definition." lightbox="./media/monitor-hci-multi-azure-policies/policy-definition.png":::

1. Select **Save**.
1. You get a notification that the policy definition creation was successful. You can then proceed to create the policy assignment.

### Create a policy assignment

Next, you create a policy assignment and assign the policy definition at the subscription or resource group level. The scope of the policy corresponds to that resource and any resources beneath it. For more information on policy assignment, see [Azure Policy assignment structure](/azure/governance/policy/concepts/assignment-structure).

To assign the policy, follow these steps:

1. In the Azure portal, navigate to the Azure Policy service.
1. Under the **Authoring** section, select **Assignments**.
1. Select **Assign policy** to create a new policy assignment.
1. On the **Assign policy** page > **Basic** tab, specify the following values:

   | Field | Action |
   | ---- | ---- |
   | **Scope** | Use the ellipsis (`...`) and then select a subscription and optionally a resource group. Then select **Select** to apply the scope. |
   | **Exclusions** | Optional. If you've selected a resource group in the previous step, use the ellipsis (`...`) to select the resources to exclude from the policy assignment. |
   | **Policy definition** | Select the ellipsis to open the list of available definitions. Filter the results based on the policy defined in the [Create a policy definition](#create-a-policy-definition) step, select the policy definition, and select **Add**.|
   | **Assignment name** | By default it uses the name of the selected policy. You can change it if required. |
   | **Policy enforcement** | Defaults to _Enabled_. For more information, go to [enforcement mode](/azure/governance/policy/concepts/assignment-structure#enforcement-mode). |
 
    :::image type="content" source="./media/monitor-hci-multi-azure-policies/policy-assign.png" alt-text="Screenshot of the Assign policy page to assign the policy definition." lightbox="./media/monitor-hci-multi-azure-policies/policy-assign.png":::

1. Select **Next** to view the **Parameters** tab. If the policy definition you selected on the **Basics** tab included parameters, they show up on **Parameters** tab.

    For example, the policy to repair AMA shows the **Include Arc connected machines** parameter. Select **True** to include Arc connected machines in the policy assignment.

    :::image type="content" source="./media/monitor-hci-multi-azure-policies/policy-assign-parameters-tab.png" alt-text="Screenshot of the Parameters tab on Assign policy page to define or modify parameters." lightbox="./media/monitor-hci-multi-azure-policies/policy-assign-parameters-tab.png":::

1. Select **Next** to view the **Remediation** tab. No action is needed on this tab. The policy definition templates support the *deployIfNotExists* effect, so the resources that aren't compliant with the policy rule get automatically remediated. Additionally, notice that the **Create a Managed Identity** parameter is selected by default since the policy definition templates use the *deployIfNotExists* effect.

    :::image type="content" source="./media/monitor-hci-multi-azure-policies/policy-assign-remediation-tab.png" alt-text="Screenshot of the Remediation tab on the Assign policy page to define remediation task if necessary." lightbox="./media/monitor-hci-multi-azure-policies/policy-assign-remediation-tab.png":::

1. Select **Review + create** to review the assignment.
1. Select **Create** to create the assignment.
1. You get notifications that the role assignment and policy assignment creations were successful. Once the assignment is created, the Azure Policy engine identifies all Azure Stack HCI clusters located within the scope and applies the policy configuration to each cluster. Typically, it takes 5 to 15 minutes for the policy assignment to take effect.

### View compliance status

After you've assigned the policy, you can monitor compliance of resources under **Compliance** and remediation status under **Remediation** on the Azure Policy home page. The compliance state for a new policy assignment takes a few minutes to become active and provide results about the policy's state.

To view the compliance status of the policy, follow these steps:

1. In the Azure portal, navigate to the Azure Policy service.
1. Select **Compliance**.
1. Filter the results for the name of the policy assignment that you created in the [Create a policy assignment](#create-a-policy-assignment) step. The **Compliance state** column displays the compliance state as **Compliant** or **Non-compliant**.

    :::image type="content" source="./media/monitor-hci-multi-azure-policies/compliance-status.png" alt-text="Screenshot of the Policy Compliance page showing the compliance status." lightbox="./media/monitor-hci-multi-azure-policies/compliance-status.png":::

1. Select the policy assignment name to view the **Resource Compliance** status. For example, the compliance report for the install AMA policy shows the clusters that don't have AMA installed as non-compliant:

    :::image type="content" source="./media/monitor-hci-multi-azure-policies/compliance-status-resources.png" alt-text="Screenshot of the Policy Compliance status page showing the compliance status." lightbox="./media/monitor-hci-multi-azure-policies/compliance-status-resources.png":::

1. Once you know which resources are non-compliant, you can create the remediation task to make them compliant.

### Remediate non-compliant resources

To remediate non-compliant resources and track remediation task progress, follow these steps:

1. In the Azure portal, navigate to the Azure Policy service.
1. Select **Remediation**.
1. The **Remediation** page displays the list of assigned policies that have non-compliant resources. Filter the results for the name of the policy assignment that you created in the [Create a policy assignment](#create-a-policy-assignment) step.
1. Select the **Policy Definition** link.

    :::image type="content" source="./media/monitor-hci-multi-azure-policies/policy-remediation.png" alt-text="Screenshot of the Policy Remediation page showing the policies to remediate." lightbox="./media/monitor-hci-multi-azure-policies/policy-remediation.png":::

1. The **New remediation task** page displays the resources that need remediation. Select the **Re-evaluate resource compliance before remediating** checkbox and then select **Remediate**.

    :::image type="content" source="./media/monitor-hci-multi-azure-policies/new-remediation-task.png" alt-text="Screenshot of New remediation task page." lightbox="./media/monitor-hci-multi-azure-policies/new-remediation-task.png":::

1. You get a notification that a remediation task is created, and you'll be directed to the **Remediation tasks** tab. This tab shows the status of different remediation tasks. The one you created might be in the **Evaluating** state.

    :::image type="content" source="./media/monitor-hci-multi-azure-policies/policy-remediation.png" alt-text="Screenshot of the Policy Remediation page showing the policies to remediate." lightbox="./media/monitor-hci-multi-azure-policies/policy-remediation.png":::

1. Once the remediation is complete, the state changes to either **Completed** or **Failed**.

## Next steps

For related information, see:

- [Configure Azure portal to monitor Azure Stack HCI clusters](/azure-stack/hci/manage/monitor-hci-single)
- [Monitor Azure Stack HCI clusters from Windows Admin Center](monitor-cluster.md)
- [Troubleshooting workbook-based insights](/azure/azure-monitor/insights/troubleshoot-workbooks)

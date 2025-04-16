---
title: Enable SDN on Azure Local using an ECE action plan (Preview)
description: Describes how to enable SDN using an ECE action on Azure Local (Preview).
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.topic: how-to
ms.date: 04/14/2025
---

# Enable SDN on Azure Local using ECE action plan (Preview)

> Applies to: Azure Local 2504 or later

This article describes how to enable cloud-managed software defined networking (SDN) on your existing Azure Local instance. You will use an ECE action plan via the Azure Command-line interface (CLI) to enable SDN.

[!INCLUDE [important](../includes/hci-preview.md)]

## About enabling SDN in Azure Local

For cloud-managed SDN, the network controller is deployed as a set of Failover Cluster services managed by the orchestrator (also known as Lifecycle Manager). You run an orchestrator command that integrates the network controller into the Azure Local platform as a managed service.

Once the network controller is integrated, cloud-managed SDN is enabled. You can use the Azure portal, Azure CLI, or Azure Resource Manager templates to create and manage the following SDN features:

- **Logical networks**: You can create SDN static or DHCP logical networks that project your physical networks. For more information, see [Create logical networks](../manage/create-logical-networks.md).
- **Network interfaces**: You can attach network interfaces to virtual machines and assign them IP addresses from the logical network. For more information, see [Create network interfaces](../manage/create-network-interfaces.md).
- **Network Security Group (NSG)**: You can apply NSGs to network interfaces or logical networks to filter network traffic based on security rules. You can also create network security rules and default network access policies. For more information, see [Create network security groups](../manage/create-network-security-groups.md).
- **Network security rules**: You can create network security rules to allow or deny traffic to and from network interfaces and logical networks. For more information, see [Create network security rules](../manage/create-network-security-groups.md#create-a-network-security-rule).

## Considerations and limitations

> [!IMPORTANT]
> - Cloud-managed SDN is a preview feature and shouldn't be deployed on production clusters.
> - Once you have enabled SDN, you can't roll back or disable.

Here are some considerations and limitations to keep in mind:

- Cloud-managed SDN is supported with updates to newer Azure Local releases.
- AKS workloads on Azure Local do not support network security groups applied to the logical network where they are running.
- Enabling cloud-managed SDN with existing Azure Local VMs and logical networks is supported.
    - The logical networks and network interfaces are automatically hydrated into the Network Controller.
    - You may experience a short network disruption (about 30 seconds disconnection while SDN Azure Virtual Filtering Platform policies are applied).

## Prerequisites

- You’ve access to an Azure Local instance running 2504 or later.
- You’ve access to a client used to connect to Azure Local instance via Azure CLI.
    
    This client should have the latest version of [Azure CLI](/cli/azure/install-azure-cli) and the appropriate version of `stack-hci-vm` software installed from the [Azure Local VM release tracking table](https://aka.ms/arcvm-rel). 
- You’ve access to an Azure subscription with the Azure Stack HCI Administrator role-based access control (RBAC) role. This role grants full access to your Azure Local instance and its resources.

    An Azure Stack HCI administrator can register the Azure Local instance as well as assign Azure Stack HCI VM contributor and Azure Stack HCI VM reader roles to other users. For more information, see [Assign Azure Local RBAC roles](../manage/assign-vm-rbac-roles.md#about-builtin-rbac-roles).
- Make sure that Dynamic DNS updates are enabled or pre-create the NC rest name DNS record before you run `Add-EceFeature`.
    - The NC rest name should be unique in the Active Directory.
    - For more information, see [Dynamic DNS updates](../index.yml).

## Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../includes/hci-vm-sign-in-set-subscription.md)]

## Review ECE action plan parameters

The ECE action plan uses the following parameters:


| Parameter  | Description  |
|---------|---------|
|**Name**   | Pass the name as `NC`. No other user input is allowed.         |
|**SDNPrefix**     | Pass the value as `v`. This parameter is used for Network Controller REST URL to differentiate network controllers across Azure Local instances. <br> For example, `-SDNPrefix v` makes `https://v-NC.domainname/` as the `NC` REST URL for the Azure Local instance.         |
|**MacAddressPoolStart**   | Use this optional parameter to define the first MAC address of the custom pool.|
|**MacAddressPoolEnd**   | Use this optional parameter to define the last MAC address of the custom pool.|


## Run the ECE action plan

Follow these steps on the Azure CLI to run the ECE action plan:

1. Verify that you are [Connected to the first node of your Azure Local instance](../manage/azure-arc-vm-management-prerequisites.md#connect-to-the-system-directly) with Azure Stack HCI administrator role.

1. Run the ECE action plan to deploy network controller as a Failover Cluster Service. Open a PowerShell command prompt and run the following command.

    ```azurecli
    #Run the LCM action plan to install Network Controller as Failover Cluster Service
    
    Add-EceFeature -Name NC -SDNPrefix v
    ```

    This step can take up to 5 minutes.

1. Validate that network controller is successfully added to your instance. Once the network controller is added, the `add-EceFeature` command shows the action plan outcome.
    <br></br>
    <details>
    <summary>Expand this section to see an example output.</summary>

    ```output
    Start                  End                    Duration    Type   Status  Name                                                                                         
    -----                  ---                    --------    ----   ------  ----                                                                                         
    03/11/2025 10:29:52 PM 03/11/2025 10:31:13 PM 00.00:01:20 Action Success └─(A)CleanNCSecret                                                                           
    03/11/2025 10:29:52 PM 03/11/2025 10:31:13 PM 00.00:01:20 Step   Success   └─(S)1 Parallel per-node operation top step                                                
    SNIPPED			SNIPPED			SNIPPED
    03/11/2025 10:29:52 PM 03/11/2025 10:31:12 PM 00.00:01:20 Step   Success         └─(S)1.1 Clean up NC secrets                                                         
    03/11/2025 10:29:52 PM 03/11/2025 10:31:12 PM 00.00:01:20 Task   Success           └─(T)[RemoteNode=Machine2>] Role=Cloud\Fabric\NC Interface=CleanNCRestSecret  

    InstanceID     : <Instance1 ID>
    ActionTypeName : CleanNCSecret
    Status         : Completed
    StartDateTime  : 3/11/2025 10:29:51 PM
    EndDateTime    : 3/11/2025 10:31:18 PM
    
    Start                  End                    Duration    Type   Status  Name                                                                                    
    -----                  ---                    --------    ----   ------  ----                                                                                    
    03/11/2025 10:31:52 PM 03/11/2025 10:31:57 PM 00.00:00:04 Action Success └─(A)GenerateCertificates                                                               
    03/11/2025 10:31:52 PM 03/11/2025 10:31:57 PM 00.00:00:04 Step   Success   └─(S)1 Generate NC Rest certificate                                                   
    03/11/2025 10:31:52 PM 03/11/2025 10:31:57 PM 00.00:00:04 Task   Success     └─(T)Role=Cloud\Infrastructure\ASCA Interface=GenerateSSLCertificatesForNCDeployment
    
    InstanceID     : <Instance2 ID>
    ActionTypeName : GenerateCertificates
    Status         : Completed
    StartDateTime  : 3/11/2025 10:31:52 PM
    EndDateTime    : 3/11/2025 10:32:02 PM
    
    Start       End       Duration    Type   Status Name                                                                                                                   
    -----                  ---                    --------    ----   ------  ----                                                                                                                   
    03/11/2025 10:32:53 PM 03/11/2025 10:41:50 PM 00.00:08:57 Action Success └─(A)EnableMOCSDN                                                                                                      
    03/11/2025 10:32:53 PM 03/11/2025 10:41:50 PM 00.00:08:57 Step   Success   └─(S)1 FCNC deployment and MOC hydration.                                                                            
    03/11/2025 10:32:53 PM 03/11/2025 10:41:50 PM 00.00:08:57 Task   Success     └─(T)Role=Cloud\Fabric\NC Action=DeployFCNCHydrateMOC                                                              
    
    SNIPPED			SNIPPED			SNIPPED           
                           
    03/11/2025 10:40:19 PM 03/11/2025 10:40:25 PM 00.00:00:06 Step   Success         │                 │           ├─(S)1 Check Firewall Rules                                                     
    03/11/2025 10:40:19 PM 03/11/2025 10:40:25 PM 00.00:00:06 Task   Success         │                 │           │ └─(T)Role=Cloud\Fabric\NC Interface=VerifyNCFirewallRulesEnabled               
    03/11/2025 10:40:25 PM 03/11/2025 10:40:32 PM 00.00:00:06 Step   Success         │                 │           └─(S)2 Check VM switch extension is enabled                                     
    03/11/2025 10:40:25 PM 03/11/2025 10:40:32 PM 00.00:00:06 Task   Success         │                 │             └─(T)Role=Cloud\Fabric\NC Interface=VerifyNCVMSwitchExtensionEnabled           
    03/11/2025 10:41:13 PM 03/11/2025 10:41:21 PM 00.00:00:07 Step   Success         │                 └─(S)1.1.0.9.2 VerifyNCResources                                                            
    03/11/2025 10:41:13 PM 03/11/2025 10:41:21 PM 00.00:00:07 Task   Success         │                   └─(T)Role=Cloud\Fabric\NC Interface=VerifyNCResources                                      
    03/11/2025 10:41:21 PM 03/11/2025 10:41:50 PM 00.00:00:29 Step   Success         └─(S)1.2 Enable FCNC SDN for MOC                                                                              
    03/11/2025 10:41:21 PM 03/11/2025 10:41:50 PM 00.00:00:29 Task   Success           └─(T)Role=Cloud\Fabric\NC Action=SetMOCSDNEnabled                                                            
    03/11/2025 10:41:21 PM 03/11/2025 10:41:50 PM 00.00:00:29 Action Success             └─(A)SetMOCSDNEnabled                                                                                      
    03/11/2025 10:41:21 PM 03/11/2025 10:41:43 PM 00.00:00:22 Step   Success               ├─(S)1.2.1 Enable FCNC SDN for MOC                                                                      
    03/11/2025 10:41:21 PM 03/11/2025 10:41:43 PM 00.00:00:22 Task   Success               │ └─(T)Role=Cloud\Fabric\NC Interface=EnableSDNForMOC                                                    
    03/11/2025 10:41:43 PM 03/11/2025 10:41:50 PM 00.00:00:07 Step   Success               └─(S)1.2.2 Flag FCNC deployed                                                                            
    03/11/2025 10:41:43 PM 03/11/2025 10:41:50 PM 00.00:00:07 Task   Success                 └─(T)Role=Cloud\Fabric\NC Interface=SetFCNCCompleteMOCHydrated                  
                           
    InstanceID     : <Instance ID>
    ActionTypeName : EnableMOCSDN
    Status         : Completed
    StartDateTime  : 3/11/2025 10:32:52 PM
    EndDateTime    : 3/11/2025 10:41:55 PM
    
    VERBOSE: Full XML progress log file located at: C:\MASLogs\EnableMOCSDN.2025-03-11.22-32-52
    WARNING: Unable to find volume with label Deployment
    VERBOSE: SDN Network Controller URL is https://v-NC.s45r2305.masd.stbtest.microsoft.com/
    VERBOSE: Enabling SDN for MOC completed.
    0
    VERBOSE: Transcript stopped at C:\MASLogs\Add-EceFeature.2025-03-11.22-29-49
    ```

    </details>

## Next steps

- Learn how to [Create network security groups, network security rules, and default network access policies](../manage/create-network-security-groups.md).

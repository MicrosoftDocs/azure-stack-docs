---
title: Recover Azure Arc Resource Bridge and Associated Resources After a Restore and Cluster Re-registration
description: Learn how to recreate the Azure Arc resource bridge (ARB), custom location, logical network, and storage resources on a restored Azure Local disconnected operations cluster after a restore and re-registration of the management or data cluster.
author: anupam8995
ms.author: kumaranupam
ms.date: 09/02/2026
ms.topic: how-to
ms.service: azure-local
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Recover Azure Arc resource bridge and associated resources after a restore and cluster re-registration

::: moniker range=">=azloc-2603"

This article describes how to recreate the Azure Arc resource bridge (ARB), custom location (CL), logical network (Lnet), and storage resources on a disconnected operations for Azure Local cluster after you re-register the management cluster or a data cluster that you created post-backup. The existing key vault and user storage are preserved. You only need to recreate the cluster-scoped resources.

::: moniker-end

::: moniker range=">=azloc-2609"

## Automated recovery

ARB recovery is included in the public re-registration commands in the post-restore recovery module. There isn't a separate public command that only restores ARB.

Use the command for the cluster type that you're recovering:

- For a management cluster, [run `Invoke-ApplianceManagementClusterReRegistration`](disconnected-operations-post-restore-repair-register-management-cluster.md#invoke-appliancemanagementclusterreregistration).
- For a data cluster that you created after the backup, first reconnect the data cluster from its DVM, and then [run `Invoke-ApplianceDataClusterReRegistration`](disconnected-operations-post-restore-repair-register-management-cluster.md#invoke-appliancedataclusterreregistration).

The linked command sections include the module import, sample command, available parameters, and parameter descriptions.

::: moniker-end

::: moniker range=">=azloc-2603 <azloc-2609"

> [!NOTE]
> Automated recovery is available in Azure Local 2609 and later. If your Azure Local disconnected operations version is earlier than 2609, follow the manual steps in this article.

## Prerequisites

Before you start, complete these prerequisites:

- **Cluster re-registration complete**: You completed [Re-register the management or data cluster (created post backup) on a restored disconnected operations for Azure Local setup](disconnected-operations-post-restore-repair-register-management-cluster.md) and `Register-AzStackHCI -RepairRegistration` finished successfully.
- **CredSSP session open**: You have an active CredSSP session to the seed node. To configure CredSSP and open the session, see [Step 1: Define variables, enable CredSSP, and open a CredSSP session](disconnected-operations-post-restore-repair-register-management-cluster.md#step-1-define-variables-enable-credssp-and-open-a-credssp-session). Run all the steps in this article in that CredSSP session to avoid a second-hop authentication failure.
- **Backup public certificate available**: You have a copy of `PublicCertificate.cer` from the backup that you can copy to each cluster node.
- **Environment values**: You have the variables `$seedNode`, `$node`, and `$cluster` defined in the CredSSP session as described in [Step 1 of the re-registration procedure](disconnected-operations-post-restore-repair-register-management-cluster.md#step-1-define-variables-enable-credssp-and-open-a-credssp-session).

## Recreate ARB, custom location, and associated resources

> [!NOTE]
> Run these steps in the CredSSP session you opened in [Step 1 of the re-registration procedure](disconnected-operations-post-restore-repair-register-management-cluster.md#step-1-define-variables-enable-credssp-and-open-a-credssp-session) to avoid a second-hop authentication failure.

1. Replace the public root certificate on each cluster node with the backup's public certificate. On every node, replace the file at `C:\Users\Administrator\AppData\Roaming\AzureLocal\AzureLocalRootCert.cer` (for example, `\\<NodeName>\c$\Users\Administrator\AppData\Roaming\AzureLocal\AzureLocalRootCert.cer`) with `PublicCertificate.cer` from the backup. Keep the file name `AzureLocalRootCert.cer`.

1. Take the current control-plane cluster group offline. Replace `<control-plane-group-name>` with the actual control-plane group name (for example, output of `Get-ClusterGroup | Where-Object Name -like "*control-plane*"`):

    ```powershell
    Stop-ClusterGroup -Name <control-plane-group-name>
    ```

1. Delete the existing Arc appliance by using its configuration file. Sign in to the Azure CLI first, because the `az arcappliance` commands require an authenticated session:

    ```powershell
    az login --use-device-code

    $appliancePath = "C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\MocArb\WorkingDirectory\Appliance"
    $cfg = "$appliancePath\hci-appliance.yaml"

    az arcappliance delete --config-file $cfg --only-show-errors
    az arcappliance list -o table
    ```

1. Reinstall the MOC and ARB prerequisites by running the `InstallPreReqMocAndArb` action plan:

    ```powershell
    $ap = Invoke-ActionPlanInstance -RolePath 'MocArb' -ActionType 'InstallPreReqMocAndArb'
    Start-MonitoringActionplanInstanceToComplete $ap
    ```

    The following example shows the expected output.

    ```powershell
    VERBOSE: Status of ActionPlan: InstallPreReqMocAndArb
    InstanceID: 00000000-0000-0000-0000-000000000000
    
    Start                  End                    Duration    Type    Status   Name
    -----                  ---                    --------    ----    ------   ----
    
    (A)InstallPreReqMocAndArb
     └─(S)0 Deploy moc and arb
        └─(T)Role=MocArb Action=InstallMocArb
           └─(A)InstallMocArb
              └─(S)0.0 Deploy Pre-requisites and Moc
                 └─(T)Role=MocArb Action=InstallMoc
                    └─(A)InstallMoc
                       └─(S)0.0.0 Install OpenSSH client
                          └─(T)Role=MocArb Action=InstallOpenSSHClientUsingEceAgent
                             └─(A)InstallOpenSSHClientUsingEceAgent
                                └─(S)0.0.0.1 Parallel per-node operation top step
                                   ├─(T)Role=Cloud\Infrastructure\BareMetal
                                   │  Action=ParallelPerNode_SingleTask_Node01
                                   │  └─(A)ParallelPerNode_SingleAction_Node01
                                   │     [ExecutionContext]Node=Node01
                                   │     └─(S)0.0.0.1.1 Install OpenSSH client
                                   │        └─(T)[RemoteNode=Node01]
                                   │           Role=MocArb
                                   │           Interface=InstallOpenSSHClientByECEAgent
                                   └─(T)Role=Cloud\Infrastructure\BareMetal
                                      Action=ParallelPerNode_SingleTask_Node02
                                      └─(A)ParallelPerNode_SingleAction_Node02
                                         [ExecutionContext]Node=Node02
                                         └─(S)0.0.0.1.1 Install OpenSSH client
                                            └─(T)[RemoteNode=Node02]
                                               Role=MocArb
                                               Interface=InstallOpenSSHClientByECEAgent
    
                                └─(S)0.0.1 Deploy moc only
                                   └─(T)Role=MocArb Interface=DeployMoc
    
              └─(S)0.1 Deploy ARB
                 └─(T)Role=MocArb Action=InstallArbOnly
                    └─(A)InstallArbOnly
    
                       └─(S)0.1.0 Reserve Network IPs
                          └─(T)Role=MocArb Action=ReserveNetworkIPsForArb
                             └─(A)ReserveNetworkIPsForArb
                                ├─(S)0.1.0.0 Reserve IP Address
                                │  └─(T)Role=BuiltIn
                                │     Interface=ReserveManagementIPAddress
                                ├─(S)0.1.0.1 Reserve IP Address
                                │  └─(T)Role=BuiltIn
                                │     Interface=ReserveManagementIPAddress
                                └─(S)0.1.0.2 Reserve IP Address
                                   └─(T)Role=BuiltIn
                                      Interface=ReserveManagementIPAddress
    
                       └─(S)0.1.1 Deploy arb
                          └─(T)Role=MocArb Interface=DeployArb
    
                       └─(S)0.1.2 Deploy Infra Logical Network
                          └─(T)Role=MocArb Action=DeployAzInfraLogicalNetwork
                             └─(A)DeployAzInfraLogicalNetwork
                                └─(S)0.1.2.0 Deploy Infra Logical Network
                                   └─(T)Role=MocArb Interface=DeployAzInfraLogicalNetwork
    
    VERBOSE: ActionPlan : InstallPreReqMocAndArb
    ActionPlanStatus: Completed
    
    InstanceID         : 00000000-0000-0000-0000-000000000000
    ActionPlanName     :
    Status             : Completed
    StartDateTime      : 5/22/2026 7:53:58 AM
    EndDateTime        : 5/22/2026 8:21:34 AM
    RemediationInstance:
    ```

1. Verify that the control-plane cluster group is online:

    ```powershell
    Get-ClusterGroup
    ```

    The following example shows the expected output.

    ```powershell
    Name                                                                      OwnerNode    State
    ----                                                                      ---------    -----
    00000000-0000-0000-0000-000000000000                                      Node01       Online
    000000000000000000000000000000000000000000000-control-plane-0-00000000    Node01       Online
    Available Storage                                                         Node01       Offline
    Azure Stack HCI Download Service Cluster Group                            Node02       Online
    Azure Stack HCI Health Service Cluster Group                              Node02       Online
    Azure Stack HCI Orchestrator Service Cluster Group                        Node01       Online
    Azure Stack HCI Update Service Cluster Group                              Node01       Online
    ca-00000000-0000-0000-0000-000000000000                                   Node02       Online
    Cloud Management                                                          Node01       Online
    Cluster Group                                                             Node02       Online
    IRVM01                                                                    Node01       Online
    SDDC Group                                                                Node01       Online
    ```

After the action plan completes successfully, the ARB, custom location, logical network, and storage resources are recreated on the restored cluster.

:::image type="content" source="media/disconnected-operations/back-up-restore/azure-resource-bridge-post-recreation.png" alt-text="Screenshot of the Arc Resource Bridge resource in the portal after recreation." lightbox="./media/disconnected-operations/back-up-restore/azure-resource-bridge-post-recreation.png":::

:::image type="content" source="media/disconnected-operations/back-up-restore/mgmt-cluster-post-full-recovery.png" alt-text="Screenshot of the portal showing the recovered management cluster." lightbox="./media/disconnected-operations/back-up-restore/mgmt-cluster-post-full-recovery.png":::

## Related content

- [Re-register the management or data cluster (created post backup) on a restored disconnected operations for Azure Local setup](disconnected-operations-post-restore-repair-register-management-cluster.md)
- [Restore for disconnected operations for Azure Local](disconnected-operations-restore.md)
- [Reconnect a data cluster after a disconnected operations restore](disconnected-operations-post-restore-reconnect-cluster.md)
- [Reconnect Azure Arc on cluster machines after a disconnected operations restore](disconnected-operations-post-restore-reconnect-arc.md)
- [Disconnected operations for Azure Local](/azure/azure-local/manage/disconnected-operations-overview?view=azloc-2602&preserve-view=true)

::: moniker-end

::: moniker range="<=azloc-2602"

This feature is available only in Azure Local 2603 or later.

::: moniker-end

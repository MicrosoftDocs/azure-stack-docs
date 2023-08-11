---
title: Validate deployment for Azure Stack HCI (preview)
description: Learn how to validate deployment for Azure Stack HCI (preview).
author: alkohli
ms.topic: how-to
ms.date: 11/18/2022
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Validate Azure Stack HCI deployment (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

Once your deployment has successfully completed, you should verify and validate your deployment.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Validate registration in Azure portal

The cluster registration completes before the deployment is complete. Follow these steps to validate that your cluster exists and is registered in Azure:


1. Establish a remote PowerShell session with the server node. Run PowerShell as administrator and run the following command:

    ```powershell
    Enter-PSSession -ComputerName <server_IP_address>  -Credential <username\password for the server> 
    ```

1. Get the information for the cluster you created:

    ```powershell
    Get-AzureStackHCI 
    ```

    Here is a sample output:

    ```powershell
    PS C:\Users\Administrator> Enter-PSSession -ComputerName 100.96.113.220 -Credential localhost\administrator 

    [100.96.113.220]: PS C:\Users\Administrator\Documents> Get-AzureStackHCI 

    ClusterStatus      : Clustered 
    RegistrationStatus : Registered 
    RegistrationDate   : 7/6/2022 1:01:02 AM 
    AzureResourceName  : cluster-c0bca4ca3d654d689c7b624732af3727 
    AzureResourceUri   : /Subscriptions/<Subscription ID>/resourceGroups/ASZRegistrationRG/providers/Microsoft.AzureStackHCI/clusters/cluster-c0bca4ca3d654d689c7b624732af3727

    ConnectionStatus   : Connected
    LastConnected      : 7/6/2022 2:00:02 PM
    IMDSAttestation    : Disabled
    DiagnosticLevel    : Basic

    [100.96.113.220]: PS C:\Users\Administrator\Documents>
    ```

1. Make a note of the `AzureResourceName` value. You'll need this to do a search in the Azure portal.

1. Sign in to the Azure portal. Make sure that you have used the appropriate Azure account ID and password.

1. In the Azure portal, search for the `AzureResourceName` value, then select the corresponding cluster resource.

1. On the **Overview** page for the cluster resource, view the **Server** information.  

    :::image type="content" source="media/deployment-tool/validate/validate-deployment.png" alt-text="Screenshot of Azure portal." lightbox="media/deployment-tool/validate/validate-deployment.png":::

## Validate deployment status

After the registration completes, more configuration is needed before the deployment is complete. Once the deployment is complete, remotely connect to the first server via PowerShell.

Follow these steps to verify that the deployment completed successfully:

1. Remotely connect to the first server via PowerShell.
1. Run the following command:

    ```powershell
    ([xml](gc C:\ecestore\efb61d70-47ed-8f44-5d63-bed6adc0fb0f\086a22e3-ef1a-7b3a-dc9d-f407953b0f84)) | Select-Xml -XPath "//Action/Steps/Step" | ForEach-Object { $_.Node } | Select-Object FullStepIndex, Status, Name, StartTimeUtc, EndTimeUtc, @{Name="Durration";Expression={new-timespan -Start $_.StartTimeUtc -End $_.EndTimeUtc } } | ft -AutoSize
    ```

    Here's a sample output of the above command:

    ```output
    [10.57.51.224]: PS C:\Users\SetupUser\Documents> ([xml](gc C:\ecestore\efb61d70-47ed-8f44-5d63-bed6adc0fb0f\086a22e3-ef1a-7b3a-dc9d-f407953b0f84)) | Select-Xml -XPath "//Action/Steps/Step" | ForEach-Object { $_.Node } | Select-Object FullStepIndex, Status, Name, StartTimeUtc, EndTimeUtc, @{Name="Durration";Expression={new-timespan -Start $_.StartTimeUtc -End $_.EndTimeUtc } } | ft -AutoSize

    FullStepIndex Status     Name                                                Start Time UTC                End Time UTC
    ------------- ------     ----                                                ------------                 ---
    0             InProgress Cloud Deployment                                    2022-09-27T17:23:45.364122Z
    0.1           Success    Before Cloud Deployment                             2022-09-27T17:23:54.7859298Z 202
    0.1.1         Success    Parallel per-node operation top step                2022-09-27T17:23:54.8328431Z 202
    0.1.1.1       Success    OS Configuration Customization                      2022-09-27T17:23:54.9734933Z 202
    0.1.1.1.10    Success    LiveUpdateWindowsFeatures                           2022-09-27T17:23:55.0827964Z 202
    0.1.1.1.20    Success    LiveUpdateRegistryKeys                              2022-09-27T17:24:32.6803406Z 202
    0.1.1.1       Success    OS Configuration Customization                      2022-09-27T17:23:54.8797181Z 202
    0.1.1.1.10    Success    LiveUpdateWindowsFeatures                           2022-09-27T17:23:55.0359952Z 202
    0.1.1.1.20    Success    LiveUpdateRegistryKeys                              2022-09-27T17:24:47.7428392Z 202
    0.1.2         Success    Restart the first server                            2022-09-27T17:25:05.7069186Z 202
    0.1.3         Success    EnvironmentValidatorFull                            2022-09-27T17:26:22.7187521Z 202
    0.1.3.0       Success    EnvironmentValidatorFull                            2022-09-27T17:26:22.7500568Z 202
    0.1.4         Success    Parallel per-node operation top step                2022-09-27T17:29:28.1542484Z 202
    0.1.4.1       Success    Expand Live Update Content                          2022-09-27T17:29:28.29485Z   202
    0.1.4.1       Success    Expand Live Update Content                          2022-09-27T17:29:28.2323781Z 202
    0.1.5         Success    EnableFirewallPortsOnAllHosts                       2022-09-27T17:33:04.3813397Z 202
    0.1.5.1       Success    Parallel per-node operation top step                2022-09-27T17:33:04.4594369Z 202
    0.1.5.1.1     Success    EnableFirewallPorts                                 2022-09-27T17:33:04.5375634Z 202
    0.1.5.1.1     Success    EnableFirewallPorts                                 2022-09-27T17:33:04.4906904Z 202
    0.1.6         Success    ResizeSystemDriveOnAllHosts                         2022-09-27T17:33:21.9039183Z 202
    0.1.6.1       Success    Parallel per-node operation top step                2022-09-27T17:33:21.9664168Z 202
    0.1.6.1.1     Success    ResizeSystemDrive                                   2022-09-27T17:33:22.0757452Z 202
    0.1.6.1.1     Success    ResizeSystemDrive                                   2022-09-27T17:33:22.0132493Z 202
    0.1.7         Success    AddDSCCertificateOnHost                             2022-09-27T17:33:45.8839415Z 202
    0.2           Success    Validate network settings for servers               2022-09-27T17:34:06.437572Z  202
    0.2.1         Success    ValidateEceHostNetworkSettings                      2022-09-27T17:34:06.5157117Z 202
    0.3           Success    Configure settings on servers                       2022-09-27T17:34:40.8861732Z 202
    0.3.1         Success    ConfigureAzureStackHostsPreConfig                   2022-09-27T17:34:40.9642929Z 202
    0.4           Success    AutoScale VirtualMachines                           2022-09-27T17:34:48.6407394Z 202
    0.5           Success    Configure network settings on servers               2022-09-27T17:34:48.8750632Z 202
    0.5.1         Success    Configure host networking requirements              2022-09-27T17:34:49.0469906Z 202
    0.6           Success    Apply security settings on servers                  2022-09-27T17:45:05.4738632Z 202
    0.6.1         Success    Parallel per-node operation top step                2022-09-27T17:45:05.5363183Z 202
    0.6.1.1       Success    Prepare SecurityBaseline Metadata                   2022-09-27T17:45:05.6301162Z 202
    0.6.1.2       Success    Enforce SecurityBaseline                            2022-09-27T17:45:12.0051044Z 202
    0.6.1.3       Success    Enforce SecuredCore                                 2022-09-27T17:45:28.1903232Z 202
    0.6.1.4       Success    Configure OSConfig DriftControl                     2022-09-27T17:45:33.5055734Z 202
    0.6.1.1       Success    Prepare SecurityBaseline Metadata                   2022-09-27T17:45:05.5988827Z 202
    0.6.1.2       Success    Enforce SecurityBaseline                            2022-09-27T17:45:13.8488529Z 202
    0.6.1.3       Success    Enforce SecuredCore                                 2022-09-27T17:45:35.8024458Z 202
    0.6.1.4       Success    Configure OSConfig DriftControl                     2022-09-27T17:45:43.1461885Z 202
    0.7           Success    Join servers to a domain                            2022-09-27T17:45:50.3301693Z 202
    0.7.1         Success    Deploy AD and domain join physical machines         2022-09-27T17:45:50.4082611Z 202
    0.7.1.1       Success    Add host to domain                                  2022-09-27T17:45:52.0801302Z 202
    0.8           Success    Setup Observability Resources                       2022-09-27T17:50:42.4434854Z 202
    0.8.0         Success    Register Observability EventSource                  2022-09-27T17:50:42.5372373Z 202
    0.8.1         Success    Setup Observability Volume                          2022-09-27T17:51:00.9850708Z 202
    0.8.2         Success    Create Observability Subfolders and Quotas          2022-09-27T17:52:27.9143979Z 202
    0.8.3         Success    Setup UTC Exporter Feature                          2022-09-27T17:52:48.8143452Z 202
    0.8.4         Success    Install VC Redistributable                          2022-09-27T17:53:11.2112825Z 202
    0.8.5         Success    Setup uptime scheduled task                         2022-09-27T17:53:26.8353426Z 202
    0.8.6         Success    Setup census event scheduled task                   2022-09-27T17:53:45.8745538Z 202
    0.8.7         Success    Setup registration events task                      2022-09-27T17:54:04.6852565Z 202
    0.9           Success    Deploy JEA endpoints on the host                    2022-09-27T17:54:23.5128828Z 202
    0.9.1         Success    Parallel per-node operation top step                2022-09-27T17:54:23.5910102Z 202
    0.9.1.1       Success    Update Baremetal JEA endpoints                      2022-09-27T17:54:23.809761Z  202
    0.9.1.2       Success    Update Baremetal JEA endpoints                      2022-09-27T17:54:35.4347618Z 202
    0.9.1.2.1     Success    Update Baremetal JEA endpoints                      2022-09-27T17:54:35.497264Z  202
    0.9.1.1       Success    Update Baremetal JEA endpoints                      2022-09-27T17:54:23.6535075Z 202
    0.9.1.2       Success    Update Baremetal JEA endpoints                      2022-09-27T17:54:40.5128884Z 202
    0.9.1.2.1     Success    Update Baremetal JEA endpoints                      2022-09-27T17:54:40.5597627Z 202
    0.10          Success    ConfigCluster                                       2022-09-27T17:58:04.5728561Z 202
    0.10.1        Success    ConfigCluster                                       2022-09-27T17:58:04.6353789Z 202
    0.11          Success    Configure cluster networking requirements           2022-09-27T18:00:47.4567973Z 202
    0.11.1        Success    Configure host networking requirements              2022-09-27T18:00:47.5036695Z 202
    0.12          Success    Register with Azure                                 2022-09-27T18:02:26.499692Z  202
    0.12.1        Success    RegisterStamptoAzure                                2022-09-27T18:02:26.5621888Z 202
    0.13          Success    ConfigStorage                                       2022-09-27T18:09:53.6289174Z 202
    0.13.1        Success    ConfigStorage                                       2022-09-27T18:09:53.7008911Z 202
    0.14          Success    EncryptCSVs                                         2022-09-27T18:14:46.9273156Z 202
    0.15          Success    EncryptHostsOSVolumes                               2022-09-27T18:15:28.1432709Z 202
    0.16          Success    MitigateForClusterGenericService                    2022-09-27T18:15:37.6342017Z 202
    0.17          Success    Set up certificates                                 2022-09-27T18:16:03.9038202Z 202
    0.17.0        Success    Install ASCA and Set Up External Certificates       2022-09-27T18:16:03.9662569Z 202
    0.17.0.0      Success    StageAndGenerateCertificates                        2022-09-27T18:16:07.2006186Z 202
    0.17.0.0.0    Success    Add lifecycle manager to certificate Readers group    2022-09-27T18:16:07.2474936Z 202
    0.17.0.0.1    Success    Generate certificates                               2022-09-27T18:16:13.932161Z  202
    0.17.0.0.2    Success    Remove lifecycle manager to certificate Readers group 2022-09-27T18:16:47.5523932Z 202
    0.17.0.0.3    Success    Publish artifacts                                   2022-09-27T18:16:50.7242697Z 202
    0.18          Success    VM Prerequisites                                    2022-09-27T18:16:58.3648937Z
    0.19          Success    Refresh Active Directory permissions
    0.20          Success    Deploy Agent Lifecycle Manager
    0.21          Success    Migrate deployment orchestrator service
    0.22          Success    Apply WDAC on hosts
    0.23          Success    CloudDeployment Expand
    0.24          Success    Clean up temporary content
    0.25          Success    Deploy the Network Controller service
    0.26          Success    Enable SMB Encryption
    0.27          Success    Apply security settings on infrastructure services
    0.28          Success    ScheduleTearDown
    
    
    [10.57.51.224]: PS C:\Users\SetupUser\Documents>    

    ```

## Validate cluster quorum settings

The cluster quorum should be configured to match the number of nodes in your cluster.  We recommend setting up a cluster witness for clusters with two, three, or four nodes. The witness helps the cluster determine which nodes have the most up-to-date cluster data if some nodes can't communicate with the rest of the cluster. For more details, see [Configure the cluster quorum](/windows-server/failover-clustering/manage-cluster-quorum#configure-the-cluster-quorum).

You can host the cluster witness on a file share located on another server. Follow these steps to create a file share witness:

1. Remotely connect via PowerShell to the first server of your Azure Stack HCI cluster.

1. To validate the cluster quorum configuration, run the following command:

    ```powershell
    Get-ClusterQuorum
    ```

## Next steps

- If needed, [troubleshoot deployment](deployment-tool-troubleshoot.md).

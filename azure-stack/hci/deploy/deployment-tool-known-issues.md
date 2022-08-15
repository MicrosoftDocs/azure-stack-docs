---
title: Known issues for Azure Stack HCI version 22H2
description: Read about the known issues for Azure Stack HCI version 22H2
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Known issues for Azure Stack HCI version 22H2

> Applies to: Azure Stack HCI, version 22H2 (preview)

Here are the known issues for Azure Stack HCI, version 22H2:

|#|Issue|Workaround|
|-|------|------|
|1|Failure in ECE – *Set-RoleDefinition: Cannot find the element ‘NodeDefinition’ for the role NC*|Make sure that a DVD is not inserted in the physical machine or mounted via the Baseboard Management Controller (BMC).|
|2|Only the first host (IP X.X.X.92) can be the staging server.|There is no workaround for this issue in this preview release.|
|3|Not all learn more links are functional in the deployment wizard.|The links will be functional in a future release.|
|4|Deployment is not running in foreground.|Monitor the progress using the log files stored in *C:\clouddeployment\logs* till the first reboot.|
|5|Add servers in the right order, beginning with the first server.|There is no workaround for this is in the preview release.|
|6|Error in Windows Admin Center - Remote Exception “GetCredential”with “1”|Reboot the staging server and run the bootstrap script again. Make sure that the Azure credentials for the subscription have not expired and are correct.|
|7|The DNS Server collected in Windows Admin Center is not visible in the answer file.|This is expected in this preview release as its not used for the orchestration. Only the DNS Forwarder is used in this release.|
|8|Step 20 – **VM Prerequisites** shows an error with “Block length does not match with its complement”|One or multiple nuget files got corrupted. Use the bootstrap script with the `ExtractOnly` parameter to get the corrupted nuget in question and copy (replace) it onto the staging server *C:\CloudDeployment\Nugetstore*. If that path does not exist, copy (replace) it onto the staging server *"C:\ClusterStorage\Infrastructure_2\Shares\SU1_Infrastructure_2\CloudMedia\NugetStore"*.|
|9|Renaming the network adapter in the deployment wizards and using the **Back** and **Next** buttons causes it to hang.|There is no workaround for this is in the preview release.|
|10|When deploying a VM attached to a virtual network with SDN enabled, it will not receive an IP address automatically.|When deployment is finished, you must run the following commands on each node using an administrator account:|
| | |1. `$VirtualSwitch=Get-VMSwitch`<br>2. `Enable-VmSwitchExtension -VMSwitchName $VirtualSwitch.Name -Name "Microsoft Azure VFP Switch Extension"`<br>3. `New-NetFirewallRule -Name "Firewall-REST" -DisplayName "Network Controller Host Agent REST" -Group "NcHostAgent" -Action Allow -Protocol TCP -LocalPort 80 -Direction Inbound -Enabled True`<br>4. `New-NetFirewallRule -Name "Firewall-OVSDB" -DisplayName "Network Controller Host Agent OVSDB" -Group "NcHostAgent" -Action Allow -Protocol TCP -LocalPort 6640 -Direction Inbound -Enabled True`<br>5. `New-NetFirewallRule -Name "Firewall-HostAgent-TCP-IN" -DisplayName "Network Controller Host Agent (TCP-In)" -Group "Network Controller Host Agent Firewall Group" -Action Allow -Protocol TCP -LocalPort Any -Direction Inbound -Enabled True`<br>6. `New-NetFirewallRule -Name "Firewall-HostAgent-WCF-TCP-IN" -DisplayName "Network Controller Host Agent WCF(TCP-In)" -Group "Network Controller Host Agent Firewall Group" -Action Allow -Protocol TCP -LocalPort 80 -Direction Inbound -Enabled True`<br>7. `New-NetFirewallRule -Name "Firewall-HostAgent-TLS-TCP-IN" -DisplayName "Network Controller Host Agent WCF over TLS (TCP-In)" -Group "Network Controller Host Agent Firewall Group" -Action Allow -Protocol TCP -LocalPort 443 -Direction Inbound -Enabled True`|
|11|Software Load Balancer and SDN gateway deployment through Windows Admin Center or SDN Express scripts will fail.|This is by design. These functionalities will be available in a later release.|
|12|In this release, there is an issue that could potentially result in the flow of non-personal data from EU to US regions.|While using the JSON config file to deploy a cluster,  we strongly recommend that you change the `Region` field value from **Redmond** to **""** to avoid any non-personal data redirection to US region. This issue will be fixed in the next upcoming release.|
|13|In this release, `Invoke-Command` does not work if you are signed in to the server as a local administrator.|This is a known issue and the workaround is to sign in using the domain administrator account.|

---
title: Troubleshoot Software Load Balancer (SLB) for SDN in Azure Stack HCI and Windows Server
description: Learn how to troubleshoot Software Load Balancer on Azure Stack HCI.
ms.topic: how-to
ms.author: v-mandhiman
author: ManikaDhiman
ms.date: 05/03/2023
---

# Troubleshoot Software Load Balancer for SDN

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019

If you've set up Software Load Balancer (SLB) for Software Defined Networking (SDN) and and your data path isn't working through SLB, there could be several reasons behind it. This article helps you identify and troubleshoot common issues in SLB for SDN.

For an overview of SLB and how to manage it, see [What is Software Load Balancer (SLB) for SDN?](../concepts/software-load-balancer.md) and [Manage Software Load Balancer for SDN](./load-balancers.md).

## Troubleshooting workflow

Here's the high-level workflow to troubleshoot SLB issues:

- Check the configuration state of the SLB Multiplexer VMs
- Troubleshoot common configuration state errors
- Collect SLB state dump

## Check the configuration state of the SLB Multiplexer VMs

If the SLB Multiplexer (MUX) reports any failure, you must first check the configuration state of the SLB MUX VMs. To do this, you can either use Windows Admin Center or PowerShell.

### [Windows Admin Center](#tab/windows-admin-center)

Follow these steps to check the configuration state of the SLB MUX through Windows Admin Center:

1. On the Windows Admin Center home screen, under **All connections**, select the cluster that you want to connect to.

1. Under **Tools**, scroll down to the **Networking** area, and select **SDN Infrastructure** and then **Load Balancer**.

If there are any issues with the Software Load Balancer, you'll see alerts on the Load Balancer page.

If the Status is showing Healthy, you can move on to Step 2. <!--what is step 2>

### [PowerShell](#tab/powershell)

To check the configuration state of the MUX through Powershell, run the following commands on any of the Network Controller VMs:

1. To get Network Controller application settings, run the following command. Note down the `RestName` parameter value.

    ```powershell
    Get-NetworkController
    ```

1. To assign the REST Uniform Resource Identifier (URI) to a parameter, run the following command:

    ```powershell
    $uri="https://<RestName>"
    ```

1. To retrieve the configuration of a load balancer VM managed by the Network Controller, run the following cmdlet:

    ```powershell
    (Get-NetworkControllerLoadBalancerMux -ConnectionUri $uri).Properties.ConfigurationState.DetailedInfo
    ```

## Troubleshoot common configuration state errors

This section describes the common configuration state errors of the SLB Multiplexer VMs.

### SLB MUX isn't connected to a BGP router

This happens when the MUX VMs couldn't establish Border Gateway Protocol (BGP) peering with the top of rack (ToR) switches. Note that MUX peers to ToR via BGP on port 179.

To resolve the MUX VMs and BGP router connection error:

- Ensure you have connectivity between the MUX VMs and the ToR switches. If you're using network virtualization, the peering should occur over the Hyper-
V Network Virtualization Provider Address (HNV PA) network.

- Check that the connection is established by running the following on the MUX VMs:

    ```powershell
    Netstat -anp tcp | findstr 179
    ```

    If there's no connection between MUX and ToR, check whether the ToR is reachable from MUX using `Test-NetConnection`. If MUX can't reach ToR, there's an issue with the underlying fabric network or ToR.

    ```powershell
    Test-NetConnection -ComputerName <TOR_IP> -Port 179 
    ```
    
    where:
    - TOR_IP is part of the loadBalancerMuxes resource.

The following is a snippet of the LoadBalancerMux resource, with the ToR IP
address as **192.168.200.1**:

```powershell
    Get-NetworkControllerLoadBalancerMux -ConnectionUri $uri|ConvertTo-Json -Depth 10 

    "peerRouterConfigurations": [ 
        { 
          "localIPAddress": "", 
          "routerName": "BGPGateway-64000-64001", 
          "routerIPAddress": "192.168.200.1", 
          "peerASN": 64001, 
          "id": "be5850aa-4dce-4203-a9f2-f3de25eaacba" 
        } 
```

- If you've multiple switches configured, ensure that all of them are peered with the MUX VMs.

- For further debugging related to failed BGP peering, run the `Test-SDNExpressBGP` script on any of the Azure Stack HCI host machines:

    ```powershell
    Install-Module test-sdnexpressbgp
    Test-SDNExpressBGP -RouterIPAddress 10.10.182.3 -LocalIPAddress 10.10.182.7 -LocalASN 64628 -verbose -ComputerName sa18n22mux02 -force
    ```

    where:
    - `RouterIPAddress` is ToR IP
    - `LocalIPAddress` is the PA IP address from the SLBMUX VM
    - `LocalASN` is the SDN SLB ASN
    - `ComputerName` is the name of the SLBMUX VM

The script stops the SLBMUX service on the MUX VM, tries to establish a connection, either failing or completing, and provides more details in case of failure.

### Virtual server is unreachable

This could be due to network errors or auth rejection at the virtual server. This usually indicates that the Network Controller isn't able to connect to the SLB MUX VMs.

To troubleshoot why virtual server isn't reachable, check that:

- There's connectivity between the Network Controller and the MUX VMs. To check the connectivity, run the following command:

    ```powershell
    Test-NetConnection -ComputerName <MUX IP address> -Port 8560
    ```

- The MUX service is running on the MUX VMs. To check this, run the following command from a Powershell session on the MUX VMs. The status must be Running.

    ```powershell
    Get-Service slbmux
    ```

- There're no firewall issues. Ensure that port 8560 isn't blocked by the firewall on the MUX VM. If the `Test-NetConnection` command above succeeds, it implies there's no firewall issue.

### Certificate not trusted or certificate not authorized

You can get this error if the certificate presented by the SLB MUX to the Network Controller has some issues.

1. To identify the certificate, run the following command on the MUX VMs:

    ```powershell
    $cert= get-childitem "cert:\localmachine\my"| where-object {$_.Subject.ToUpper() eq "CN=$NodeFQDN".ToUpper()} 
    ```

    where:

    - `NodeFQDN` is the FQDN of the MUX VM.

1. After identifying the certificate, check the following:

    1. To test the certificate, run the following command:

        ```powershell
        Test-Certificate $cert
        ```

    1. Ensure that the certificate is trusted by Network Controller VMs. If the certificate is a self-signed certificate, the same certificate must be present in the root store of all the Network Controller (NC) VMs. If the certificate is CA-signed, the CA certificate must be present in the root store of all the NC VMs. To list all the certificates in the root store of the NC VMs, run the following command on all the NC VMs:

    ```powershell
    get-childitem "cert:\localmachine\root"
    ```

### Policy configuration failure

This can manifest as *PolicyConfigurationFailureonHost, PolicyConfigurationFailureonMux, PolicyConfigurationFailureonVfp*, and
*PolicyConfigurationFailure*.

This error occurs when Network Controller can't push policies to the SLB MUX VMs or the Hyper-V hosts because of issues with reachability or certificate.

To troubleshoot the policy configuration failure error, first check if there's any reachability and certificate issues. See steps in the previous sections: [SLB MUX isn't connected to a BGP router](#slb-mux-isnt-connected-to-a-bgp-router), [Virtual server is unreachable](#virtual-server-is-unreachable), and [Certificate not trusted or certificate not authorized](#certificate-not-trusted-or-certificate-not-authorized).

If you didn't find any reachability and certificate issues, follow these steps to check connectivity between NC and the SLB MUX VMs and the SLB Host Agent on the host:

1. Check connection between NC and SLB MUX VMs. NC (SlbManager service) connects to MUX on port 8560. The connection is initiated by NC. Various virtual IP address (VIP) configurations, SNAT ports etc. are pushed via this connection.

To check connection between NC and SLB MUX, run `netstat` on SLB MUX VMs.

Here's a sample output of the command usage:

```output
    netstat -anp tcp | findstr 8560 
    TCP    0.0.0.0:8560           0.0.0.0:0              LISTENING 
    TCP    100.88.79.12:8560      100.88.79.9:59977      ESTABLISHED 
```

1. Check connection between NC and SLB host agent. The SLB host agent connects to NC (SlbManager service) on port 8571. Various SLB policies are pushed via this connection.

To check connectivity between NC and SLB host agent, run `netstat` on the SLB host.

Here's a sample output of the command usage:

```output
netstat -anp tcp | findstr 8571 

TCP    100.88.79.128:56258    100.88.79.9:8571       ESTABLISHED 
```

### Data path connectivity issues

You might get data path connectivity issues, even when the SLB MUX VMs are in a healthy configuration state. This implies that the SLB traffic is getting dropped somewhere along the way. To identify where the traffic is getting dropped, you need to collect data path traces. Before you do that, ensure the following:

- **The ToR switch can see the advertised VIPs**: As you already have set up a load balancer for load balancing, inbound NAT, outbound NAT or a combination of those, the load balancer VIP will be advertised to the ToR. Using the switch CLI, check if the VIP is getting advertised.

- **The SLBM VIP must not be blocked on the ToR or any physical firewalls**: This is the IP address specified as loadBalancerManagerIPAddress in the LoadBalancerManager/config resource of Network Controller. When the inbound packet comes in and MUX VM determines the correct backend IP to send the packet to, it sends the packet with the source IP address as the MUX SLBM VIP. We have seen customer cases where that is dropped on the ToR.

- **SLB Health probes are up**: If you have configured SLB health probes, ensure that at least one of the backend VMs is active, and is able to respond to the health probe. You can also get the state of the probes through the SLB state dump below.

- **Firewall inside the backend VM is not blocking traffic**: Ensure that host firewall in the backend VMs are not blocking incoming SLB traffic.

- **SDN Network Security Groups is not blocking traffic**: You may have some network security groups configured either directly on the backend NIC or on the subnet. Ensure that the network security group isn't blocking incoming SLB traffic.

    To check the network security groups through Powershell, run the following commands on a machine which can issue REST commands to the Network Controller:

    1. On the NIC, run the following command:

        ```powershell
        Get-NetworkControllerNetworkInterface –ConnectionUri <REST uri of Network Controller> -ResourceId <Resource ID of the backend NIC>|ConvertTo-Json –Depth 10
        ```

    1. On the virtual network subnet, run the following command:
    
        ```powershell
        Get-NetworkControllerVirtualNetwork –ConnectionUri <REST uri of Network Controller> -ResourceId <Resource ID of the network>|ConvertTo-Json –Depth 10 
        ```

    1. On the logical network subnet, run the following command:
    
        ```powershell
        Get-NetworkControllerLogicalNetwork –ConnectionUri <REST uri of Network Controller> -ResourceId <Resource ID of the network>|ConvertTo-Json –Depth 10 
        ```
    
    1. The output of the previous commands have a section for `AccessControlList`. You can check if any AccessControlList is attached to these resources. If yes, you can run the following command to verify the details of the `AccessControlList`:
    
        ```powershell
        Get-NetworkControllerAccessControlList –ConnectionUri <REST uri of Network Controller> - ResourceId <Resource ID of the AccessControlList>|ConvertTo-Json –Depth 10
        ```
    
    You can also find all this information through the Windows Admin Center extensions. <!--can we add the extension name here?-->

## Collect SLB state dump

Now, you can collect the SLB state dump and check for any errors. SLB state dump gives end-to-end information about all the VIPs. You can run the [DumpSlbRestState.ps1 script](https://github.com/microsoft/SDN/blob/master/Diagnostics/DumpSlbRestState.ps1) to collect the SLB state dump. The following section describes the various errors scenarios to check in the state dump.

### Check whether the MuxAdvertisedRoutes is empty or is missing the affected VIPs

Following is an example of the case where MuxAdvertisedRoutes is empty. This means that the MUX is not advertising any routes to the ToR. In this case all the VIPs will be down.

```output
 
    "name": "MuxRoutes", 
	"description": "Mux Routes", 
	"dataRetrievalFailed": false, 
	"dataUnits": [ 
   			{ 
   			"value": [ 

    "MuxAdvertisedRouteInfo: MuxId=3951dc43-4764-4c65-a4b5-35558c479ce6    MuxDipEndpoint=[172.24.47.12:8560] MuxAdvertisedRoutes=[]", 

    "MuxAdvertisedRouteInfo: MuxId=a150f826-6069-4da7-9771-642e80a45c8d MuxDipEndpoint=[172.24.47.13:8560] MuxAdvertisedRoutes=[]"
```

- If the routes are empty, the issue could be either MUX-TOR peering or
SLBM not pushing the correct goal state.
- In other cases, the routes will be missing only a few VIPs causing connectivity failure to only them. If this is the case, issue is with SLBM not pushing the goal state.

Mitigations: Move the primary of SlbManager service and ControllerService and restart the host agents.

- To move the primary of the SlbManager and ControllerService, on a Network Controller VM, run the following commands:

    1. To determine which node the Network Controller service modules use as primary, run the following command:

        ```powershell
            Get-NetworkControllerReplica
        ```

    1. Locate the NodeName for the SlbManagerService and ControllerService. Go to the respective nodes and run the following commands:

        ```powershell
            Get-Process Sdnctlr| Stop-Process and Get-Process SdnSlbm | Stop-Process
        ```

        This will restart the processes on a different Network Controller VM.

- To restart the host agents, on every Azure Stack HCI host, run the following command:

    ```powershell
       Restart-Service nchostagent --force
       Start-Service slbhostagent
    ```

### Check programming and connectivity state for VipAddress

This section of the slbstate dump provides detailed information about the VIP. It provides the state of the VIP on SLBM, MUX and Hosts. Under the host, it dumps all the dips which are currently part of the VIP. Make sure the list is consistent with the configuration. If the issue is with outbound connections, check the SNAT configurations and make sure the port allocations between the MUXes and the Host is consistent.

```output
    "name": "192.168.102.1", 
    "value": [ 
    "Programming and Connectivity state for VipAddress: 192.168.102.1", 
```

### Collect data path traces

If none of the above methods provide a resolution, collect data path logs and send to Microsoft. Collect the following logs:

- **NC Data collection logs.** For information on how to collect SDN logs, see [Collect Software Defined Networking logs](sdn-log-collection.md).

The following logs should be collected only for a short duration. Start the logging, reproduce the scenario, and then stop the logging.

- **MUX traces.** These traces must be collected on the MUX VMs. Follow these steps to collect traces:

    1. To start logging, run the following command:
        
        ```powershell
        netsh trace start tracefile=c:\mux.etl globallevel=5 provider=`{645b8679-5451-4c36-9857-a90e7dbf97bc`} provider=`{6C2350F8-F827-4B74-AD0C-714A92E22576`} ov=yes report=disabled
        ```
    
    1. Reproduce scenario.

    1. To stop logging, run the following command:
        
        ```powershell
        netsh trace stop
        ```
    
    1.  To convert the trace file in ETL format into the specified format, run the following command:
        
        ```powershell
        netsh trace convert input=<trace file> ov=yes
        ```

- **SLB host agent traces.** These traces must be collected on the Azure Stack HCI hosts. Follow these steps to collect traces:

    1. To start logging, run the following command:
    
        ```powershell
        netsh trace start tracefile=c:\slbHA.etl globallevel=5 provider=`{2380c5ee-ab89-4d14-b2e6-142200cb703c`} ov=yes report=disabled
        ```    

    1. Reproduce scenario.

    1. To stop logging, run the following command:
        
        ```powershell
        netsh trace stop
        ```

    1. To convert the trace file in ETL format into the specified format, run the following command:
        
        ```powershell
        netsh trace convert input=<trace file> ov=yes
        ```

- **VFP traces.** These traces must be collected on the Azure Stack HCI hosts where the MUX VM and the tenant VMs are present. Follow these steps to collect traces:

    1. To start logging, run the following command:
    
        ```powershell
        Netsh trace start scenario=virtualization  capture=yes capturetype=both tracefile=vfp.etl ov=yes report=di
        ```

    1. Reproduce scenario.

    1. To stop logging, run the following command:
        
        ```powershell
        netsh trace stop
        ```

    1. To convert the trace file in ETL format into the specified format, run the following command:
        
        ```powershell
        netsh trace convert input=<trace file> ov=yes
        ```

## Next steps

- [Contact Microsoft Support](get-support.md)
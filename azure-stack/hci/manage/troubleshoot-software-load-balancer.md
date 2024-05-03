---
title: Troubleshoot Software Load Balancer (SLB) for SDN in Azure Stack HCI and Windows Server
description: Learn how to troubleshoot Software Load Balancer for SDN in Azure Stack HCI and Windows Server.
ms.topic: how-to
ms.author: sethm
author: sethmanheim
ms.date: 04/12/2024
---

# Troubleshoot Software Load Balancer for SDN

> Applies to: Azure Stack HCI, versions 23H2 and 22H2; Windows Server 2022, Windows Server 2019

If you've set up Software Load Balancer (SLB) for Software Defined Networking (SDN) and your data path isn't working through SLB, there could be several reasons behind it. This article helps you identify and troubleshoot some common issues in SLB for SDN.

For an overview of SLB and how to manage it, see [What is Software Load Balancer (SLB) for SDN?](../concepts/software-load-balancer.md) and [Manage Software Load Balancer for SDN](./load-balancers.md).

## Troubleshooting workflow

Here's the high-level workflow to troubleshoot SLB issues:

- Check the configuration state of the SLB Multiplexer (MUX) VMs
- Troubleshoot common configuration state errors
- Collect SLB state dump

## Check the configuration state of the SLB Multiplexer VMs

You must first check the configuration state of the SLB MUX VMs. To do this, you can either use Windows Admin Center or PowerShell.

### [Windows Admin Center](#tab/windows-admin-center)

Follow these steps to check the configuration state of the SLB MUX through Windows Admin Center:

1. On the Windows Admin Center home screen, under **All connections**, select the cluster that you want to connect to.

1. Under **Tools**, scroll down to the **Networking** area. Select **SDN Infrastructure** and then select **Summary**. If there are issues with SLB, you'll see it in the **Load Balancers MUX** section. If there are no issues, all the MUX VMs are in the **Healthy** state.

    :::image type="content" source="./media/troubleshoot-software-load-balancer/software-load-balancer-multiplexer-state.png" alt-text="Screenshot of the SDN Infrastructure page in Windows Admin center that shows the state of Load Balancers MUX." lightbox="./media/troubleshoot-software-load-balancer/software-load-balancer-multiplexer-state.png":::

### [PowerShell](#tab/powershell)

To check the configuration state of the MUX through PowerShell, run the following commands on any of the Network Controller VMs:

1. To get the Network Controller application settings, run the following command. From the output, note down the `RestName` parameter value.

    ```powershell
    Get-NetworkController
    ```

1. To assign the REST Uniform Resource Identifier (URI) to a parameter, run the following command:

    ```powershell
    $uri="https://<RestName>"
    ```

1. To retrieve the configuration state of the SLB MUX VM managed by the Network Controller, run the following cmdlet:

    ```powershell
    (Get-NetworkControllerLoadBalancerMux -ConnectionUri $uri).Properties.ConfigurationState.DetailedInfo
    ```

    Here's a sample output of the command usage:

    ```output
    (Get-NetworkControllerLoadBalancerMux -ConnectionUri $uri).Properties.ConfigurationState.DetailedInfo

    Source                      Message                      Code
    ------                      -------                      ----
    SoftwareLoadBalancerManager Loadbalancer Mux is Healthy. Success
    SoftwareLoadBalancerManager Loadbalancer Mux is Healthy. Success
    ```

---

## Troubleshoot common configuration state errors

This section describes how to troubleshoot common errors if the configuration state of the SLB MUX VMs isn't healthy.

### SLB MUX isn't connected to a BGP router

This error occurs when the MUX VMs couldn't establish Border Gateway Protocol (BGP) peering with the top of rack (ToR) switches. Keep in mind that MUX peers to ToR via BGP on port 179.

To resolve the MUX VMs and BGP router connection error:

- Ensure that you have connectivity between the MUX VMs and the ToR switches. If you're using network virtualization, the peering should occur over the Hyper-V Network Virtualization Provider Address (HNV PA) network.

- Check that the connection is established by running the following on the MUX VMs:

    ```powershell
    Netstat -anp tcp | findstr 179
    ```

    If there's no connection between MUX and ToR, check whether the ToR is reachable from MUX using `Test-NetConnection`. If MUX can't reach ToR, there's an issue with the underlying fabric network or ToR.

    ```powershell
    Test-NetConnection -ComputerName <ToR_IP> -Port 179 
    ```
    
    where:

    - ToR_IP is part of the loadBalancerMuxes resource.

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

- If you have multiple switches configured, ensure that all of them are peered with the MUX VMs.

- For further debugging related to failed BGP peering, run the `Test-SDNExpressBGP` script on any of the physical hosts:

    ```powershell
    Install-Module test-sdnexpressbgp
    Test-SDNExpressBGP -RouterIPAddress 10.10.182.3 -LocalIPAddress 10.10.182.7 -LocalASN 64628 -verbose -ComputerName sa18n22mux02 -force
    ```

    where:

    - `RouterIPAddress` is ToR IP
    - `LocalIPAddress` is the PA IP address from the SLBMUX VM
    - `LocalASN` is the SDN SLB ASN
    - `ComputerName` is the name of the SLBMUX VM

    The script stops the SLBMUX service on the MUX VM, tries to establish a connection, either failing or completing, and provides more details if there's a failure.

### Virtual server is unreachable

You can get this error due to network errors or auth rejection at the virtual server. This usually indicates that the Network Controller can't connect to the SLB MUX VMs.

To troubleshoot why the virtual server isn't reachable, check that:

- There's connectivity between the Network Controller and the MUX VMs. To check the connectivity, run the following command:

    ```powershell
    Test-NetConnection -ComputerName <MUX IP address> -Port 8560
    ```

- The MUX service is running on the MUX VMs. To check this, run the following command from a PowerShell session on the MUX VMs. The status must be Running.

    ```powershell
    Get-Service slbmux
    ```

- There are no firewall issues. Ensure that port 8560 isn't blocked by the firewall on the MUX VM. If the `Test-NetConnection` command succeeds, it implies there's no firewall issue.

### Certificate not trusted or certificate not authorized

You can get this error if the certificate presented by the SLB MUX to the Network Controller has some issues.

1. To identify the certificate, run the following command on the MUX VMs:

    ```powershell
    $cert= get-childitem "cert:\localmachine\my"| where-object {$_.Subject.ToUpper() eq "CN=$NodeFQDN".ToUpper()} 
    ```

    where:

    - `NodeFQDN` is the FQDN of the MUX VM.

1. After identifying the certificate, check the certificate:

    1. To test the certificate, run the following command:

        ```powershell
        Test-Certificate $cert
        ```

    1. Ensure that the certificate is trusted by the Network Controller VMs. If the certificate is a self-signed certificate, the same certificate must be present in the root store of all the Network Controller VMs. If the certificate is CA-signed, the CA certificate must be present in the root store of all the Network Controller VMs. To list all the certificates in the root store of the Network Controller VMs, run the following command on all the Network Controller VMs:

        ```powershell
        get-childitem "cert:\localmachine\root"
        ```

### Policy configuration failure

This error can manifest as one of these: *PolicyConfigurationFailureonHost, PolicyConfigurationFailureonMux, PolicyConfigurationFailureonVfp*, or
*PolicyConfigurationFailure*.

This error occurs when the Network Controller can't push policies to the SLB MUX VMs or the Hyper-V hosts either due to reachability or certificate issues, or any other issue.

To troubleshoot the policy configuration failure error, first check if there's any reachability and certificate issues. See steps in the previous sections: [SLB MUX isn't connected to a BGP router](#slb-mux-isnt-connected-to-a-bgp-router), [Virtual server is unreachable](#virtual-server-is-unreachable), and [Certificate not trusted or certificate not authorized](#certificate-not-trusted-or-certificate-not-authorized).

If there isn't any reachability and certificate issue, perform the following steps to check connectivity between the Network Controller and the SLB MUX VMs and the SLB host agent on the host:

1. Check connection between the Network Controller and SLB MUX VMs. Keep in mind that the Network Controller (SlbManager service) connects to MUX on port 8560. The Network Controller initiates the connection. Various virtual IP address (VIP) configurations, Source Network Address Translation (SNAT) ports etc. are pushed via this connection.

    To check connection between the Network Controller and SLB MUX, run `netstat` on SLB MUX VMs.

    Here's a sample output of the command usage:

    ```output
    netstat -anp tcp | findstr 8560 
    TCP    0.0.0.0:8560           0.0.0.0:0              LISTENING 
    TCP    100.88.79.12:8560      100.88.79.9:59977      ESTABLISHED 
    ```

1. Check connection between the Network Controller and SLB host agent. Keep in mind that the SLB host agent connects to the Network Controller (SlbManager service) on port 8571. Various SLB policies are pushed via this connection.

    To check connectivity between the Network Controller and SLB host agent, run `netstat` on the physical host.

    Here's a sample output of the command usage:

    ```output
    netstat -anp tcp | findstr 8571 
    TCP    100.88.79.128:56258    100.88.79.9:8571       ESTABLISHED 
    ```

### Data path connectivity issues

You might get data path connectivity issues, even when the SLB MUX VMs are in a healthy configuration state. This implies that the SLB traffic is getting dropped somewhere along the way. To identify where the traffic is getting dropped, you need to collect data path traces. Before you do that, ensure the following:

- **The ToR switch can see the advertised VIPs.** As you've set up a load balancer for load balancing, inbound NAT, outbound NAT or a combination of those, the load balancer VIP is advertised to the ToR. Using the switch CLI, check if the VIP is getting advertised. <!--can we describe how to check this?-->

- **The SLBM VIP must not be blocked on the ToR or any physical firewalls.** This is the IP address specified as loadBalancerManagerIPAddress in the LoadBalancerManager/config resource of the Network Controller. When the inbound packet comes in and MUX VM determines the correct backend IP to send the packet to, it sends the packet with the source IP address as the MUX SLBM VIP. There can be scenarios where that is dropped on the ToR.

- **SLB Health probes are up.** If you've configured SLB health probes, ensure that at least one of the backend VMs is active, and is able to respond to the health probe. You can also get the state of the probes through the [SLB state dump](#collect-slb-state-dump), as described later in this article.

- **Firewall inside the backend VM isn't blocking traffic.** Ensure that host firewall in the backend VMs isn't blocking incoming SLB traffic.

- **SDN Network Security Groups isn't blocking traffic.** You may have some network security groups configured either directly on the backend NIC or on the subnet. Ensure that the network security group isn't blocking incoming SLB traffic.

    1. To check the network security groups through PowerShell, run the following commands on a machine, which can issue REST commands to the Network Controller:

        - To get the details of NetworkInterface resource, run the following command:

            ```powershell
            Get-NetworkControllerNetworkInterface –ConnectionUri <REST uri of Network Controller> -ResourceId <Resource ID of the backend NIC>|ConvertTo-Json –Depth 10
            ```

        - To get the details of VirtualNetworkSubnet resource, run the following command:
    
            ```powershell
            Get-NetworkControllerVirtualNetwork –ConnectionUri <REST uri of Network Controller> -ResourceId <Resource ID of the network>|ConvertTo-Json –Depth 10 
            ```

        - To get the details of LogicalNetworkSubnet resource, run the following command:
    
            ```powershell
            Get-NetworkControllerLogicalNetwork –ConnectionUri <REST uri of Network Controller> -ResourceId <Resource ID of the network>|ConvertTo-Json –Depth 10 
            ```
    
    1. The output from the previous commands has a section for `AccessControlList`. You can check if any `AccessControlList` is attached to these resources. If yes, you can run the following command to verify the details of the `AccessControlList` to check if the `AccessControlList` is blocking any SLB traffic:
    
        ```powershell
        Get-NetworkControllerAccessControlList –ConnectionUri <REST uri of Network Controller> - ResourceId <Resource ID of the AccessControlList>|ConvertTo-Json –Depth 10
        ```
    
    You can also find all this information by using the following Windows Admin Center extensions:

    - **Logical Networks** for logical network details
    - **Virtual Networks** for virtual network details
    - **Network Security Groups** for ACL details

## Collect SLB state dump

If necessary, you can create an SLB state dump and check for any errors. Additionally, you can share the state dump with Microsoft for advanced troubleshooting purposes. SLB state dump gives end-to-end information about all the VIPs. You can run the [DumpSlbRestState.ps1 script](https://github.com/microsoft/SDN/blob/master/Diagnostics/DumpSlbRestState.ps1) to collect the SLB state dump. The following section describes the various errors scenarios that you can check in the state dump.

### Check whether the MuxAdvertisedRoutes is empty or is missing the affected VIPs

Following is an example where `MuxAdvertisedRoutes` is empty. This means that the MUX isn't advertising any routes to the ToR. In this case, all the VIPs are down.

```output
"name": "MuxRoutes", 
"description": "Mux Routes", 
"dataRetrievalFailed": false, 
"dataUnits": [ 
		{ 
		"value": [ 

"MuxAdvertisedRouteInfo: MuxId=3951dc43-4764-4c65-a4b5-35558c479ce6 MuxDipEndpoint=[172.24.47.12:8560] MuxAdvertisedRoutes=[]", 

"MuxAdvertisedRouteInfo: MuxId=a150f826-6069-4da7-9771-642e80a45c8d MuxDipEndpoint=[172.24.47.13:8560] MuxAdvertisedRoutes=[]"
```

- If the routes are empty, the issue could be either MUX-ToR peering or SLBM not pushing the correct goal state.

- In other cases, the routes are missing only a few VIPs causing connectivity failure to only them. If so, issue is with SLBM not pushing the goal state.

**Mitigation**

Move the primary of SlbManager service and ControllerService and restart the host agents.

- To move the primary of the SlbManager and ControllerService, on a Network Controller VM, run the following commands:

    1. To determine which node the Network Controller service modules use as primary, run the following command:

        ```powershell
        Get-NetworkControllerReplica
        ```

    1. Locate the NodeName for the SlbManagerService and ControllerService. Go to the respective nodes and run the following command:

        ```powershell
        Get-Process Sdnctlr| Stop-Process and Get-Process SdnSlbm | Stop-Process
        ```

        This restarts the processes on a different Network Controller VM.

- To restart the host agents, on every physical host, run the following command:

    ```powershell
    Restart-Service nchostagent --force
    Start-Service slbhostagent
    ```

### Check programming and connectivity state for VipAddress

This section of the SLB state dump provides detailed information about the VIP. It provides the state of the VIP on SLBM, MUX, and hosts. Under the host, it dumps all the dips that are currently part of the VIP. Make sure the list is consistent with the configuration. If the issue is with outbound connections, check the SNAT configurations and make sure the port allocations between the MUXes and the host is consistent.

```output
"name": "192.168.102.1", 
"value": [ 
"Programming and Connectivity state for VipAddress: 192.168.102.1", 
```

### Collect data path traces

If none of the previous methods provide a resolution, collect data path logs and send to Microsoft.

Collect the following logs:

- **Network Controller Data collection logs.** For information on how to collect SDN logs, see [Collect Software Defined Networking logs](sdn-log-collection.md).

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

- **SLB host agent traces.** These traces must be collected on the physical hosts. Follow these steps to collect traces:

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

- **VFP traces.** These traces must be collected on the physical hosts where the MUX VM and the tenant VMs are present. Follow these steps to collect traces:

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
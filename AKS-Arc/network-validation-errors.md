---
title: Troubleshoot network validation errors
description: Learn how to troubleshoot general network validation errors in AKS Arc.
author: sethmanheim
ms.author: sethm
ms.topic: troubleshooting
ms.date: 05/07/2025
ms.reviewer: pradwivedi
ms.lastreviewed: 05/06/2025

---

# Troubleshoot network validation errors

This article describes how to identify and resolve various network validation errors you might encounter during cluster creation. The article emphasizes the importance of pre-checks for early issue detection. These errors are detected by pre-checks designed to highlight issues early, allowing for easier resolution before the cluster is created.

The article summarizes error codes, their potential causes, and actionable mitigation steps to help you resolve issues effectively.

## CloudAgentConnectivityError

Error: Network validation failed during cluster creation.

### Description

Detailed message: `Not able to connect to http://cloudagent.contoso.local:50000. Error returned: action failed after 5 attempts: Get "http://cloudagent.contoso.local:50000": dial tcp: lookup http://cloudagent.contoso.local: Temporary failure in name resolution`

The MOC cloud agent is created using one of the IP addresses from the [Management IP pool](/azure/azure-local/plan/cloud-deployment-network-considerations#management-ip-pool) on port 5500 and the control plane node VM is given IP addresses from the Arc VM logical network. This error occurs when the MOC cloud agent is not reachable from the control plane VM, or when the DNS servers specified in the Arc VM logical network are unable to resolve the MOC cloud agent FQDN.

### Causes of failure

Logical network IP addresses can't connect to management IP pool addresses, due to:

- Incorrect DNS server resolution.
- Firewall rules between the Arc VM logical network and the cloud agent endpoint.
- The logical network is in a different VLAN than the management IP pool and there's no cross-VLAN connectivity.

### Mitigation

To resolve this error, you can take the following steps:

- Make sure that the DNS servers specified in the Arc VM logical network can resolve the MOC cloud agent FQDN.
- Make sure that the logical network IP addresses can connect to all the management IP pool addresses on the required ports. For a detailed list of ports that need to be opened, see [AKS network port and cross-VLAN requirements](aks-hci-network-system-requirements.md#network-port-and-cross-vlan-requirements).

## InternetConnectivityError

Error: Network validation failed during cluster creation.

### Description

Detailed message: `Not able to connect to https://mcr.microsoft.com. Error returned: action failed after 5 attempts: Get "https://mcr.microsoft.com": dial tcp: lookup mcr.microsoft.com on <>: read udp <>: i/o timeout`.

This error indicates that the required URLs are not reachable from the AKS cluster control plane node VM.

### Causes of failure

- Control plane node VM has no outbound internet access.
- Required URLs aren't allowed through the firewall.

### Mitigation

To resolve this error, ensure that the logical network IP addresses have outbound internet access. If there's a firewall, ensure that the [AKS required URLs](aks-hci-network-system-requirements.md#firewall-url-exceptions) are accessible from the Arc VM logical network.

## VMNotReachableError

Error: Network validation failed during cluster creation.

### Description

Detailed message: `VM IP : <> is not reachable from management cluster`.

This error indicates that the AKS cluster control plane VM is not reachable from the Arc Resource Bridge (ARB).

### Causes of failure

The Arc VM logical network is not reachable from management IP pool addresses.

### Mitigation

To resolve this error, you can take the following steps:

- Make sure that the management IP pool addresses can reach the logical network IP addresses.
- For a detailed list of ports that need to be opened, see [AKS network port and cross-VLAN requirements](aks-hci-network-system-requirements.md#network-port-and-cross-vlan-requirements).

## DNSResolutionError

This error occurs when DNS servers specified in the Arc VM logical network can't resolve the MOC cloud FQDN or the required URLs.

### Causes of failure

DNS servers specified in a logical network can't resolve the MOC cloud FQDN or the required URLs.

### Mitigation

To resolve this error, check the DNS servers specified in the logical network so that they can resolve the MOC cloud FQDN or the required URLs.

## Contact Microsoft Support

If problems persist, [collect AKS cluster logs](get-on-demand-logs.md) before you [create a support request](aks-troubleshoot.md#open-a-support-request).

## Next steps

[Troubleshoot issues in AKS enabled by Azure Arc](aks-troubleshoot.md)

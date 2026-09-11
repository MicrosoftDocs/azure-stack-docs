---
author: ronmiab
ms.author: robess
ms.service: azure-local
ms.topic: include
ms.date: 08/31/2026
---

4. Enter the following additional details:

   1. Select a time zone.
   1. Specify an NTP server or accept the default value, **time.windows.com**. Optionally, add an alternate NTP server.
   1. Enable Remote Desktop if required. Remote Desktop is disabled by default.
   1. Under **Connectivity**, select the option that uses a proxy server.
   1. Enter the proxy server URL.
   1. Configure the proxy bypass list. Observe the following requirements:

      - Include the IP address and NetBIOS name of each Azure Local machine.
      - Include the IP address and NetBIOS name of the Azure Local cluster.
      - Include the IP addresses that you defined for the infrastructure network, or bypass the entire infrastructure subnet. Arc resource bridge, Azure Kubernetes Service (AKS), and future infrastructure services that use these addresses require outbound connectivity.
      - Separate entries with commas.
      - To bypass a subnet, use a wildcard pattern such as `192.168.1.*`. Classless Inter-Domain Routing (CIDR) notation isn't supported.
      - To bypass a domain and its subdomains, use a wildcard pattern such as `*.contoso.com`.
      - Don't use `<local>` in the proxy bypass list.

   1. Specify a hostname for the machine. Changing the hostname automatically restarts the machine.
   1. When you finish configuring the machine settings, continue to **Arc agent setup**.

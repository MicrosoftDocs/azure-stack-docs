---
author: sipastak
ms.author: sipastak
ms.service: azure-local
ms.topic: include
ms.date: 04/14/2025
ms.reviewer: sipastak
---

### Prepare target Azure Local instance and logical network

On the target Azure Local instance, provision a static Azure Arc logical network to support the migration. This setup requires defining the following:

- IP address space
- Gateway address
- DNS servers
- an IP pool range (optional)

For detailed guidance on creating and configuring static or dynamic Azure Arc logical networks, see [Create logical networks for Azure Local](../manage/create-logical-networks.md?tabs=azurecli).

Ensure that the static IP addresses you plan to migrate are available in the static logical network and not assigned to another VM. If an IP address is already in use, the migration fails with the error: **The address is already in use.** To avoid this:

1. Go to the target static logical network.
1. Check which IP addresses are in use.
1. Remove any NICs assigned to the static IPs you want to migrate.

:::image type="content" source="../migrate/media/migrate-maintain-ip-addresses/connected-devices.png" alt-text="Screenshot of Connected Devices page.":::
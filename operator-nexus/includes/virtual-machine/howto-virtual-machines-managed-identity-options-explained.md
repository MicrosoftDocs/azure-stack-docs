---
ms.date: 10/23/2025
ms.author: omarrivera
author: g0r1v3r4
ms.topic: include
ms.service: azure-operator-nexus
---

## Choose a managed identity option

You can use either a system-assigned or a user-assigned managed identity to associate with the virtual machine (VM).
Choose the option that best fits your requirements.

For more information about creating and managing managed identities and role assignments, see the relevant documentation:

- [Manage user-assigned managed identities using the Azure portal](/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities)
- [Configure managed identities for Azure resources on a VM](/entra/identity/managed-identities-azure-resources/how-to-configure-managed-identities)

### Using a system-assigned managed identity

The system-assigned managed identity is created automatically when the VM is created.
The lifecycle of the system-assigned managed identity is tied to the VM.
However, it's necessary to assign roles to the system-assigned managed identity after the VM is created.
You can grant the required roles to the system-assigned managed identity after the VM is created either manually or using Azure CLI.
The role assignments can be automated by embedding the az CLI commands in the cloud-init userData script; remember that cloud-init runs only once on the first boot.

### Using a user-assigned managed identity

If you plan to use a user-assigned managed identity, create it before creating the virtual machine.
Since the user-assigned managed identity is independent of the VM, you can assign the necessary roles ahead of time.
Assigning the roles ahead of time simplifies the process as the VM can use the identity during the user data cloud-init script execution.

### Assign roles to the managed identity

You must assign the necessary roles to the managed identity to fit your requirements.
Role assignments can be done at the subscription or resource group level depending on your requirements.

For more information about role assignments or creating custom roles for specific permissions, see:

- [Assign Azure roles using Azure CLI](/azure/role-based-access-control/role-assignments-cli)
- [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal)
- [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity)
- [Create or update Azure custom roles using an ARM template](/azure/role-based-access-control/custom-roles-template)
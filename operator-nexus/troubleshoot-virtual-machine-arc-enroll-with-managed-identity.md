---
title: Troubleshoot issues with virtual machine Arc enrollment using managed identities
description: This article offers step-by-step troubleshooting guidance for resolving issues when enrolling virtual machines with managed identities in Azure Arc.
ms.service: azure-operator-nexus
ms.custom: azure-operator-nexus
ms.topic: troubleshooting
ms.date: 09/30/2025
ms.author: omarrivera
author: g0r1v3r4
---

# Troubleshoot Nexus virtual machines using managed identities

Use this article to troubleshoot common problems encountered when enrolling Azure Operator Nexus virtual machines (VM) with Azure Arc using managed identities associated with the VM.

In order to effectively troubleshoot issues, it's important to understand the key components involved in the authentication and enrollment process.
The process relies on platform level components that facilitate communication between the VM and Azure services.

## Feature support versions

- Ensure that your Nexus Cluster is running Azure Local Nexus `2510.1` Management Bundle and `4.7.0` Minor Runtime or later.
- The feature support is available in API version `2025-07-01-preview` or later.
- Make sure the [`networkcloud` extension] is installed with a version that supports the required API version.
  You can find supported versions in the [`networkcloud` extension release history] on GitHub.

[`networkcloud` extension]: /cli/azure/networkcloud
[`networkcloud` extension release history]: https://github.com/Azure/azure-cli-extensions/blob/main/src/networkcloud/HISTORY.rst

## Examine the cloud-init logs

If you are using the `--user-data-content` parameter to pass a cloud-init script during VM creation, you can check the cloud-init logs for errors or issues related to the execution of the script.

> [!NOTE]
> The `--user-data` parameter is deprecated and will be removed in a future release.
> Verify in the [`networkcloud` extension release history] for the latest updates.

A cloud-init script is a widely used approach for customizing VMs during their first boot:

- Executes scripts and configurations during VM initialization
- Handles user creation, package installation, and service configuration
- Logs activities to `/var/log/cloud-init-output.log`

## Nexus VM Instance Metadata Service (IMDS) sidecar container and required proxy settings

As part of the Nexus VM deployment, an IMDS sidecar container is deployed alongside the VM.
This sidecar container is responsible for proxying requests to the platform level token service.
Nexus VMs are configured to route traffic meant for the IP address `169.254.169.254` to the IMDS sidecar container.
For this reason, the IP address `169.254.169.254` must be added to the `NO_PROXY` environment variable.

## Cloud Services Network (CSN) configuration and tenant proxy settings

Ensure that your cloud services network (CSN) is configured to allow egress traffic to the necessary Azure endpoints.

## Common error messages and solutions

### Failed to login with managed identity

Example error messages:

```
ERROR: Failed to login with system-assigned managed identity

# OR

ERROR: Failed to login with user-assigned managed identity
```

Possible causes:

- System-assigned managed identity is not enabled on the VM
- User-assigned managed identity is not properly assigned to the VM
- Identity permissions issues
- IMDS endpoint is not accessible
- Network connectivity issues

1. Verify the VM was created with an associated managed identity.
   If the VM was not created with an associated managed identity, you must recreate the VM with one to use managed identity authentication.
   See [Nexus VM with associated managed identities at creation time](./howto-arc-enroll-virtual-machine-using-managed-identities#nexus-vm-with-associated-managed-identities-at-creation-time) for more information.

```azurecli-interactive
az networkcloud virtualmachine show --name "$VM_NAME" --resource-group "$RESOURCE_GROUP" --query "identity"
```

1. Check IMDS connectivity from within the VM.
   SSH into the VM and run the following commands:

   ```bash
   export NO_PROXY=169.254.169.254

   # Basic connectivity test
   ping -c 3 169.254.169.254

   # Test IMDS sidecar container is accessible and running
   curl -v -H "Metadata:true" "http://169.254.169.254/healthz"
   ```

   If the IMDS endpoint is not accessible, there could be a network connectivity issue or the IMDS sidecar container may not be running.

### Failed to retrieve access token

Example error message:

```
ERROR: Failed to retrieve access token
```

Possible causes:

- Managed identity is not associated with the VM
- Managed identity permissions are insufficient
- Network connectivity to Azure endpoints is blocked
- Token request timeout

1. Verify managed identity has appropriate permissions.

   See the [Assign roles to the managed identity](./howto-arc-enroll-virtual-machine-using-managed-identities#assign-roles-to-the-managed-identity) for more details.
   ```bash
   # For system-assigned identity
   az role assignment list \
       --assignee $(az networkcloud virtualmachine show --name "$VM_NAME" --resource-group "$RESOURCE_GROUP" --query "identity.principalId" -o tsv)

   # For user-assigned identity
   az role assignment list \
       --assignee $(az identity show --name "$UAMI_NAME" --resource-group "$RESOURCE_GROUP" --query "principalId" -o tsv)
   ```

2. Test network connectivity to Azure endpoints:
   ```bash
   # Test from within the VM
   curl -I https://management.azure.com/
   curl -I https://login.microsoftonline.com/
   ```

3. Check cloud services network egress endpoints configuration:
   ```bash
   az networkcloud cloudservicesnetwork show \
       --name "$CSN_NAME" \
       --resource-group "$RESOURCE_GROUP" \
       --query "additionalEgressEndpoints"
   ```

### "Failed to connect to Azure Arc"

**Error message:**
```
ERROR: Failed to connect to Azure Arc
```

**Possible causes:**
- Network connectivity issues to Azure Arc endpoints
- Insufficient permissions for Arc enrollment
- Invalid access token
- Resource group or subscription issues

**Solutions:**

1. Verify required Azure Arc endpoints are accessible:
   ```bash
   # Test connectivity to Azure Arc endpoints
   curl -I https://management.azure.com/
   curl -I https://login.microsoftonline.com/
   curl -I https://pas.windows.net/
   curl -I https://san-af-eastus-prod.azurewebsites.net/
   ```

2. Check if the managed identity has "Azure Connected Machine Onboarding" role:
   ```bash
   az role assignment create \
       --assignee "$PRINCIPAL_ID" \
       --role "Azure Connected Machine Onboarding" \
       --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP"
   ```

3. Verify azcmagent version and status:
   ```bash
   azcmagent version
   azcmagent show
   ```

4. Run azcmagent with additional debugging:
   ```bash
   sudo azcmagent connect \
       --resource-group "$RESOURCE_GROUP" \
       --tenant-id "$TENANT_ID" \
       --location "$LOCATION" \
       --subscription-id "$SUBSCRIPTION_ID" \
       --access-token "$ACCESS_TOKEN" \
       --verbose \
       --debug
   ```

## Network connectivity issues

### Cloud Services Network configuration

Ensure your cloud services network includes necessary egress endpoints:

```bash
az networkcloud cloudservicesnetwork create \
    --name "$CSN_NAME" \
    --extended-location name="$CLUSTER_CUSTOM_LOCATION" type="CustomLocation" \
    --location "$LOCATION" \
    --additional-egress-endpoints '[{"category":"azure-resource-management","endpoints":[{"domainName":"management.azure.com","port":443},{"domainName":"login.microsoftonline.com","port":443},{"domainName":"pas.windows.net","port":443}]}]' \
    --enable-default-egress-endpoints "True" \
    --resource-group "$RESOURCE_GROUP"
```

### Proxy configuration

If using a proxy, ensure environment variables are set correctly within the VM:

```bash
export HTTPS_PROXY=http://169.254.0.11:3128
export https_proxy=http://169.254.0.11:3128
export NO_PROXY=169.254.169.254,localhost,127.0.0.1
export no_proxy=169.254.169.254,localhost,127.0.0.1
```

### IMDS endpoint accessibility

Test IMDS connectivity:

```bash
# Basic connectivity test
curl -H "Metadata:true" --max-time 10 "http://169.254.169.254/metadata/instance?api-version=2021-02-01"

# Test managed identity endpoint
curl -H "Metadata:true" --max-time 10 "http://169.254.169.254/metadata/identity/oauth2/token?resource=https://management.azure.com/&api-version=2018-02-01"
```

## Managed identity configuration issues

### System-assigned managed identity problems

1. **Verify SAMI is enabled during VM creation:**
   ```bash
   az networkcloud virtualmachine create \
       --mi-system-assigned --system-assigned \
       # ... other parameters
   ```

2. **Check SAMI status after creation:**
   ```bash
   az networkcloud virtualmachine show \
       --name "$VM_NAME" \
       --resource-group "$RESOURCE_GROUP" \
       --query "identity.type"
   ```

### User-assigned managed identity problems

1. **Verify UAMI is created and assigned:**
   ```bash
   # Create UAMI
   az identity create \
       --name "$UAMI_NAME" \
       --resource-group "$RESOURCE_GROUP"

   # Assign to VM during creation
   az networkcloud virtualmachine create \
       --mi-user-assigned --user-assigned "$UAMI_ID" \
       # ... other parameters
   ```

2. **Check UAMI assignment:**
   ```bash
   az networkcloud virtualmachine show \
       --name "$VM_NAME" \
       --resource-group "$RESOURCE_GROUP" \
       --query "identity.userAssignedIdentities"
   ```

## Cloud-init troubleshooting

### Check cloud-init status

```bash
# Check cloud-init status
sudo cloud-init status

# View cloud-init logs
sudo tail -f /var/log/cloud-init-output.log

# Check for errors in cloud-init
sudo grep -i error /var/log/cloud-init-output.log
sudo grep -i failed /var/log/cloud-init-output.log
```

### Validate cloud-init script execution

```bash
# Check if all packages were installed
dpkg -l | grep -E "(curl|azure-cli)"

# Verify Azure CLI installation
az version

# Check azcmagent installation
azcmagent version
which azcmagent
```

### Re-run cloud-init manually

If cloud-init failed, you can debug by running parts manually:

```bash
# Install Azure CLI manually
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Test managed identity login
az login --identity --allow-no-subscriptions

# Get access token manually
az account get-access-token --resource https://management.azure.com/

# Install azcmagent manually
wget https://aka.ms/azcmagent -O install_linux_azcmagent.sh
bash install_linux_azcmagent.sh
```

## IMDS sidecar validation

For Nexus VMs, verify that the IMDS sidecar container is running:

```bash
# From the cluster, check if the IMDS sidecar exists
kubectl get pods -n nc-system -o wide | grep "virt-launcher-$VM_NAME"

# Get pod details
POD=$(kubectl get pods -n nc-system -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep -i "virt-launcher-$VM_NAME" | head -n1)

# Check if hook-sidecar-0 container exists
kubectl get pod "$POD" -n nc-system -o jsonpath='{.spec.containers[*].name}' | tr ' ' '\n' | grep "hook-sidecar-0"

# Check sidecar logs
kubectl logs "$POD" -n nc-system -c hook-sidecar-0
```

## Validation procedures

### End-to-end validation script

Create a validation script to test the complete flow:

```bash
#!/bin/bash
set -e

echo "=== Azure Arc Enrollment Validation ==="

# Test 1: IMDS connectivity
echo "Testing IMDS connectivity..."
curl -H "Metadata:true" --max-time 10 "http://169.254.169.254/metadata/instance?api-version=2021-02-01" > /dev/null
echo "✓ IMDS accessible"

# Test 2: Managed identity authentication
echo "Testing managed identity authentication..."
az login --identity --allow-no-subscriptions > /dev/null
echo "✓ Managed identity login successful"

# Test 3: Access token retrieval
echo "Testing access token retrieval..."
ACCESS_TOKEN=$(az account get-access-token --resource https://management.azure.com/ --query accessToken -o tsv)
if [ -n "$ACCESS_TOKEN" ]; then
    echo "✓ Access token retrieved"
else
    echo "✗ Failed to retrieve access token"
    exit 1
fi

# Test 4: azcmagent installation
echo "Testing azcmagent installation..."
if command -v azcmagent &> /dev/null; then
    echo "✓ azcmagent is installed"
    azcmagent version
else
    echo "✗ azcmagent not found"
    exit 1
fi

# Test 5: Arc connection status
echo "Testing Arc connection status..."
if azcmagent show > /dev/null 2>&1; then
    echo "✓ VM is connected to Azure Arc"
    azcmagent show
else
    echo "✗ VM is not connected to Azure Arc"
    exit 1
fi

echo "=== All validations passed! ==="
```

### Check Arc enrollment from Azure portal

1. Navigate to the Azure portal
2. Go to "Azure Arc" > "Servers"
3. Look for your VM in the resource group
4. Check the status and last heartbeat

### Verify using Azure CLI

```bash
# List all Arc-enabled servers
az connectedmachine list \
    --resource-group "$RESOURCE_GROUP" \
    --query "[].{Name:name,Status:status,LastStatusChange:lastStatusChange}" \
    --output table

# Get detailed information about specific server
az connectedmachine show \
    --name "$VM_NAME" \
    --resource-group "$RESOURCE_GROUP"
```

## Advanced troubleshooting

### Enable azcmagent logging

```bash
# Enable verbose logging for azcmagent
sudo azcmagent config set log.level DEBUG

# Check azcmagent logs
sudo journalctl -u azcmagent -f
```

### Network packet capture

If network issues are suspected:

```bash
# Install tcpdump
sudo apt-get install tcpdump

# Capture traffic to IMDS endpoint
sudo tcpdump -i any host 169.254.169.254

# Capture traffic to Azure endpoints
sudo tcpdump -i any host management.azure.com
```

### Check systemd services

```bash
# Check if azcmagent service is running
sudo systemctl status azcmagent

# Check service logs
sudo journalctl -u azcmagent --no-pager

# Restart the service if needed
sudo systemctl restart azcmagent
```

## Getting help

If you're still experiencing issues after following this troubleshooting guide:

1. **Collect diagnostic information:**
   - Cloud-init logs: `/var/log/cloud-init-output.log`
   - azcmagent logs: `sudo journalctl -u azcmagent`
   - Network connectivity tests results
   - VM and managed identity configuration details

2. **Review related documentation:**
   - [Azure Connected Machine agent troubleshooting](/azure/azure-arc/servers/troubleshoot-agent-onboard)
   - [Managed identities troubleshooting](/entra/identity/managed-identities-azure-resources/managed-identities-faq)

3. **Reference external documentation:**
   - [Azure Connected Machine agent connect reference](/azure/azure-arc/servers/azcmagent-connect#access-token)
   - [How to use managed identities to get an access token](/entra/identity/managed-identities-azure-resources/how-to-use-vm-token#get-a-token-using-go)

## Related articles

- [How to enroll Azure Operator Nexus virtual machines with Azure Arc using managed identities](./howto-arc-enroll-virtual-machine-using-managed-identities.md)
- [Prerequisites for deploying tenant workloads](./quickstarts-tenant-workload-prerequisites.md)
- [Create a virtual machine using Azure CLI](./quickstarts-virtual-machine-deployment-cli.md)
- [Create a virtual machine using PowerShell](./quickstarts-virtual-machine-deployment-ps.md)
- [Create a virtual machine using ARM template](./quickstarts-virtual-machine-deployment-arm.md)
- [Create a virtual machine using Bicep](./quickstarts-virtual-machine-deployment-bicep.md)

[!include[stillHavingIssues](./includes/contact-support.md)]



TODO add troubleshooting step where the CSN needs to be updated due to the adding of new egress endpoints

    --additional-egress-endpoints "[{category:'azure-resource-management',endpoints:[{domainName:'storageaccountex.blob.core.windows.net',port:443}]},{category:'package-repository',endpoints:[{domainName:'.wikimedia.org',port:443},{domainName:'.microsoft.com',port:443},{domainName:'aka.ms',port:443}]}]" \

we need to mention that there's assumed knowledge that the CSN is already created and configured with the necessary egress endpoints
using the default endpoints. for example management.azure.com is expected to be present.
  --enable-default-egress-endpoints "True" \


### Alternative approach using `az rest` or `curl`

There may be scenarios where using `az login --identity` does not work as expected.
If you prefer not to use the Azure CLI for authentication, you can retrieve an access token directly using `az rest` or `curl`.
This approach can be useful in environments where the Azure CLI is not available or if you encounter issues with the CLI.

The example is meant to provide alternatives for retrieving the access token; however, it is always preferred to use the Azure CLI.

### Using `az rest`

With a system-assigned identity:

```azurecli
az rest --method get \
  --url "http://169.254.169.254/metadata/identity/oauth2/token?resource=https%3A%2F%2Fmanagement.core.windows.net%2F&api-version=2018-02-01" \
  --headers '{"Metadata":"true"}'
```

Or using a user-assigned identity:

> [!IMPORTANT]
> The `msi_res_id` query parameter must be set to the resource ID of the user-assigned managed identity.
> The value must be URL encoded. The example assumes this is done already. Outside the scope of this example.

```azurecli
az rest --method get \
  --url "http://169.254.169.254/metadata/identity/oauth2/token?resource=https%3A%2F%2Fmanagement.core.windows.net%2F&api-version=2018-02-01&msi_res_id=${UAMI_ID}" \
  --headers '{"Metadata":"true"}'
```

### Using `curl`

```bash
curl -H "Metadata: true" "http://169.254.169.254/metadata/identity/oauth2/token?resource=https%3A%2F%2Fmanagement.core.windows.net%2F&api-version=2018-02-01"
```

```bash
curl -H "Metadata: true" "http://169.254.169.254/metadata/identity/oauth2/token?resource=https%3A%2F%2Fmanagement.core.windows.net%2F&api-version=2018-02-01&msi_res_id=${UAMI_ID}"
```


## Passing a user data cloud-init script

If you want to pass a custom user data cloud-init script to the virtual machine during creation,
you can encode the user data script in base64 format and include it in the `--user-data "$ENCODED_USER_DATA"` parameter of the `az networkcloud virtualmachine create` command.

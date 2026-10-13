---
title: Troubleshoot Bare-Metal Machines by Using the run-read Command
description: This article teaches you how to run diagnostics on a bare-metal machine by using the run-read command for Azure Operator Nexus.
author: gregoberfield
ms.author: goberfield
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 4/17/2025
ms.custom: template-how-to
---

# Troubleshoot bare-metal machine issues by using the run-read command

You can investigate and resolve issues with an on-premises bare-metal machine by using the `az networkcloud baremetalmachine run-read-command` for Azure Operator Nexus. The `run-read` command supports a curated list of read-only commands that help you get information from a bare-metal machine.

## Prerequisites

1. Install the latest version of the [appropriate CLI extensions](./howto-install-cli-extensions.md).
1. Ensure that the target bare-metal machine has its `poweredState` set to `On` and its `readyState` set to `True`.
1. Get the managed resource group name (`cluster_MRG`) that you created for the `Cluster` resource.

[!INCLUDE [command-output-settings](./includes/run-commands/command-output-settings.md)]

## Run a `run-read` command

You can use the `run-read` command to run a command on a bare-metal machine without changing anything. Some commands have more than one word or need an argument to work. These commands are structured to distinguish them from ones that can make changes. For example, the `run-read` command can use `kubectl get` but not `kubectl apply`.

When you use these commands, you have to put all the words in the `command` field. For example, `{command:'kubectl get',arguments:[nodes]}` is right; `{command:kubectl,arguments:[get,nodes]}` is wrong.

Some commands begin with `nc-toolbox nc-toolbox-runread` and must be entered as shown. The `nc-toolbox-runread` command is a special container image that includes more tools that aren't installed on the bare-metal host, including `ipmitool` and `racadm`.

Some of the `run-read` commands require that you supply specific arguments to ensure the commands are read-only. For example, a `run-read` command that requires specific arguments is the allowed Mellanox command `mstconfig`. This command needs the `query` argument to be read-only.

> [!WARNING]
> Microsoft doesn't provide or support any Azure Operator Nexus API calls that require a plaintext username or password. Any values sent are logged and are considered exposed secrets, which should be rotated and revoked. We recommend that you store secrets in Azure Key Vault. If you have specific questions or concerns, submit a request via the Azure portal.

This list shows the commands you can use. Commands that are displayed in *italics* can't have arguments, but the rest can.

- `brctl show`
- `dmidecode` (only no arguments or the `-t bios` argument allowed)
- _`fdisk -l`_
- `host`
- _`hostname`_
- _`ifconfig -a`_
- _`ifconfig -s`_
- `ip address show`
- `ip link show`
- `ip maddress show`
- `ip route show`
- `journalctl` (only the `-u`, `-n`, `--no-pager`, and `--disk-usage` arguments allowed)
- `kubectl api-resources`
- `kubectl api-versions`
- `kubectl describe`
- `kubectl get`
- `kubectl logs`
- _`mount`_
- `ping`
- _`ss`_
- `traceroute`
- `uname`
- _`ulimit -a`_
- `uptime`
- `timedatectl status`
- `hostnamectl status`
- `nc-toolbox nc-toolbox-runread ipmitool channel authcap`
- `nc-toolbox nc-toolbox-runread ipmitool channel info`
- _`nc-toolbox nc-toolbox-runread ipmitool chassis status`_
- _`nc-toolbox nc-toolbox-runread ipmitool chassis power status`_
- _`nc-toolbox nc-toolbox-runread ipmitool chassis restart cause`_
- _`nc-toolbox nc-toolbox-runread ipmitool chassis poh`_
- _`nc-toolbox nc-toolbox-runread ipmitool dcmi power get_limit`_
- _`nc-toolbox nc-toolbox-runread ipmitool dcmi sensors`_
- _`nc-toolbox nc-toolbox-runread ipmitool dcmi asset_tag`_
- _`nc-toolbox nc-toolbox-runread ipmitool dcmi get_mc_id_string`_
- `nc-toolbox nc-toolbox-runread ipmitool dcmi thermalpolicy get`
- _`nc-toolbox nc-toolbox-runread ipmitool dcmi get_temp_reading`_
- _`nc-toolbox nc-toolbox-runread ipmitool dcmi get_conf_param`_
- _`nc-toolbox nc-toolbox-runread ipmitool delloem lcd info`_
- _`nc-toolbox nc-toolbox-runread ipmitool delloem lcd status`_
- _`nc-toolbox nc-toolbox-runread ipmitool delloem mac list`_
- `nc-toolbox nc-toolbox-runread ipmitool delloem mac get`
- `nc-toolbox nc-toolbox-runread ipmitool delloem lan get`
- _`nc-toolbox nc-toolbox-runread ipmitool delloem powermonitor powerconsumption`_
- _`nc-toolbox nc-toolbox-runread ipmitool delloem powermonitor powerconsumptionhistory`_
- _`nc-toolbox nc-toolbox-runread ipmitool delloem powermonitor getpowerbudget`_
- _`nc-toolbox nc-toolbox-runread ipmitool delloem vflash info card`_
- `nc-toolbox nc-toolbox-runread ipmitool fru print`
- _`nc-toolbox nc-toolbox-runread ipmitool fwum info`_
- _`nc-toolbox nc-toolbox-runread ipmitool fwum status`_
- _`nc-toolbox nc-toolbox-runread ipmitool fwum tracelog`_
- _`nc-toolbox nc-toolbox-runread ipmitool gendev list`_
- _`nc-toolbox nc-toolbox-runread ipmitool hpm rollbackstatus`_
- _`nc-toolbox nc-toolbox-runread ipmitool hpm selftestresult`_
- _`nc-toolbox nc-toolbox-runread ipmitool ime help`_
- _`nc-toolbox nc-toolbox-runread ipmitool ime info`_
- _`nc-toolbox nc-toolbox-runread ipmitool isol info`_
- `nc-toolbox nc-toolbox-runread ipmitool lan print`
- `nc-toolbox nc-toolbox-runread ipmitool lan alert print`
- `nc-toolbox nc-toolbox-runread ipmitool lan stats get`
- `nc-toolbox nc-toolbox-runread ipmitool mc bootparam get`
- _`nc-toolbox nc-toolbox-runread ipmitool mc chassis poh`_
- _`nc-toolbox nc-toolbox-runread ipmitool mc chassis policy list`_
- _`nc-toolbox nc-toolbox-runread ipmitool mc chassis power status`_
- _`nc-toolbox nc-toolbox-runread ipmitool mc chassis status`_
- _`nc-toolbox nc-toolbox-runread ipmitool mc getenables`_
- `nc-toolbox nc-toolbox-runread ipmitool mc getsysinfo`
- _`nc-toolbox nc-toolbox-runread ipmitool mc guid`_
- _`nc-toolbox nc-toolbox-runread ipmitool mc info`_
- _`nc-toolbox nc-toolbox-runread ipmitool mc restart cause`_
- _`nc-toolbox nc-toolbox-runread ipmitool mc watchdog get`_
- `nc-toolbox nc-toolbox-runread ipmitool bmc bootparam get`
- _`nc-toolbox nc-toolbox-runread ipmitool bmc chassis poh`_
- _`nc-toolbox nc-toolbox-runread ipmitool bmc chassis policy list`_
- _`nc-toolbox nc-toolbox-runread ipmitool bmc chassis power status`_
- _`nc-toolbox nc-toolbox-runread ipmitool bmc chassis status`_
- _`nc-toolbox nc-toolbox-runread ipmitool bmc getenables`_
- `nc-toolbox nc-toolbox-runread ipmitool bmc getsysinfo`
- _`nc-toolbox nc-toolbox-runread ipmitool bmc guid`_
- _`nc-toolbox nc-toolbox-runread ipmitool bmc info`_
- _`nc-toolbox nc-toolbox-runread ipmitool bmc restart cause`_
- _`nc-toolbox nc-toolbox-runread ipmitool bmc watchdog get`_
- `nc-toolbox nc-toolbox-runread ipmitool nm alert get`
- `nc-toolbox nc-toolbox-runread ipmitool nm capability`
- `nc-toolbox nc-toolbox-runread ipmitool nm discover`
- `nc-toolbox nc-toolbox-runread ipmitool nm policy get policy_id`
- `nc-toolbox nc-toolbox-runread ipmitool nm policy limiting`
- `nc-toolbox nc-toolbox-runread ipmitool nm statistics`
- `nc-toolbox nc-toolbox-runread ipmitool nm suspend get`
- `nc-toolbox nc-toolbox-runread ipmitool nm threshold get`
- _`nc-toolbox nc-toolbox-runread ipmitool pef`_
- `nc-toolbox nc-toolbox-runread ipmitool picmg addrinfo`
- `nc-toolbox nc-toolbox-runread ipmitool picmg policy get`
- _`nc-toolbox nc-toolbox-runread ipmitool power status`_
- `nc-toolbox nc-toolbox-runread ipmitool sdr elist`
- `nc-toolbox nc-toolbox-runread ipmitool sdr get`
- _`nc-toolbox nc-toolbox-runread ipmitool sdr info`_
- `nc-toolbox nc-toolbox-runread ipmitool sdr list`
- `nc-toolbox nc-toolbox-runread ipmitool sdr type`
- `nc-toolbox nc-toolbox-runread ipmitool sel elist`
- `nc-toolbox nc-toolbox-runread ipmitool sel get`
- _`nc-toolbox nc-toolbox-runread ipmitool sel info`_
- `nc-toolbox nc-toolbox-runread ipmitool sel list`
- _`nc-toolbox nc-toolbox-runread ipmitool sel time get`_
- `nc-toolbox nc-toolbox-runread ipmitool sensor get`
- _`nc-toolbox nc-toolbox-runread ipmitool sensor list`_
- `nc-toolbox nc-toolbox-runread ipmitool session info`
- `nc-toolbox nc-toolbox-runread ipmitool sol info`
- `nc-toolbox nc-toolbox-runread ipmitool sol payload status`
- `nc-toolbox nc-toolbox-runread ipmitool user list`
- `nc-toolbox nc-toolbox-runread ipmitool user summary`
- _`nc-toolbox nc-toolbox-runread racadm arp`_
- _`nc-toolbox nc-toolbox-runread racadm coredump`_
- `nc-toolbox nc-toolbox-runread racadm eventfilters get`
- _`nc-toolbox nc-toolbox-runread racadm fcstatistics`_
- `nc-toolbox nc-toolbox-runread racadm get`
- _`nc-toolbox nc-toolbox-runread racadm gethostnetworkinterfaces`_
- _`nc-toolbox nc-toolbox-runread racadm getled`_
- _`nc-toolbox nc-toolbox-runread racadm getniccfg`_
- _`nc-toolbox nc-toolbox-runread racadm getraclog`_
- _`nc-toolbox nc-toolbox-runread racadm getractime`_
- _`nc-toolbox nc-toolbox-runread racadm getsel`_
- _`nc-toolbox nc-toolbox-runread racadm getsensorinfo`_
- _`nc-toolbox nc-toolbox-runread racadm getssninfo`_
- _`nc-toolbox nc-toolbox-runread racadm getsvctag`_
- `nc-toolbox nc-toolbox-runread racadm getsysinfo` (only the `-c` argument allowed)
- _`nc-toolbox nc-toolbox-runread racadm gettracelog`_
- `nc-toolbox nc-toolbox-runread racadm getversion` (only the `-c` and `-a` arguments allowed)
- `nc-toolbox nc-toolbox-runread racadm hwinventory`
- _`nc-toolbox nc-toolbox-runread racadm ifconfig`_
- _`nc-toolbox nc-toolbox-runread racadm inlettemphistory get`_
- _`nc-toolbox nc-toolbox-runread racadm jobqueue view`_
- `nc-toolbox nc-toolbox-runread racadm lclog view` (only the `-n`, `-c`, and `-s` arguments allowed)
- `nc-toolbox nc-toolbox-runread racadm lclog viewconfigresult`
- _`nc-toolbox nc-toolbox-runread racadm license view`_
- _`nc-toolbox nc-toolbox-runread racadm netstat`_
- _`nc-toolbox nc-toolbox-runread racadm nicstatistics`_
- `nc-toolbox nc-toolbox-runread racadm ping`
- `nc-toolbox nc-toolbox-runread racadm ping6`
- _`nc-toolbox nc-toolbox-runread racadm racdump`_
- `nc-toolbox nc-toolbox-runread racadm sslcertview` (only the `-t` argument allowed)
- _`nc-toolbox nc-toolbox-runread racadm swinventory`_
- `nc-toolbox nc-toolbox-runread racadm systemperfstatistics` (`PeakReset` argument not allowed)
- _`nc-toolbox nc-toolbox-runread racadm techsupreport getupdatetime`_
- `nc-toolbox nc-toolbox-runread racadm traceroute`
- `nc-toolbox nc-toolbox-runread racadm traceroute6`
- `nc-toolbox nc-toolbox-runread racadm usercertview` (only the `-i` argument allowed)
- `nc-toolbox nc-toolbox-runread mstregdump`
- `nc-toolbox nc-toolbox-runread mstconfig` (requires `query` argument)
- `nc-toolbox nc-toolbox-runread mstflint` (requires `query` argument)
- `nc-toolbox nc-toolbox-runread mstlink` (requires `query` argument)
- `nc-toolbox nc-toolbox-runread mstfwmanager` (requires `query` argument)
- `nc-toolbox nc-toolbox-runread mlx_temp`

The following code snippet shows the command syntax for a single command with no arguments, using `hostname` as an example:

```azurecli
az networkcloud baremetalmachine run-read-command --name "<bareMetalMachineName>"
    --limit-time-seconds "<timeout>" \
    --commands "[{command:hostname}]" \
    --resource-group "<cluster_MRG>" \
    --subscription "<subscription>"
```

The previous code snippet uses the following variables:

- The value `--name` is the name of the bare-metal machine resource on which to run the command.
- The `--commands` parameter always takes a list of commands, even if there's only one command.
- Multiple commands can be provided in JSON format by using the [Azure CLI shorthand](https://aka.ms/cli-shorthand) notation.
- Any blank spaces must be enclosed in single quotation marks.
- Arguments for each command must also be provided as a list, as shown in the following examples.
- Not all commands can run on any bare-metal machine. For example, `kubectl` commands can only be run from a bare-metal machine with the `control-plane` role.

```
--commands "[{command:hostname},{command:'nc-toolbox nc-toolbox-runread racadm ifconfig'}]"
--commands "[{command:hostname},{command:'nc-toolbox nc-toolbox-runread racadm getsysinfo',arguments:[-c]}]"
--commands "[{command:ping,arguments:[198.51.102.1,-c,3]}]"
```

These commands can take a long time to run, so we recommend that you set `--limit-time-seconds` to at least 600 seconds (10 minutes). Running multiple commands might take longer than 10 minutes.

This command runs synchronously. To skip waiting for the command to complete, specify the `--no-wait --debug` options. For more information, see [How to track asynchronous operations](howto-track-async-operations-cli.md).

When you provide an optional argument `--output-directory` value, the output result is downloaded and extracted to the local directory, as long as the user running the command has appropriate access to the storage account.

> [!WARNING]
> Using the `--output-directory` argument overwrites any files in the local directory that have the same name as the new files being created.

### This example runs the `kubectl get pods` command

```azurecli
az networkcloud baremetalmachine run-read-command --name "<bareMetalMachineName>" \
   --limit-time-seconds 60 \
   --commands "[{command:'kubectl get',arguments:[pods,-n,nc-system]}]" \
   --resource-group "<cluster_MRG>" \
   --subscription "<subscription>"
```

### This example runs the `hostname` command and a `ping` command

```azurecli
az networkcloud baremetalmachine run-read-command --name "<bareMetalMachineName>" \
    --limit-time-seconds 60 \
    --commands "[{command:hostname},{command:ping,arguments:[198.51.102.1,-c,3]}]" \
    --resource-group "<cluster_MRG>" \
    --subscription "<subscription>"
```

### This example runs the `racadm getsysinfo -c` command

```azurecli
az networkcloud baremetalmachine run-read-command --name "<bareMetalMachineName>" \
    --limit-time-seconds 60 \
    --commands "[{command:'nc-toolbox nc-toolbox-runread racadm getsysinfo',arguments:[-c]}]" \
    --resource-group "<cluster_MRG>" \
    --subscription "<subscription>"
```

## Check the command status

The following sample output prints the result's top 4,000 characters to the screen for convenience. It provides a short-lived link to the storage blob that contains the command execution result.

```output
  ====Action Command Output====
  + hostname
  rack1compute01
  + ping 198.51.102.1 -c 3
  PING 198.51.102.1 (198.51.102.1) 56(84) bytes of data.

  --- 198.51.102.1 ping statistics ---
  3 packets transmitted, 0 received, 100% packet loss, time 2049ms

  ================================
  Script execution result can be found in storage account:
  https://<storage_account_name>.blob.core.windows.net/bmm-run-command-output/a8e0a5fe-3279-46a8-b995-51f2f98a18dd-action-bmmrunreadcmd.tar.gz?se=2023-04-14T06%3A37%3A00Z&sig=XXX&sp=r&spr=https&sr=b&st=2023-04-14T02%3A37%3A00Z&sv=2019-12-12
```

[!INCLUDE [command-output-view](./includes/run-commands/command-output-view.md)]

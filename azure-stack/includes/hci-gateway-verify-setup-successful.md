---
ms.topic: include
author: alkohli
ms.topic: how-to
ms.date: 06/20/2024
ms.author: alkohli
ms.subservice: azure-stack-hci

---

Once the deployment validation starts, connect to the first server node from your cluster and open the Arc gateway log to monitor which endpoints are being redirected to the Arc gateway and which ones keep using your firewall or proxy security solutions. You should find the Arc gateway sign in *c:\programdata\AzureConnectedMAchineAgent\Log\arcproxy.log*.

  :::image type="content" source="./media/hci-gateway-verify-setup-successful/arc-gateway-log-location.png" alt-text="Screenshot of location of log file for Azure Arc gateway." lightbox="./media/hci-gateway-verify-setup-successful/arc-gateway-log-location.png":::

1. To check the Arc agent configuration and verify that it is using the gateway, connect to the Azure Stack HCI server node.
1. Run the following command: `"c:\program files\AzureConnectedMachineAgent>.\azcmagent show"`. The result should show the following values:

    :::image type="content" source="./media/hci-gateway-verify-setup-successful/connected-machine-agent-with-arc-gateway-output.png" alt-text="Screenshot of Azure Arc gateway connected machine agent output window." lightbox="./media/hci-gateway-verify-setup-successful/connected-machine-agent-with-arc-gateway-output.png":::

    - **Agent Version** should show as `1.40` or later. <!--CHECK-->
    - **Agent Status** should show as `Connected`.
    - **Using HTTPS Proxy** is empty when Arc gateway isn't in use. It should show as `http://localhost:40343` when the Arc gateway is enabled.
    - **Upstream Proxy** always shows as empty for Azure Stack HCI as it uses the environment variables to configure the Arc agent.
    - **Upstream Proxy Bypass List** should show your bypass list.
    - **Azure Arc Proxy (arcproxy)** shows as `Stopped` when Arc gateway isn't in use and shows as `Running` when Arc gateway is enabled.

1. Verify that setup was successful by running the `"c:\program files\AzureConnectedMachineAgent>.\azcmagent check"` command. The result should show the following values:

    :::image type="content" source="./media/hci-gateway-verify-setup-successful/check-connected-machine-agent-with-arc-gateway.png" alt-text="Screenshot of successful verification from the output of azcmagent check command." lightbox="./media/hci-gateway-verify-setup-successful/check-connected-machine-agent-with-arc-gateway.png":::

    - **connection.type** should show as `gateway`.

    - **Reachable** column should list `true` for all URLs.


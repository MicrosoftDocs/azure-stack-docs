$extensionname = "SampleExtensionName"

$VMs = Get - AzVM

Foreach($VM in $VMs) {

    $VMExtensions = Get - AzVMExtension - ResourceGroup $VM.ResourceGroupName - VMName $VM.name

    $extensions = $VMExtensions.name

    Foreach($Extension in $Extensions) {
        if ($Extension - eq $extensionname)

        {
            write - host $VM.Name
        }

    }

}
Function SetWindowsConf ($folder){
    Write-Host "[1] VM Network Change"
    Write-Host ""
    $vm = Get-VM -Location $folder 
    $i = 1
    Write-Host "[0] Back to main menu"
    foreach ($vm in $vms) {
        Write-Host "[$i]" "($vm.name)"
        $i+=1
    }
    Write-Host ""
    $vms = Read-Host "What VM do you want to change"

    $user = Read-Host "Which User"
    $password = Read-Host -AsSecureString "What is the password"

    Write-Host ""
    Invoke-VMScript -ScriptText "Get-NetAdapter | Select-Object Name" -VM $vms -GuestUser $user GuestPassword $password
    Write-Host ""
    $adapter = Read-Host "Enter the network adapter you want to use"
    Write-Host ""
    $ip = Read-Host "What would you like the IP set as"
    Write-Host ""
    $gateway = Read-Host "What would you like the gateway set as"
    Write-Host ""
    $dns = Read-Host "What would you like the DNS to be set as"
    Write-Host ""
    $netMask = Read-Host "What would you like the netmask set as"
    Write-Host ""

    $setIp = "netsh interface ipv4 set address '$adapter' static $ip $gateway $netMask"
    $setDNS = "netsh interface ipv4 add dns '$adapter' $dns"
    Invoke-VMScript -ScriptText $setIp -VM $vms -GuestUser $user -GuestPassword $password
    Invoke-VMScript -ScriptText $setDNS -VM $vms -GuestUser $user -GuestPassword $password
}
function intMenu([string[]] $folder) {
    Write-Host "Select"
    Write-Host "Exit[1]"
    Write-Host "Virtual Machine[2]"
    Write-Host "vCenter Network[3]"
    Write-Host "Space"
    $menu = Read-Host 'Pick which option you would like to use'
    if ($menu -eq '1'){
        Clear-Host
        vm-mang

    }elseif($menu -eq '2'){
        Clear-Host
        net-mang 
    }elseif($menu -eq '0'){
        Clear-Host
        Exit
    }else{
        Write-Host "Please Pick an Option with a valid option number"
        Clear-Host
        intMenu
    }

}

function vmmang([string[]] $folder) {
    Write-Host "Select Option"
    Write-Host "Exit"
    Write-Host "Create Clone"
    Write-Host "Delete clone or VM"
    $menuVm = Read-Host 'Pick a number'
    if ($menuVm -eq "1"){
        cloneMenu
    }elseif ($menuVm -eq "2"){
        deleteMenu
    }
    else{
        Write-Host "Invalid"
        Clear-Host
        vmmang
    }
}
function cloneMenu(){
    Clear-Host
    Write-Host "[0]Go Back"
    Write-Host "[1]Linked Clone"

    $menuclone = Read-Host 'Pick a Number'
    if ($menuclone -eq "0"){
        Clear-Host
        intMenu
    }elseif($menuclone -eq "1"){
        linkedclone
    }
    else {
        Write-Host "Pick a valid Number"
        Clear-Host
        cloneMenu
    }
}
# Used to create linked Clones - Will list ALL VMs
function linkedclone() {
    #$config = (Get-Content -Raw -Path "/home/sebastian/SEC-480-Sebastian-1/config.json" | ConvertFrom-Json)
    Clear-Host
    Write-Host "Options"
    Write-Host "[0] Main Menu"
    $selectedVM = $null
        $vms = Get-VM #-Location $config.folder
        $count = 1
        foreach($vm in $vms) {
            Write-Host  "[$count] $($vm.name)"
            $count+=1
        }
        Write-Host ""
        $vmInput = Read-Host 'Pick a Number to Clone?'
        if ($vmInput -match '^\d+$') {
            $key = [int]$vmInput - 1
            if ($key -lt 0) {
                Clear-Host
                intMenu
            }elseif($key -ge $vms.Count){
                Write-Host "Select a Valid Number"
                linkedclone 
            }else {
                $selectedVM = $vms[$key]
                Write-Host "You picked $($selectedVM.name)."
                $confirm = Read-Host -Prompt "Are you sure you want to clone the selected virtual machine (Y/N)? "
                if ($confirm -eq "Y" ) {
                    Clear-Host
                    linkedClone $selectedVM
                } else {
                  Clear-Host
                  Write-Host "Cloning Failed, Please Select a Valid Number"
                  linkedclone #-folder $config.folder
                }
            }
        }else{
            Write-Host  "Please Select a Valid Number"
            cloneMenu
        }
}

# Creates linked Clone - does not get deleted
function linkedClone($selectedVM) {
    $config = (Get-Content -Raw -Path "/home/q/Documents/techJournal/SYS-480-DevOps/480.json" | ConvertFrom-Json)
    $snapshot = Get-Snapshot -VM $selectedVM.Name -Name "Base"
    $inputName = Read-Host "Enter a name for the linked VM" 
    $linkedClone = $inputName -f $selectedVM.Name
    $linkedVM = New-VM -LinkedClone -Name $linkedClone -VM $selectedVM.Name -ReferenceSnapshot $snapshot -VMHost $config.esxi_host -Datastore $config.default_datastore 
    $linkedVM | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $config.default_network -Confirm:$false
    Write-Host ""
    Write-Host "$linkedVM has been created"
    finishCheck
}

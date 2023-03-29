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

function vm-mang([string[]] $folder) {
    Write-Host "Select Option"
    Write-Host "Exit"
    
}
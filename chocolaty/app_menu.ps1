function Show-Menu {
    Clear-Host
    Write-Host "================ Chocolatey Package Manager ================"
    Write-Host "1: List installed packages"
    Write-Host "2: Uninstall a package"
    Write-Host "3: Update all packages"
    Write-Host "4: Exit"
    Write-Host "====================================================="
}

function List-InstalledPackages {
    Clear-Host
    Write-Host "================ Installed Packages ================"
    Write-Host "0: Return to main menu"
    Write-Host "------------------------------------------------"
    
    $packages = choco list --local-only
    $index = 1
    
    foreach ($package in $packages[1..($packages.Length-3)]) {
        Write-Host "$index`: $package"
        $index++
    }
    
    Write-Host "`nPress any key to return to main menu..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

function Uninstall-ChocoPackage {
    Clear-Host
    Write-Host "================ Uninstall Package ================"
    Write-Host "0: Return to main menu"
    Write-Host "------------------------------------------------"
    
    $packages = choco list --local-only
    $packageList = $packages[1..($packages.Length-3)]
    $index = 1
    
    foreach ($package in $packageList) {
        Write-Host "$index`: $package"
        $index++
    }
    
    Write-Host "`nEnter the number of the package to uninstall (0 to return):"
    $selection = Read-Host
    
    if ($selection -eq "0") {
        return
    }
    
    if ($selection -match '^\d+$' -and [int]$selection -le $packageList.Count) {
        $selectedPackage = $packageList[$selection - 1]
        $packageName = ($selectedPackage -split '\s+')[0]
        
        Write-Host "`nUninstalling $packageName..."
        choco uninstall $packageName -y
        
        Write-Host "`nPress any key to return to main menu..."
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    }
    else {
        Write-Host "`nInvalid selection. Press any key to try again..."
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        Uninstall-ChocoPackage
    }
}

function Update-AllPackages {
    Clear-Host
    Write-Host "================ Updating All Packages ================"
    
    choco upgrade all -y
    
    Write-Host "`nPress any key to return to main menu..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

# Main menu loop
do {
    Show-Menu
    $selection = Read-Host "`nEnter your selection"
    
    switch ($selection) {
        '1' { List-InstalledPackages }
        '2' { Uninstall-ChocoPackage }
        '3' { Update-AllPackages }
        '4' { 
            Clear-Host
            Write-Host "Exiting..."
            return
        }
        default {
            Write-Host "`nInvalid selection. Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        }
    }
} while ($true)
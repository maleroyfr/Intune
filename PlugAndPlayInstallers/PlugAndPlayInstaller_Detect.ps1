<#
.SYNOPSIS
    Remediation script for a Intune Remediation.
.DESCRIPTION
    Checks registry key DisableCoInstallers on HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Installer
.NOTES
    FileName:   PlugAndPlayInstaller_Detect.ps1
    Date:       20/02/2024
#>

#Log construction
$LogFolder = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\RemediationScript\"
$LogFile = $LogFolder + (Split-Path -leaf $PSCommandpath) + ".log"

#Start of transcript
Start-Transcript -Path $LogFile

$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Installer"

function Test-RegistryValue {

    param (

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]$Path,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]$Value
    )

    $c = 0
    Get-Item -Path $Path | Select-Object -ExpandProperty property | % { if ($_ -match $Value) { $c = 1 ; return $true } }
    if ($c -eq 0) { return $false }

}

If (Test-RegistryValue -Path $Path -Value 'DisableCoInstallers') {
    if ((Get-ItemProperty $Path).DisableCoInstallers -eq "1") {
        Write-Output "DisableCoInstallers registry key in $path exist and value correct"
        
        #End of transcript
        Stop-transcript
        
        Exit 0
    }
    else {
        Write-Output "DisableCoInstallers registry key in $path exist but value is NOT correct. Remediation required!"
        
        #End of transcript
        Stop-transcript
        
        Exit 1
        
    }
}
else {
    Write-Output "DisableCoInstallers registry key in $path not found. Remediation required!"
    
    #End of transcript
    Stop-transcript
    
    Exit 1

}
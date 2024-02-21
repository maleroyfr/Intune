<#
.SYNOPSIS
    Remediation script for a Intune.
.DESCRIPTION
  Checks registry key DisableCoInstallers on HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Installer
  value = "1"
.NOTES
    FileName:   PlugAndPlayInstaller_Remediation.ps1
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

# Start the logging 
Write-Output "------------------------START Remediation Script-----------------------"

$Keyregistry = "DisableCoInstallers"
$value = "1"

Try {
  New-ItemProperty -Path $Path -Name $Keyregistry -Value $value -PropertyType "DWORD" -Force | Out-Null
  Write-Output "SUCCESS - successfully modify or create the registry key : $Keyregistry to value $value"
}
Catch {
  Write-Output $_.Exception.Message
  Write-Output "ERROR - Failed to modify or create the registry key : $Keyregistry to value $value"
  Write-Output "------------------------END-----------------------"
        
  #End of transcript
  Stop-transcript

  Exit 1
}

Write-Output "------------------------END Remediation Script-----------------------"

#End of transcript
Stop-transcript
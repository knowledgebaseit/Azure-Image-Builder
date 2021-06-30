<#Author       : Dennis Westerman
# Creation Date: 2021-06-29
# Usage        : Prepare and customize a master VHD image
#*********************************************************************************
# Date                  Version     Changes
#------------------------------------------------------------------------
# 2021-06-29            1.0         Intial Version
#
#*********************************************************************************
#
#>

######################
#    Win10reg.ps1    #
######################

#Disable Automatic Updates
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'NoAutoUpdate' -Value '1' -PropertyType DWORD -Force | Out-Null

#Block Cleanup Of Unused Preinstalled LangPacks
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup"
New-Item -Path 'HKLM:\Software\Policies\Microsoft\Control Panel\International' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Control Panel\International' -Name 'BlockCleanupOfUnusedPreinstalledLangPacks' -Value '1' -PropertyType DWORD -Force | Out-Null

#Set up time zone redirection
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'fEnableTimeZoneRedirection' -Value '1' -PropertyType DWORD -Force | Out-Null

#Disable Storage Sense
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense' -Name 'AllowStorageSenseGlobal' -Value '0' -PropertyType DWORD -Force | Out-Null

#Collection of telemetry
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'AllowTelemetry' -Value '3' -PropertyType DWORD -Force | Out-Null

#Fix Watson crashes
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting' -Name "CorporateWerServer*" | Out-Null

#Fix 5k resolution support
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'MaxMonitors' -Value '4' -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'MaxXResolution' -Value '5120' -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'MaxYResolution' -Value '2880' -PropertyType DWORD -Force | Out-Null
New-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\rdp-sxs' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\rdp-sxs' -Name 'MaxMonitors' -Value '4' -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\rdp-sxs' -Name 'MaxXResolution' -Value '5120' -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\rdp-sxs' -Name 'MaxYResolution' -Value '2880' -PropertyType DWORD -Force | Out-Null

#Temp fix for 20H1 SXS Bug
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\rdp-sxs' -Name 'fReverseConnectMode' -Value '1' -PropertyType DWORD -Force | Out-Null

#Disable Store auto update
New-Item -Path 'HKLM:\Software\Policies\Microsoft\WindowsStore' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\WindowsStore' -Name 'AutoDownload' -Value '0' -PropertyType DWORD -Force | Out-Null
Invoke-Expression -Command 'Schtasks /Change /Tn "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable'
Invoke-Expression -Command 'Schtasks /Change /Tn "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable'

#Disable Content Delivery
New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Debug' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Debug' -Name 'ContentDeliveryAllowedOverride' -Value 0x2 -PropertyType DWORD -Force | Out-Null

#Mount default registry hive
& REG LOAD HKLM\DEFAULT C:\Users\Default\NTUSER.DAT
Start-Sleep -Seconds 5
New-ItemProperty -Path 'HKLM:\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'PreInstalledAppsEnabled' -Value '0' -PropertyType DWORD -Force | Out-Null
[GC]::Collect()
& REG UNLOAD HKLM\DEFAULT
Start-Sleep -Seconds 5

#Sysprep Mode:VM fix applied
((Get-Content -path C:\DeprovisioningScript.ps1 -Raw) -replace 'Sysprep.exe /oobe /generalize /quiet /quit', 'Sysprep.exe /oobe /generalize /quit /mode:vm' ) | Set-Content -Path C:\DeprovisioningScript.ps1

#Deleting temp folder
Get-ChildItem -Path 'C:\temp' -Recurse | Remove-Item -Recurse -Force
Remove-Item -Path 'C:\temp' -Force | Out-Null


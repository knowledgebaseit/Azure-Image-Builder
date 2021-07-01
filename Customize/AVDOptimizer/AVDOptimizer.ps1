# OS Optimizations for WVD
write-host 'AIB Customization: OS Optimizations for WVD'
$appName = 'Optimize'
$drive = 'C:\Temp'
New-Item -Path $drive -Name $appName  -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = $drive + '\' + $appName 
set-Location $LocalPath
$osOptURL = 'https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/archive/refs/heads/main.zip'
$osOptURLexe = 'Windows_10_VDI_Optimize-master.zip'
$outputPath = $LocalPath + '\' + $osOptURLexe
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $osOptURL -OutFile $outputPath
write-host 'AIB Customization: Starting OS Optimizations script'
Expand-Archive -LiteralPath 'C:\Temp\Optimize\Windows_10_VDI_Optimize-master.zip' -DestinationPath $Localpath -Force -Verbose
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Verbose
Set-Location -Path C:\\Temp\\Optimize\\Virtual-Desktop-Optimization-Tool-main

# instrumentation
$osOptURL = 'https://raw.githubusercontent.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/master/Win10_VirtualDesktop_Optimize.ps1'
$osOptURLexe = 'optimize.ps1'
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $osOptURL -OutFile $osOptURLexe

# Patch: overide the Win10_VirtualDesktop_Optimize.ps1 - setting 'Set-NetAdapterAdvancedProperty'(see readme.md)
Write-Host 'Patch: Disabling Set-NetAdapterAdvancedProperty'
$updatePath= "C:\Temp\Optimize\Virtual-Desktop-Optimization-Tool-main\Win10_VirtualDesktop_Optimize.ps1"
((Get-Content -path $updatePath -Raw) -replace 'Set-NetAdapterAdvancedProperty -DisplayName "Send Buffer Size" -DisplayValue 4MB','#Set-NetAdapterAdvancedProperty -DisplayName "Send Buffer Size" -DisplayValue 4MB') | Set-Content -Path $updatePath

# Patch: overide the REG UNLOAD, needs GC before, otherwise will Access Deny unload(see readme.md)

[System.Collections.ArrayList]$file = Get-Content $updatePath
$insert = @()
for ($i=0; $i -lt $file.count; $i++) {
  if ($file[$i] -like "*& REG UNLOAD HKLM\DEFAULT*") {
    $insert += $i-1 
  }
}

#add gc and sleep
$insert | ForEach-Object { $file.insert($_,"                 Write-Host 'Patch closing handles and runnng GC before reg unload' `n              `$newKey.Handle.close()` `n              [gc]::collect() `n                Start-Sleep -Seconds 15 ") }
Set-Content $updatePath $file

# run script
# .\optimize -WindowsVersion 2004 -Verbose
.\Win10_VirtualDesktop_Optimize.ps1 -Optimizations All -Reboot -AcceptEULA -Verbose
 write-host 'AIB Customization: Finished OS Optimizations script'

write-host 'AIB Customization: WVD Optimize'
$appName = 'Optimize'
$drive = 'C:\Temp'
New-Item -Path $drive -Name $appName  -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = $drive + '\' + $appName 
set-Location $LocalPath
$WVDOptimizeURL = 'https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/archive/refs/heads/main.zip'
$WVDOptimizeInstaller = "Windows_10_VDI_Optimize-master.zip"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $WVDOptimizeURL -OutFile $WVDOptimizeInstaller

write-host 'AIB Customization: WVD Optimize'
Expand-Archive -LiteralPath "C:\Temp\Optimize\Windows_10_VDI_Optimize-master.zip" -DestinationPath "$Localpath" -Force

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Verbose
Set-Location -Path C:\\Temp\\Optimize\\Virtual-Desktop-Optimization-Tool-main
write-host 'AIB Customization: Optimize WVD'
.\Win10_VirtualDesktop_Optimize.ps1 -Optimizations All -AcceptEULA -Verbose
write-host "Optimize WVD Complete"

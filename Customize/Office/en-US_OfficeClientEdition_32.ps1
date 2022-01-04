<#Author       : Dennis Westerman
# Creation Date: 2021-07-15
# Usage        : Office Install en-US 32-bit
#*********************************************************************************
# Date                  Version     Changes
#------------------------------------------------------------------------
# 2021-07-15            1.0         Intial Version
#
#*********************************************************************************
#
#>

##########################################
#    en-US_OfficeClientEdition_32.ps1    #
##########################################
write-host 'AIB Customization: Office 365'
write-host 'AIB Customization: Download Office 365 setup.exe'
$appName = 'Office'
$drive = 'C:\Temp'
New-Item -Path $drive -Name $appName  -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = $drive + '\' + $appName 
set-Location $LocalPath
$SetupURL = 'https://github.com/knowledgebaseit/AIB/raw/main/Customize/Office/setup.exe'
$setupexe = 'setup.exe'
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $SetupURL -OutFile $setupexe

write-host 'AIB Customization: Download XML file en-US 32-bit'
$XML64URL = 'https://raw.githubusercontent.com/knowledgebaseit/AIB/main/Customize/Office/en-US_OfficeClientEdition_32.xml'
$XML64DL = 'en-US_OfficeClientEdition_32.xml'
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $XML64URL -OutFile $XML64DL

write-host 'AIB Customization: Download After Office Install.ps1'
$AOSPS1 = 'https://raw.githubusercontent.com/knowledgebaseit/AIB/main/Customize/Office/After_Office_install.ps1'
$AOSPS1DL = 'After_Office_install.ps1'
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $AOSPS1 -OutFile $AOSPS1DL

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Verbose
Set-Location -Path C:\\Temp\\Office
write-host "Starting Office en-US 32-bit installation"
.\setup.exe /Configure c:\Temp\Office\en-US_OfficeClientEdition_32.xml
.\After_Office_install.ps1
write-host "AIB Customization: Installation Office en-US 64-bit Complete"

<#Author       : Dennis Westerman
# Creation Date: 2021-06-29
# Usage        : Download and install NL Languagepack
#*********************************************************************************
# Date                  Version     Changes
#------------------------------------------------------------------------
# 2021-06-29            1.0         Intial Version
#
#*********************************************************************************
#
#>

#################################
#    Download_NL_Win10_LXP.ps1   #
#################################

write-host 'AIB Customization: Download NL Languagepack'
$appName = 'Languagepack'
$drive = 'C:\Temp'
New-Item -Path $drive -Name $appName  -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = $drive + '\' + $appName 
set-Location $LocalPath
$LanguagepackURL = 'https://www.knowledgebase.it/aib/Languagepack/Languagepack_NL.zip'
$LanguagepackZip = 'Languagepack_NL.zip'
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $LanguagepackURL -OutFile $LanguagepackZip

write-host 'AIB Customization: Unzip NL Languagepack'
Expand-Archive -LiteralPath "C:\Temp\Languagepack\Languagepack_NL.zip" -DestinationPath "$Localpath" -Force

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Verbose
Set-Location -Path C:\\Temp\\Languagepack
write-host 'AIB Customization: Install NL Languagepack '
.\Install_NL_Win10_LXP.ps1
.\Install_Edge_NL.ps1
write-host "Installation Install NL Languagepack Complete"

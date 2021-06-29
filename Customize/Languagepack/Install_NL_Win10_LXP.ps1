<#Author       : Dennis Westerman
# Creation Date: 2021-06-29
# Usage        : Install NL Languagepack
#*********************************************************************************
# Date                  Version     Changes
#------------------------------------------------------------------------
# 2021-06-29            1.0         Intial Version
#
#*********************************************************************************
#
#>

#################################
#    Install_NL_Win10_LXP.ps1   #
#################################

write-host 'AIB Customization: Install NL Languagepack '
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

write-host 'AIB Customization: Unzip NL Language'
Expand-Archive -LiteralPath "C:\Temp\Languagepack\Languagepack_NL.zip" -DestinationPath "$Localpath" -Force

###############################
# Install Language pack Win10 1809 and higher
#
# Created by Patrick van den Born (vandenborn.it)
#
# MS Switched from lp.cab to APPX also called Local Experience Packs
# More info: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/add-language-packs-to-windows
#
# This tool installs the needed CAB and APPX packages
#
# You can download the Language Pack from your volume licensing channel website
#
# In my case: "Windows 10 Language Pack, version 1903"
#
# Create a folder structure like this
#
# \LangPacks         i.e. D:\Win10-1903\LangPacks --> Root folder for LangPacks
# \LXP               i.e. D:\Win10-1903\LXP --> Root folder for Local Experience Pack
#
# Then copy required cab from ISO x64 or x86 folder, for example
# \LangPacks\Microsoft-Windows-Client-Language-Pack_x64_es-es.cab
# \LangPacks\Microsoft-Windows-Client-Language-Pack_x64_fr-fr.cab
# \LangPacks\Microsoft-Windows-Client-Language-Pack_x64_nl-nl.cab
#
# Then copy corresponding Local Experience Pack folders from ISO LocalExperiencePack folder, for example
# \LXP\es-es\LanguageExperiencePack.es-ES.Neutral.appx
# \LXP\es-es\License.xml
# \LXP\fr-fr\LanguageExperiencePack.fr-FR.Neutral.appx
# \LXP\fr-fr\License.xml
# \LXP\nl-nl\LanguageExperiencePack.nl-NL.Neutral.appx
# \LXP\nl-nl\License.xml
#
# The cab and appx files needs to be installed as Admin
#
# To activate the languages, this should be started as user and is marked at the end of this script
#
###############################################

#####################
# Global script vars
#####################
$lp_root_folder = "C:\Temp\Languagepack" #Root folder where the copied sourcefiles are
$architecture = "x64" #Architecture of cab files
$systemlocale = "nl-NL" #System local when script finishes

#####################
# Start installation of language pack on Win10 1809 and higher
#####################
$installed_lp = New-Object System.Collections.ArrayList
foreach ($language in Get-ChildItem -Path "$lp_root_folder\LXP") {
    #check if files exist

    $appxfile = $lp_root_folder + "\LXP\" + $language.Name + "\LanguageExperiencePack." + $language.Name + ".Neutral.appx"
    $licensefile = $lp_root_folder + "\LXP\" + $language.Name + "\License.xml"
    $cabfile = $lp_root_folder + "\LangPacks\Microsoft-Windows-Client-Language-Pack_" + $architecture + "_" + $language.Name + ".cab"
   
    if (!(Test-Path $appxfile)) {
        Write-Host $language.Name " - File missing: $appxfile" -ForegroundColor Red
        Write-Host "Skipping installation of "  + $language.Name
    } elseif (!(Test-Path $licensefile)) {
        Write-Host $language.Name " - File missing: $licensefile" -ForegroundColor Red
        Write-Host "Skipping installation of "  + $language.Name
    } elseif (!(Test-Path $cabfile)) {
        Write-Host $language.Name " - File missing: $cabfile" -ForegroundColor Red
        Write-Host "Skipping installation of "  + $language.Name
    } else {
        Write-Host $language.Name " - Installing $cabfile" -ForegroundColor Green
        Start-Process -FilePath "dism.exe" -WorkingDirectory "C:\Windows\System32" -ArgumentList "/online /Add-Package /PackagePath=$cabfile /NoRestart" -Wait

        Write-Host $language.Name " - Installing $appxfile" -ForegroundColor Green
        Start-Process -FilePath "dism.exe" -WorkingDirectory "C:\Windows\System32" -ArgumentList "/online /Add-ProvisionedAppxPackage /PackagePath=$appxfile /LicensePath=$licensefile /NoRestart" -Wait

        Write-Host $language.Name " - CURRENT USER - Add language to preffered languages (User level)" -ForegroundColor Green
        $prefered_list = Get-WinUserLanguageList
        $prefered_list.Add($language.Name)
        Set-WinUserLanguageList($prefered_list) -Force

        $installed_lp.Add($language.Name)
    }
}

Write-Host "$systemlocale - Setting the system locale" -ForegroundColor Green
Set-WinSystemLocale -SystemLocale $systemlocale

#Generating output for script

Write-Host " "
Write-Host "###########################################" -ForegroundColor Blue
Write-Host "PowerShell Script for users or login script" -ForegroundColor Blue
Write-Host "###########################################" -ForegroundColor Blue
Write-Host '$prefered_list = Get-WinUserLanguageList' -ForegroundColor Blue

For ($i = 0; $i -ne $installed_lp.Count; $i++) {
    Write-Host '$prefered_list.Add(' $installed_lp[$i] ')' -ForegroundColor Blue
}

Write-Host 'Set-WinUserLanguageList($prefered_list) -Force' -ForegroundColor Blue
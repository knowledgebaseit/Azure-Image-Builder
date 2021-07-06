##############################################
#    WVD Optimizer (Virtual Desktop Team)    #
##############################################
    ################################
    #    Download WVD Optimizer    #
    ################################
    New-Item -Path C:\ -Name Optimize -ItemType Directory -ErrorAction SilentlyContinue
    $LocalPath = "C:\Optimize\"
    $WVDOptimizeURL = 'https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/archive/refs/heads/main.zip'
    $WVDOptimizeInstaller = "Windows_10_VDI_Optimize-master.zip"
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest `
        -Uri $WVDOptimizeURL `
        -OutFile "$Localpath$WVDOptimizeInstaller"


    ###############################
    #    Prep for WVD Optimize    #
    ###############################
    Expand-Archive `
        -LiteralPath "C:\Optimize\Windows_10_VDI_Optimize-master.zip" `
        -DestinationPath "$Localpath" `
        -Force `
        -Verbose



    #################################
    #    Run WVD Optimize Script    #
    #################################
    Set-Location -Path C:\\Optimize\\Virtual-Desktop-Optimization-Tool-main
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Verbose
    .\Win10_VirtualDesktop_Optimize.ps1 -Optimizations All -Restart -AcceptEULA -Verbose

##########################
#    Restart Computer    #
##########################
Restart-Computer -Force 

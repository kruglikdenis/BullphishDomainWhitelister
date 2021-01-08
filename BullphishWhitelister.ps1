<#
.SYNOPSIS
    Powershell script for disabling SmartScreen for Trusted Sites and whitelisting domains for BullPhish
.NOTES
    Created by: Martien van Dijk (Avantage IT)
    Date creation: 08-09-2020
    Date Last Update: 08-01-2021
    Version: 1.1
#>

if ($global:timestamp_logfile -gt 0) {
    # Cool, do nothing
}
Else {
    $global:timestamp_logfile = (Get-Date -Format 'd-M-yyyy_HH-mm')
}

function Write-Log {
    <#
    .SYNOPSIS      
        This function is for writing output to a logfile with several severities
    .PARAMETER Severity
        Specifiy the severity of the logging entry
        - Information
        - Warning
        - Error
    .PARAMETER Message
        The message entry       
    .EXAMPLE
        Write-Log -Severity Information -Message "This is a test"
    #>
    [CmdletBinding()]
    param (
        [parameter(
            Mandatory = $true,
            HelpMessage = "Specify log category ('Information', 'Warning' or 'Error'.",
            Position = 2
        )][alias('info')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Information', 'Warning', 'Error')]
        [string]
        $Severity,      

        [parameter(
            Mandatory = $true,
            HelpMessage = "Specify log messaging.",
            Position = 1
        )][alias("msg")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Message        
    ) # End param
    
    $time = Get-Date -Format "d-M-yyyy HH:mm:ss"
    Push-Location $PSScriptRoot
    
    Add-content -path $env:TEMP\BullPhishWhitelister.log -value "$severity $time $message" -passthru
    
} # End function

$TrustedWebsites = @(
    "securityplusrouting.net",
    "bp09-securityawareness.com",
    "mail.bullphishid.com",
    "mail.bullphish.com",
    "train.bullphishid.com",
    "service-noreply.info",
    "myonlinesecuritysupport.com",
    "online-account.info"
)

foreach ($site in $TrustedWebsites) {
    try {
        Write-Log -Severity Information -Message "Create new folder for the URL $($site)."
        New-Item -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains" -Name $site -Force
        Write-Log -Severity Information -Message "Create new folder for the URL $($site).Succeeded"
    }
    Catch {
        $errormessage = $_.exception.message
        Write-Log -Severity Error -Message "Create new folder for the trusted website $($site).Failed Error: $errormessage"
        exit
    }
    try {
        Write-Log -Severity Information -Message "Add $($site) to trusted websites."
        New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\$($site)" -Name "https" -Value 2 -Type DWORD -Force
        Write-Log -Severity Information -Message "Add $($site) to trusted websites.Done"
    }
    Catch {
        $errormessage = $_.exception.message
        Write-Log -Severity Error -Message "Add $($site) to trusted website.Failed Error: $errormessage"
        exit
    }
}

# Disable Smartscreenfilter
Try {
    Write-Log -Severity Information -Message "Disble Smartscreen for Trusted Websites..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" -Name 2301 -Value 3 -Type DWORD -Force
    Write-Log -Severity Information -Message "Disble Smartscreen for Trusted Websites...Done"
}
Catch {
    $errormessage = $_.exception.message
    Write-Log -Severity Error -Message "Disble Smartscreen for Trusted Websites...Failed Error: $errormessage"
}



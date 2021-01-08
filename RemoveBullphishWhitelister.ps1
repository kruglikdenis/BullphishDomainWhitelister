<#
.SYNOPSIS
    Powershell script for removing the BullPhish domains from the Trusted sites and enabling Smartscreen filter for the Trusted websites zone.
.NOTES
    Created by: Martien van Dijk (Avantage IT)
    Date creation: 08-09-2020
    Date Last Update: 08-01-2021
    Version: 1.2
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
    
    Add-content -path $env:TEMP\RemoveBullPhishWhitelister.log -value "$severity $time $message" -passthru
    
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


# Check if URL is on the whitelist and remove if so
foreach ($site in $Trustedwebsites) {
    if (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\$($site)") {
        Write-Log -Severity Information -Message "$($site) is whitelisted. It will ne removed."
        try {
            Write-Log -Severity Information -Message "Removing $($site) from the trusted sites."
            Remove-Item -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\$($site)" -Force
            Write-Log -Severity Information -Message "Removing $($site) fron the trusted sites.Done"
        }
        Catch {
            $errormessage = $_.exception.message
            Write-Log -Severity Error -Message "Removing $($site) from the trusted sites.Failed Error: $errormessage"
        }
    }
}

# Enable Smartscreenfilter
Try {
    Write-Log -Severity Information -Message "Enable Smartscreen for Trusted Websites."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" -Name 2301 -Value 0 -Type DWORD -Force
    Write-Log -Severity Information -Message "Enable Smartscreen for Trusted Websites.Done"
}
Catch {
    $errormessage = $_.exception.message
    Write-Log -Severity Error -Message "Enable Smartscreen for Trusted Websites.Failed Error: $errormessage"
}
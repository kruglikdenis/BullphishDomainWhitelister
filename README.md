# BullPhish ID
Bullphish ID is a security awareness training and phishing resistance training will educate and empower your employees to avoid threats at work and at home.

# BullPhish whitelist domains Powershell Script
## BullphishWhitelister.ps1
The Powershell Script 'BullphishWhitelister.ps1' is preparing your environment to use BullPhish ID phishing simulation campaigns. You need to add the used domains to the trusted websites of your internet browser. Otherwise, you have a chance that your users are not able to access the landings pages. This script is also disabling the SmartScreen Filter. 

## RemoveBullphishWhitelister.ps1
This Powershell Script is inverting the process of the 'BullphishWhitelister.ps1'. It's removing the BullPhish ID websites from trusted websites, and the SmartScreen Filter will be back enabled.

# Quickstart
Just run the scripts. Because these scripts are writing changes to the Windows Registry, you need to have Administrator privileges to run them.
```
PS C:\Users\T13nn3s\Scripts> .\BullphishWhitelister.ps1
```
![BullPhish ID add domains to trusted websites](https://i.imgur.com/35dRf4W.png "BullPhish ID add domains to trusted websites")

```
PS C:\Users\T13nn3s\Scripts> .RemoveBullphishWhitelister.ps1
```
![BullPhish ID remove domains to trusted websites](https://i.imgur.com/9TgBHyr.png "BullPhish ID remove domains to trusted websites")

## Domains being added to the trusted websites
These domains are being added to the trusted websites:
  1) securityplusrouting.net
  2) bp09-securityawareness.com
  3) mail.bullphishid.com
  4) mail.bullphish.com
  5) train.bullphishid.com
  6) service-noreply.info
  7) myonlinesecuritysupport.com
  8) online-account.info

## Smartscreen Filter
This Powershell script is also disabling the Smartscreen Filter for the Trusted Websites Zone. The script 'RemoveBullphishWhitelister.ps1' is enabling back the Smartscreen Filter.

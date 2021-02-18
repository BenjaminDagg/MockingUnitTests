# Changelog

All notable changes to this package will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)

### Created 07/24/2020
- POS for LRAS Lite

## 08/12/2020
Converted POS to .Net Core
- 47070 - POS Conversion to .NET Core

## 14/12/2020
Implement new POS Theme
- 46663 - Implement New theme: code & UI updates - gid rid of side menu, use big buttons on home menu after login. Possibly getting rid of pop ups

##[1.0.0.0] 02/09/2021
- 48991 - Load Machines Connected and Not Connected
- 48987 - Device Management UI Layout
- 48988 - Device Management Settings
- 48989 - Processed Received Socket Data
- 48992 - Set Machines Offline/Online
- 46667 - POS End to End testing
- 50750 - Implement Change Password in new POS Theme
- 50451 - Report Viewer - Clean up styles in Report Viewer Styles .xaml resource dictionary

### fixed
- Log session id issue (was storing object type name instead of session id)
- Minor issues to styles and Device Management after merge
- Issue with Device Manager when connected to same endpoint as the clients
- Fixed issue with report control theme (datepicker, dialog button)
### Updated 
- Project structure
- Refactored Report ViewModel classes
- Navigate user to Login screen after changing thier password


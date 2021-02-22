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
- 50453 - Report Viewer - Test replacing RDL after a build to prove you don’t need to recompile code for RDL changes

### fixed
- Log session id issue (was storing object type name instead of session id)
- Minor issues to styles and Device Management after merge
- Issue with Device Manager when connected to same endpoint as the clients
- Fixed issue with report control theme (datepicker, dialog button)
### Updated 
- Project structure
- Refactored Report ViewModel classes
- Navigate user to Login screen after changing thier password

## 02/16/2021
- 50091 - Cash drawer code for add and remove cash case
- 50092 - Barcode is flipped  when scanned 
- 50094 - Session end Print session Id for receipt
- 50590 - Disable reprint when no reciept found
- 50591 - Resize Device Management UI for multiple resolution

## 02/17/2021
- 50592 - Implementation changed from lastreciept.json to database
- 50593 - SetLastReceipt function remoded as fetching data from database
- 50753 - Dialogbox Closes after reprint
- 50755 - Kiosk mode configured using app settings
- 50072 - Added Report model to include LastRun property and display in Datagrid (still needs to get correct LastRun value)
- 50072 - Update ReportViewer toolbar to not show Page Setup, PageLayout, and default to the "Print View"

## 02/18/2021
- 50452 - Report Viewer - fix data source in RDL’s to be shared data source
## 02/19/2021
- 50889 - Report View - Implement and add Last run date on the reports
- 50927 - Direct user to different tabs based on their role when start up of POS

## 02/22/2021
- 50888 - Fix tab issue with Reports

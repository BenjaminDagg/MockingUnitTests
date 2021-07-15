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

## [1.0.0.0] 02/09/2021
- 48991 - Load Machines Connected and Not Connected
- 48987 - Device Management UI Layout
- 48988 - Device Management Settings
- 48989 - Processed Received Socket Data
- 48992 - Set Machines Offline/Online
- 46667 - POS End to End testing
- 50750 - Implement Change Password in new POS Theme
- 50451 - Report Viewer - Clean up styles in Report Viewer Styles .xaml resource dictionary
- 50453 - Report Viewer - Test replacing RDL after a build to prove you don’t need to recompile code for RDL changes

### Fixed
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
- 50752 - Automated focus in the voucher number text box
- 50755 - Hidden close button in kiosk mode
- Focus on amount in add or remove cash prompt

## 02/23/2021
- 50928 - Create Event Logs for all user POS actions in database

## 02/24/2021
- 51117 - Changed Verbage to Cancel
- 51119 - Payout prompt updated with Total Amount
- 51138 - Font Size updated for Payout Grid
- 51140 - Alert size Updated
- 51141 - Cash Removed Displayed in red
- 51142 - Buttons color theme updated for cash drawer

## 02/25/2021
- 51143 - Payout - Research / Update - Add new feature to cash Drawer section
- 51115 - Added Limit for Max Cash Added
- 51120 - Added hide functionalilty of needs Approval


### Fixed
- adjusted the CashdrawerHistoryPropmtView to fix grid header and button margin
- added pos.ico as resource

## 02/26/2021
- 51147 - POS Device Management Tab - Offline / Online format changes & refresh settings

## 03/01/2021
### Fixed 
- merge issue in CurrentTransationView.xaml

## 03/02/2021
- 51150 update diamond icon based on meeting feedback
- 51115 Added Max cash limit to be checke from Appconfig Table from database
- 51146 buttons resizable last run seen properly only pdf and excel export visible
- 51723 Text And colour for buttons changed according to the Operation Add or remove cash
- 51724 Logout button moved to right
- 51725 Daily cash activity and Promo Enrty Reports added
- 51726 Prompt message changed


## 03/03/2021
- 51840 Layout of cash drawer history changed 
- 51841 Icon Added to Device Management for readability 

## 03/08/2021
- Updated Cancel Voucher - Added barcode and amount to message dialog
- fixed PromptView for MessageboxService

## 03/09/2021
- Updated Config Settings to utilize 'DataConfigItem' to load and use settings from the database
- 51143 utilized MVVM patterns to set/trigger the color changes in the AddRemoveCashPromptView view. 

## 03/10/2021
### Fixed
- Update report views to adjust the run date cut off in the datagrid view
- Update report properties and datasource

### Updated
- Removed 'Daily Cashier Activity' from the application execution folder

## 03/11/2021
- 52232
	- updated 'CashDrawerAmountLimitmessage' to PascalCase 'CashDrawerAmountLimitMessage'

## Updated 
- 52232
	- Changes to UI for consistency 

## 03/12/2021
### Fixed
- Fixed Issue with error handling in LastPrintedRecieptViewModel
- Fixed currency formatting on LastPrintedReceiptView

## 03/15/2021
### Updated
- Added check to ensure printer is configured before each payout transaction
- 52233 - Review POS Requirements and Document comparable changes with OLD POS System

## 03/16/2021
- Updated paremerts for starting balance input and minor UI Fixes
- 52232 - Review POS Requirements and Document comparable changes with OLD POS System

### Updated
- 52232
	- Added Customer duplicate Receipt functionality

## 03/17/2021
### Updated
- 52232
	- Updated UI
### Fixed
- 52232
	- Added condition for using system without cash drawer

## 03/18/2021
### Updated
- 52232
	- Removed the extra seperator from Device management settings
	- seperator height changed for Device management settings
	- Updated voucher validation error messages to include the barcode.
	- Modified Payout Config Keys to have category 'Payout' and consolidate into one class
	- Added functionality to modify receipt printout for Jackpot (show Name and SSN field on receipt)
	- Added bold to payout label and amount on the payout receipt
	- Updated ReceiptLayoutService to use StringBuilder 

## 03/19/2021
### Updated
- 52232
	- Updated Cash Drawer Limit so that the total amount in the cash drawer is bounded by the configured limit
	- Updated the Starting balance functionality to honor the Cash Drawer limit that is configured in database
	- Updated CashDrawerHistory UI text to be configured in resources
	- Code cleanup and refactor variable names for readability
	- Fixed the pop re-appearing after initializaion on loading Payout Screen
	- Updated Alert Messages to fit propery in the designated area
	- Updated Enter Button Style for POS

## 03/23/2021
### Updated
- 52232
	- Updated the sequence number in messages when communication with TCP
## 03/24/2021
- 53400 Tab order changed to Payout-DeviceManagement-Reports-Settings
- 53401 Buttond made bigger for accessibility 
- 53402 Pop up title size increased , Cash Drawer font Increased ,Kepad adjusted and cureent transaction made bigger,Approval checkbox made bigger
- 53501 Reports tab row size and font increased
- 53180 - Implement Turn Promo Ticket On/Off
- 53500 Added Print functionality for Cash drawer History

## 03/25/2021
- 53501 updated font size and renamed report, Removed report Revenue by Machine
- Increased Reports List font
- Increased Device Mansgement tab alert font size
- Renamed Promo ticket Entry Schedule report
- Adjusted font size for Pop up Headers
- 54221 - Modify Handle Error Function in Framework to use UserId
- Add userId in ErrorHanling to ensure that userId is logged with error events
- Adjust/Format Payout Screen - Moved Cashdrawer closer to number Pad, enlarge number pad numbers, widen current transaction view, etc. 
	to fit better on screen; also modified the created date on current transaction view to show the time in smaller font under the date, etc.
- Disable DeviceManagement Views is Device Settings are not available
- 54343 - Remove alert pop up for printing Cash Drawer history
          Modified Cashdrawer history view to show alerts and pass alerts to main view
- 54344 - Enlarge Print Button for cash drawer history
	      Adjust Cashdrawer history view butons to be wider and changed Ok to Cancel
- 54345 - Change the Ok Button to cancel for the Cash Drawer History 
- Added Callback function when Toggling Promo Ticket - this will wait on response to update the UI
- Changed LastReceiptModal to display Alerts on Payout screen when action is complete
- Removed VoucherDetailPromt view and viewmodel as it is not used

## 03/26/2021
- 54342 Loging out session to print session end reciept on close of application
- Added User session to report list view model
### Update
- Format changelog to be more readable- Updated Created Date field on Current Transaction View to alighn with cell data

## 03/29/2021
## Updated
- Added Margin in Cash Drawer history Pop up 
- 53501 Changed backgroud for the Reports Tab
- Changed Font size For Payout settings
- Removed Hover effect from Device Management

## 03/31/2021
# Updated
- Added width to alert to reduce size when no other element present 

## 03/03/2021
- 51840 Layout of cash drawer history changed 
- 51841 Icon Added to Device Management for readability 

## 03/08/2021
- Updated Cancel Voucher - Added barcode and amount to message dialog
- fixed PromptView for MessageboxService

## 03/09/2021
- Updated Config Settings to utilize 'DataConfigItem' to load and use settings from the database
- 51143 utilized MVVM patterns to set/trigger the color changes in the AddRemoveCashPromptView view. 

## 03/10/2021
### Fixed
- Update report views to adjust the run date cut off in the datagrid view
- Update report properties and datasource

### Updated
- Removed 'Daily Cashier Activity' from the application execution folder

## 03/11/2021
- updated 'CashDrawerAmountLimitmessage' to PascalCase 'CashDrawerAmountLimitMessage'

## Updated 
- Changes to UI for consistency 

## 03/12/2021
### Fixed
- Fixed Issue with error handling in LastPrintedRecieptViewModel
- Fixed currency formatting on LastPrintedReceiptView

## 03/15/2021
### Updated
- Added check to ensure printer is configured before each payout transaction
- 52233 - Review POS Requirements and Document comparable changes with OLD POS System

## 03/16/2021
- Updated paremerts for starting balance input and minor UI Fixes
- 52232 - Review POS Requirements and Document comparable changes with OLD POS System

### Updated
- Added Customer duplicate Receipt functionality

## 04/01/2021
- Updated nuget packages since Framework is updated and POS .net Standard projects from 2.0 to 2.1

## Updated
-Changed maximun Voucher Limit
-Added enable disable feature for the last reprint button

## 04/06/2021

## Updated
- Added New Daily Cashier Activity Report
- Changed Colour for Promoticketon/Off Button

## 04/08/2021
 - 54193 - Centrolink and POS – Integration Testing
	 - Reports are now able to connect to the remote server with integrated security disabled
	 - Fixed issue with startup navigation and Starting Balance Dialogue
	 - Added 'TestDbRetryConfiguration' to application config
## Updated
- Changed query after nuget package update for Cash Drawer History

## 04/09/2021
## Updated
- Reduce font size of Current balance to fit the max value
- Removed Promo Entry Report
- Enable disable Last recipt button on payout
- 54193 - Centrolink and POS – Integration Testing
        - Retrieved Last Printed Receipt using the user session id.

## 04/14/2021
## Update
- Retrieved Last Printed Receipt using the user
## Fixed
- 54193 - Centrolink and POS – Integration Testing
        - Fixed Syncgronization issue with Device Management Actions


## 04/15/2021
- 50450 - Report Viewer - Problem with registering Bold Reports license key, still shows trial popup
## 04/21/2021
 - 54193 - Centrolink and POS – Integration Testing
### Fixed
    - Added Validation on ChangePasswordViewModel to disable 'Change Password' button when the form is invalidated
    - Fixed when ChangePasswordViewModel is invalidated users should not be redirected to Login Screen.
    - Fixed Reports View - modified OnViewLoaded to load reports when user is navigated to Reports screen from LoginView

## 05/11/2021
## Update
Including these changes to our release to QA.
1. Permissions:
	   Cashier Tabs - Payout, Device Management
	   Supervisor Tabs - Device Management, Reports
	   Admin Tabs - Device Management, Reports, Settings
2. Permissions - Admins should only have access to Promo-Ticket On/Off
3. Remove word "casino" from all views in the Missouri market

## 05/12/2021
##Updated
Refresh Device Management View within polling time when machine status and ip address is updated in database

## 06/16/2021
## Update
   - Added assembly information to Project file

## 07/09/2021
## Update
 - 61844: 7/8/21 - Device Management Bug Fix
   Device Manager wasnt able to work when more than 4 devices were connected. There was a fix in the way we process large messages from the TP.
 - Changed accessibility of privetely used members to private.

## 07/15/2021
## Fix
62452: POS Machines stay as online when initially set offline
 - Updated check to Active Flag for correct status

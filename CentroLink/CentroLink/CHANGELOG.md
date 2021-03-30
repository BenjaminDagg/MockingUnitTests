# Changelog

All notable changes to this package will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)

### Created 03/02/2021
- CentroLink for LRAS Lite

##[1.0.0.0] 03/02/2021
- 50082 - Promo Scheduler / New Interface

## 03/04/2021
- 51727 - Centrolink - Create Service for Ticket Scheduler CRUD funtionality

## 03/05/2021
- 51728 - Centrolink - Create View in to load Ticket schedules
- 51730 - Centrolink - Create View to edit Ticket schedules
- 51729 Add Promo ticket implemented
- 51731 Delete Promo Ticket Implemented
- 50083 Promo Scheduler New Interface 

### fixes
- Adjusted copy on buttons from 'PromoTicket' to 'Promo Ticket'
- Adjusted/formatted Changelog with dates of changes
- Added external controls for datepicker to exteact time

### Update
- Updated Promo Ticket View formatting

### update
- Formatting/cosmetic changes to Promo Ticket Module

## 03/11/2021
### fixes
- 51729 - Added the Accounting Offset for the start date and end date
- 51730 - Added Checkboxes on Edit View to show if ticket started and/or ended
- 51731 - Modified Delete logic to match old system

## 03/11/2021
### Update
- updated Promo Start DatePicker to be disabled if promo schedule started

## 03/23/2021
- 53041 - Create functionality to toggle Promo Ticket Printing On/Off.

## 03/24/2021
### Update
- Cleanup and Simplified TcpCommunicator logic

## 03/25/2021
### Update
- Update Promo Ticket functionality to prompt and notify user if Print Promo Ticket failed

## 03/29/2021
- Adjusted dimentions for proper rendering in multiple resolution
### Fixed
- Fixed Numeric Textbox Validation issue by setting IsNumeric=true, TargetNullValue='', and modifying validation attributes
- Changed IP Address Validation Regex
- Fixed Issue when creating new user
	- Error: "This SqlTransaction has completed; it is no longer usable."
	- 2 Commits in one method called (refactored to fix)

## 2021-03-30
 - Change validation message for currency from "Value must be whole number"
 - Changed data types in bank module from string to int and decimal
 - removed hard coded "00" as currency format
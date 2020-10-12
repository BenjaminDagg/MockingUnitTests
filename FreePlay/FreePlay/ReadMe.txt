Version 7.2.5.0 - Initial release

Version 7.3.1.0
	- Initial Release to Lottery Branch (46302)
	1) Report title is now Restricted Credit Activity Report. If an alternate title is preferred, the user can change the title by modifying the AlternateReportTitle parameter (only visible when creating subscriptions.)
	2) Report title is now Restricted Credit Activity Status Report. If an alternate title is preferred, the user can change the title by modifying the AlternateReportTitle parameter (only visible when creating subscriptions.)
	3) Subtotals for Denomination and Millennium have been removed. They can be made visible by setting the SingleBetMarket to False (only visible when creating subscriptions.)
	4) Product line has been removed. It can be made visible by setting the SingleBetMarket to False (only visible when creating subscriptions.)
	
Version 7.3.2	
	1) Form headings have been changed to Restricted Credits. Different form headings can be entered by changed the ApplicationTitle setting in the config file.
	2) Application shortcut name has been changed to Restricted Credits
	3) Voucher title has been changed to Play-Only Credits. The voucher title can be changed by modifying the VoucherTitle setting in the config file
	4) Application checksum verification has been enabled.
	5) Ability to view reports within the application has been added.

Version 7.3.3
	1) Added functionality to have different group levels and allowable voucher value ranges for those groups.

Version 7.3.4
	1) Fixed authentication bug
	2) Default database connection config file settings changed to (local) instead of developer settings

Version 7.3.5
	1) Removed "Reports Disabled" pop up dialog.
    2) Removed "Reports" menu item if reports are disabled or cannot connect to report server. (53639)
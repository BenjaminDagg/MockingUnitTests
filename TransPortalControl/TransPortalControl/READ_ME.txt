Version 5.0.2.0
- Changed default path to "TransactionPortal.log" in "Settings" form GroupBox1
- Added "TP Versions supported" label to "frmAbout". Added Func. GetTpVersionsSupported()

Version 5.0.8.0
- Added new Voucher Printing Flag.
- Added ContextMenu.
- Added "SDG Daily Meter Report".
- Added Turn Promo Ticket On/Off.

Version 6.0.2.0
- Upgraded to VB.Net 2005

Version 6.0.7.0
- Added application authentication so files are hashed and comparted to deployed hash value
  if database setting indicates that authentication is required.
  If authentication fails, the application will not start.

Version 7.0.0.0
- Added routine to record application version info to Casino.APP_INFO table.
- Added edit capability for changing Server, Port, and Polling frequency.
- Removed disabling of sending shutdown and startup buttons on the machine manager.
- Added display of machine count to the machine manager window.

Version 7.3.1.0
- PromoScheduler will no longer allow deletion of a schedule if the promotion has started or ended.
- Added the ability to limit schedules of promotions that have ended default is 15 days which can be configured in the config file.
  This will remove clutter of viewing promotions from the past since they can no longer be deleted.
- Log file will now be correctly be placed in the installation path for both 64bit and 32bit operating systems.

Version 7.3.2.0
- Feature: New config setting ApplicationType controls which features are avaliable.
	Value of 1: Only Machine Manager avaliable. Promo and administrative functions are not avaliable.
	Value of 2: Machine Manager and Promo functionality enabled. Administrative functions not avaliable.
	Value of 3: All functions are enabled. Functions such as stopping and starting services will still only function if installed on the server as the transaction portal.

  Version 7.3.3.0
  - Log all Promo Schedule actions (add, delete, modify) to the APP_EVENT_LOG with App_EVENT-TYPE 12 (PromoEntryScheduleChange). (48115)
  - Log all Manual Promo Ticket turn on/off events to the APP_EVENT_LOG with App_EVENT-TYPE 13/14 respectively (PromoEntryManualOn/PromoEntryManualOff). (48115)
  - Restricted Credit Voucher Limitations (46717)
		Three system parameters have been added: 
		RESTRICTED_CREDITS_SUPERVISOR
		RESTRICTED_CREDITS_ADMIN
		RESTRICTED_CREDITS_DEFAULT
		A new group has been added called SUPER_ELEV. In MAS/LRAS, it has identical permissions, but in the Restricted Credits app, it is allowed to set higher voucher values (because it is part of VALUE3 for the RESTRICTED_CREDITS_ADMIN system parameter).

		By default, the app will behave as follows:
		If values of $0.01 to $1 and 1 to 7 expiration days are entered, the two authenticated users must be in the SUPERVISOR, SUPER_ELEV, or ADMIN group.
		If values of $1 to $50 and 1 to 7 expiration days are entered, at least one authenticated user must be in the SUPER_ELEV or ADMIN group.
		If values greater that $50 and/or greater than 7 expiration days are entered, the application will prevent the user from continuing

 Version 7.3.4.0
  - 51037 Within config file the setting TPServerName defaulted to 127.0.0.1 instead of (local) which was not working. 
  - 51149 LogViewer will now correctly use the path specified in the settings and will default to TransPortalControl log viewer. Settings will also check for the existance of the log viewer before saving.
 
 Version 7.3.5.0
  - 51037 Within config file the setting TPServerName defaulted to 127.0.0.1 instead of (local) which was not working. 
  - 51225 TPC can now select shutdowna and startup multiple machines by using CTRL or SHIFT click.
 
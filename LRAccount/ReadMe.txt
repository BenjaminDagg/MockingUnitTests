Lottery Retail Accounting system

Changes:

Version 6.0.2
- Dropped UNIQUE_ID display from the Casino maintenance form (underlying column was unused so it was removed).
- Added checkbox controls to the Casino Maintenance form for new columns 'Print Raffle Tickets' and 'Print Prize Redemption Tickets'.
- Bank maintenance screen now allows editing of Machine and DBA Lockup Amounts.


Version 6.0.4
- Fixed frmPayoutMS::PerformVoucherPayout bug that does not correctly convert voucher amounts with commas, resulting in the
  lack of payout authorization for jackpot vouchers that are greater than the CASINO.LOCKUP_AMT and are also greater than
  $999.99.  Note that this fix is in version 6.0.4 but not in subsequent versions until version 6.0.8.


Version 6.0.7
- Added application authentication (GLI requirement).  Spawns new support application (MasAuth.exe) if authentication
  is required by a database setting. Creates hash value using CasinoAccount.exe, MasAuth.exe, and DgeHashLib.dll.
  That file list is contained in file MasAuth.exe.config.
- Dropped reference to CheckSumValidation library (no longer required).
- Fixed repeated barcode on subsequent receipts bug (when printing voucher receipts).
- Modified Voucher Detail report to show Created location as CASINO_MACH_NO and MACH_NO - ie [ 22020 (00020) ]


Version 7.0.0
- Fixed frmPayoutMS::PerformVoucherPayout bug that does not correctly convert voucher amounts with commas, resulting in the
  lack of payout authorization for jackpot vouchers that are greater than the CASINO.LOCKUP_AMT and are also greater than
  $999.99.  Note that this fix was made version 6.0.4 but not in subsequent versions until this version.

- Modified Form, Bank, DEAL, and Machine edit screens to conform to schema changes
  (dropped columns: BANK.FORM_NUMB, CASINO_FORMS.PROG_IND and PROG_PCT, DEAL_SETUP.PROG_INT, PROG_PCT, and PROG_VAL)

- Modified Payout_MS so when changing from CashDrawer tab to Vouchers tab, voucher info is cleared and the payout
  button is hidden.  Also changed GetVoucher routine so if the voucher is less than 1 cent, the payout button is
  hidden and the message 'Amount too small for payout.' is displayed.

- Modified Casino maintenance to allow editing of:
  - MAX_BAL_ADJUSTMENT value to control the maximum adjustment value that will be made.
  - Claim and Daub timeout seconds (for bingo)
  - Jackpot Lockup checkbox
  - Cashout Timeout in minutes
  - Progressive Request interval (5 default to 30 seconds) to control how often machines request progressive updates.

Version 7.2.2
- Modified frm_MachSetup to handle removal of columns MACH_DENOM, FORM_NUMB, and MAC_ADDR from MACH_SETUP.
- Modified Imp_Connect.cls for removed MACH_SETUP columns.

Version 7.2.3
- Added frm_SSRSREportViewer to view SSRS reports from MAS.
  Required adding new menu item mnuSSRSReports to MDI main form.

- Added frm_RevShare to allow Rev Share to be changed in the field.


LRAS
Initial version is 2.0.0

Version 2.0.3
- Added code to the Location editor (frm_Casino) to prevent overflow of PayoutAuthorization (Lockup) and Max Balance   Adjustment values.

- Added code to the Location editor (frm_Casino) to hide the 'Add' button if there is a Location (Casino)
  recored in the grid control.

OLG LRAS
Initial version is 3.0.0
- Branched from DC Lottery LRAS.
- Removed main screen graphic.
- Removed icons from all forms.


Version 3.0.1
- Fixed Location screen so it does not default to 'DC', now defaults to 'OL'(Case 22586).
- Fixed Location screen validation error message for invalid retailer number (Case 22587).
- Added 2 digit year to cashier session id to make it more unique Case (Case 17384).
- Modified payout form GetVoucherInfo routine to if the scanned voucher validation id is
  not valid, the message box that shows the error is not immediately dismissed because of
  the CrLf sent from the scanner (Case 16934).


Version 3.0.2
- Change label text from 'State' to 'Province' and 'Zip' to 'Postal Code' on the Location
  Add and Edit screens (Case 22658).
- When saving a Location record in Add mode, the System Setup button no longer appears (Case 22801)
- When saving a location record in Add mode, the Retailer Number may be blank or 5 numeric characters,
  before it was a required entry.

Version 3.0.3
- Removed $1 and $2 columns from Drop reports (case 23070).
- Changed warning message from 'No Default Casino found.' to 'No Default Retail Location found.' (case 23300).

Version 3.0.4
- Fixed issue where logon attempts by disabled users resulted in a Successful Login entry in the LOGIN_INFO security audit table. (Case 25011)
- Fixed cashier to correctly timeout suspended sessions. (Case 24670)
- Added Functionality for Users to change their password via the Change Password interface. Option located under File->Change Password (Case 25188)
- When a user is created or an existing user's password is reset by an admin, the user will be prompted to change their password and 
  taken to the Change Password interface. (Case 25191)
- Password complexity requirements changed to include (1) At least 8 characters.
(2) One uppercase letter.
(3) One lower case letter.

  (4) One digit.
(5) One symbol  (Case 25097)
- Password expiration functionality added. Passwords will now expire within 90 days (configurable) at which time he/she will be
  prompted and  required to change their password before proceeding. Additionally, if a user logins in within 5 days (configurable) of 
  expiration the user will be reminded with each successful login and given the option to change their password. Case (25096)
- Password history requirement. When users change their password, their previous passwords will be tracked as an encrypted MD5 hash and the 
  user will not be able to use their 9 most recent passwords. Admin password resets are not tracked and do not count towards the user's 
  password history. (Case 25095)
- When a user has more than 10 failed login attempts within 30 minutes (configurable values), the account will be locked for 30 minutes. 
  The user will either need to wait out the lockout duration or have an administrator unlock their account from the Permissions interface.
  (Case 25098, 25099, 25100).
- New security logging functionality for all password and security changes in build.
  (1) Password changes. (2) Account lockouts. (3) Unlock of user's account. (4) Password expiration. 


Version 3.0.5
- Fixed issue where once a locked user is unlocked and the user enters an invalid password again, the account will never lock up (Case 25551).
- Fixed issue where System setup button appears after saving a new location in the Location Setup interface. (case 22801)
- Fixed login procedure to prevent app crash when password or username is less than 4 characters. Additionally user is logged out 
  when if he/she fails to change a reset or expired password. (Case 25542)
- Fixed password strength enforcement symbol requirement fixed to only allow symbols and underscore. Before symbol requirement was 
  being fulfilled by any symbol including letter or digit. (Case 25546)

Version 3.0.6
- Added Game Description and Unplayed Rolls to the Deal Inventory report
  (file cr_InventoryByDeal_MD.dsr).
  Required modification to stored procedure rpt_DealInventoryPaper (case 25764)
- Modified frm_DealStatus.frm to display the correct Game Description (case 25764)
- Modified frm_Payout_MS.frm to add the year to the cashier session ID when a
  session has timed out and a new session is started (case 25743)
- When attempting to authorize a payment, supervisors will have a login limit
  of 3 (configurable) until their account is locked at which time an admin
  will need to unlock. (Case 28507)

Version 3.0.7
- Receipt Printer will no longer print if a Receipt printer is not setup. (Case 31549)
- When the user logs off, all open windows will forcibly be closed.  (Case 31552)
- Removed all keyboard entry functionality from the voucher combo box while 
  in manual mode in the Payout Interface with the exception of up/down/left/right 
  arrows and space. Resulting in the inability to scan vouchers while in Manual 
  mode and only select from the dropdown. (Case 31554)
- Triple Play Deal Analysis window now correctly displays individual deals in 
  the dropdown (case 31553)
- LRAS Payout functionality has been modified to a multi-voucher payout station. 
  Interface, reports and print out of receipts have been changed to support this feature. (Case 32002)

Version 3.0.8
- LRAS will check central system for existing DGE/Location IDs to avoid ensure a casino with the same LocationID and name does not exsist. (Case 23422)
- When using the machine replicate functionality, the serial number is now editable. (Case 23726)
- The machine setup menu will now list the bank's GTC in the dropdown description. (Case 23785)
- Any selected machine can now be replicated in the machine setup menu. LRAS will search for the next available machine number following the selected machine.
  The next machine number will be displayed before creation. (Case 31592)
- A key/legend has been added to the machine setup menu. (Case 31309)
- There is a new error message on the group permissions menu. (Case 32367)
- The ADMIN group cannot be deleted/edited in the group permissions menu. (Case 32380)
- After every button click on the Payout screen, the focus should return to the voucher text box. (Case 32426)
- Delete button in the system parameters menu has been removed. (Case 31600)
- Messaging on the voucher payout menu has been edited. (Case 32425)
- The log in dialogue will appear when the user logs out. (Case 32278)
- Cash drawer functionality is now available. (Case 24034)
- Permission have been added to make the drop report visible for supervisors. (Case 34875)
- Added IMPORT_PARAMETERS system parameter that defines the prefix for the market. (Prefix for Ontario is OL.) Value2 defines the valid CAS_ID/XML prefix for a lottery market with a central server. Value3 enables/disables the central functionality for check. (Case 38274)
- Added COUNTRY_CODE system parameter. If country code is USA, a State field will appear in the location setup menu of LRAS. Otherwise, there will be Province field. (Case 38274)
- Inputting a long username (11 characters or more) while logging into LRAS causes LRAS to crash (Case 38635)
- Test deal games can now be loaded (Case 38648)
- Added Tito Licesne notice to About Page (Case 38663)

Version 3.0.9
- Fixed error during manual mode in the new MultiVoucher Payout station. Textbox focus was causing validation issues. (Case 38791)
- When replicating a machine, the IP Adresses will no longer include line break characters. '/0' (Case 38733)
- LRAS will throw an error if user inputs a barcode with a length greater than 18 (Case 38810)
- In new MultiVoucher Payout station, the reciept will no longer round round to nearest dollar (instead of nearest cent). (Case 38836)

Version 3.1.0
- Change Password functionality is now active. (38884)
- Fixed keyboard navigation tabbing order in the Add Machine interface. (38884)
- Ability to print a second recipet has been added. This option is controlled by PRINT_CASINO_PAYOUT_RECEIPT on the database. (38602) & (38803)
- When adding a new machine. Application will check for existing machines and IP addresses before attempting to save to database. User friendly message will be displayed if IP address already taken. (38880)
- User Permission interface now has the appropriate minimum length for Security Level textbox. User friendly error message is now displayed. (39022)
- Weekly Event Status report will now wrap the text within the description row. (38863)
- Jackpot report will now wrap the text within the description row. (31588)

Version 3.1.1
- When scanning multiple vouchers, the vouchers will appear and print in the order scanned. (42669)
- The machine description will be cleared when a bank is selected in the Add Machine screen. (42609)
- Deal Status interface will longer cause a errounous error message to display when double clicking the Reopen Deals Button. (42615)
- Replicate Machine: The textbox background for certain fields should now reflect whether the textbox can be edited. (42664)
- Voucher Out field added to Daily Revenue By Machine Reciept Report.


Version 3.1.2
- Voucher Out added to Daily Revenue by Machine receipt printer to be able to better reconcile accounting issues. (42761)
- System parameter ALLOW_MANUAL_PAYOUT has been added to database. If it is false, the Automatic/Manual radio 
  buttons will not be available in the Payout Voucher interface regardless of permissions. (42911)

Version 3.1.3
- Fix error message to user when selecting fucntion 32 (Paramaters function) in the Group Permissions interface. This was caused to the description containing commas, the data is supposed to be comma delimeted. (43022)
- The more user friendly error message will appear when attempting to delete an admin in the Group Permissions interface. (43024)

Version 3.1.4
- Drop reports will now show $1, $2 bills for USA markets. For CAN markets there will be empty space. (43743)
- Added support for LocationID being 6 digits if setup in CASINO_SYSTEM_PARAMETERS. (43738)
- Machine Activity Report will now hide Denom,Coins,Lines,PressUp fields if if VALUE1 of REPORT_EXCLUSION_OPTIONS (CASINO_SYSTEM_PARAMTER) table is set to true. (43752)
- VoucherIn fields can now be hidden from Voucher if VALUE2 of REPORT_EXCLUSION_OPTIONS (in CASINO_SYSTEM_PARAMTER table) is set to true. (43837)
- LocationID will now be included in all reports if ALLOW_LOCATION_ID_REPORTS (in CASINO_SYSTEM_PARAMTER table) is set to true. V1 = Controls Reports, V2 controls Reciept Reports (43765)
- Full Voucher Number on reports can be made visible to Admin users if VALUE1 of REPORT_SECURITY_OPTIONS (in CASINO_SYSTEM_PARAMETER) is set to false. 
  Reports affected: Machine Activity Report, Voucher Liability Reports, Cashier Bank Report  (43988)

Version 3.1.5
- In Machine Setup screen (Edit or Replicate) user will now recieve a prompt if trying to enter a prompt that was already taken. (38737)
- Machine Setup interface, removed machines will now correctly have a black forground and offline will have a red foreground. (42647)
- Validation has been added to Cash Drawer functionality to ensure a correct dollar value range is used. (42733)
- Added functionality for Promo Entry tickets. (34883)
- Added Central User login functionality via system parameter ALLOW_CENTRAL_LOGIN. On an unsuccessful local login attempt LRAS will try to authenticate against 
  LMS user. All password locking and security are implemented for remote login. Login events will be recorded on both systems (if the username is not initially found in the LotteryRetail database.) (44260)

Version 3.1.6
- Machine activity report now contains a Machine Date/Time column, and most transactions should contain a machine timestamp. (45274)
- When viewing voucher details, if supervisor authentication is required it will be subject to the same lockout functionality as authenticating a voucher. (45297)
- VALUE2 of REPORT_SECURITY_OPTIONS if set to True will now hide actual & theo. hold percent on Deal Setup interface and TPP Deal Analysis Report. (45297)
- After changing password, user no longer needs to log out and log back in to use cash box functionality. (44924)


Version 3.1.8
- Note: Restricted Credit Functionlity was introduced to Lottery System in 3.1.7 some minor changes needed to be made in 3.1.8 LRAS to supported this functionality. 
- LRAS will not allow the payout of restricted credit vouchers.(46563)
- Restricted Credit Vouchers will no longer show on the Liability report since they cannot be cashed at a POS and are therefore not liabilities. (46575)
- Machine In Use interface will now display the Balance + Promo Balance Previously only Balance was used which caused machines with promo only to not appear. (46580)
- Changed the data type of VoucherId variable from an integer to a long in the Payout Terminal. This is to prevent overflow issues when exceeding the limit of interger data types in LRAS application. (46739)

Version 3.1.9
- If Manual mode is disabled in the Payout functionality, Manual and Automatic radio buttons will no longer appear after canceling out of Cashbox functionality.

Version 3.2.0
- Log Promo Entry Factor and Amount changes to the App_Event_Log. 
- Restricted Credit columns added to Revenue Reports

Version 3.2.1
- Retailer ID length requirement is now configurable from 1 to 8 digits.
- Voucher payout functionality can disabled when marked by the central system.
- Voucher expiration can now be normalized to the accounting end time.
- Added functionality to authenticate central users via a web service.
- Site must be validated/confirmed on the central system before it can be setup on the retail system. Retailer info is pulled from the central to the retailer.
- Menu item visibility will be determined by the existence of an entry in the SYS_FUNCTIONS table.

Version 3.2.2
- Added functionality to dynamically generate SSRS report menu.

Version 3.2.3
- Added functionality to inform users when SSRS permissions are not present.
- Fixed bug where RetailSiteStatus was not updating correctly.

Version 3.2.3
- Added functionality to auto generate DGE_ID and LOCATION_ID based on RetailerNumber.

Version 3.2.5
- Added functionality to use SSL web address

Version 3.2.7
- Removed redundant login for LRReportViewer SSRS report functionality

Version 3.2.8
- Changed minimum username length from 4 characters to 3 characters to be consistent with LMS central connection. (52748)
- Diamond Game Logo on About screen changed (52691)
- When user logs in with an already active session that was not terminated correctly, that session is closed automatically (52066)
- PROG_REQUEST_SECONDS when creating a new site is configurable via the CASINO_SYSTEM_PARAMETERS (52574)
- When creating a new user, the username field will no longer allow non-alphanumeric characters such as !,?,&  (52914)

Version 3.2.9
- Changed Machine Activity Report to show all 64 chars of Machine Description in Machine Activity Report (53409)
- Changed Revenue By Machine Report to show full column names and headers (53342)
- Changed report titles in LRAS to be capitalized to Report to match rest of report name. (53630)
- Changed column width to show full column name "Dollars Won" (53623)
- Changed report titles in LRAS to be capitalized to Report to match rest of report name. (53632)
- Fixed column header for revenue by machine report (53796)
- Voucher Reciept Number changed to long data type to allow cashout of vouchers in certain busy locations. Before it crashed with overflow exception if Voucher_Receipt_NO is greater then 32767
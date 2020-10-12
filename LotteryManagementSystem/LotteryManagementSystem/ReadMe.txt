Lottery Version 2.0.6.0

- (Case 21307) Modified to support both DC and Ontario through configurable options. 

- (Case 20920) Added strong password policy. Configurable option.
    1. Must be at least 8 characters in length.
    2. Contain at least one upper and lower case.
    3. Contain at least one digit or symbol.
    4. Cannot contain username or the words 'pass' or 'password' in any case combination.
    
- (Case 20921) Added tracking of login attemps, security changes and report access. 

- (Case 20911) Removal of Logos from LMS reports for Ontario

- (Case 22460) Added application authentication.


Lottery Version 2.0.7.0

- (Case 22567) Fixed authentication error by including msgDigest file into the setup package.

- (Case 22567) Changed all passwords to default.

Lottery Version 3.0.2.0

- Changed the version from 2.0.7 to 3.0.2

- (Case 22734) Modified the header name in the Location View form to
               "State/Province" and also in the Location Add/Edit form.

- (Case 22844) Retail and Sweep numbers are no longer required.


Lottery Version 3.0.3.0

- (Case 22863) All windows will now be maximized

- (Case 23471) Removed the DGESmartForm reference

Lottery Version 3.0.4.0

- (Case 23471) Removed the DGESmartForm.dll reference from the AppAuthList

- (Case 25423) Added code to terminate the application if required AppSettings are missing

- (Case 24432) Added new Daily Activity by Site SSRS report

- (Case 24421) Added new Expired Vouchers By Site SSRS report

- (Case 25102) Added Enforce Password History

- (Case 25103) Added maximum password age

- (Case 25104) Added password complexity requirements

- (Case 25106) Added account lockout threshold

- (Case 25108) Added reset account lockout counter

- (Case 25422) Added Unlock button in AppUserAddEdit

Lottery Version 3.0.5.0

- (Case 25494) Added splash screen when application starts up

- (Case 25484) Modified the unlock stored procedure to clear the failed attemtps counter,
               last failed attemtp date and time and the locked flag

- (Case 25488) Error was caused because all forms were opening maximized.
               Forms will no longer open maximized.

- (Case 25492) Changed the font forecolor to white.

- (Case 25546) Modified the ItemValueText for the EnforcePasswordPolicy AppSetting.

- (Case 25609) Modified the code to not save the last window state is maximized.

Lottery Version 3.0.6.0
- (Case 36882) During login if username is invalid, a user friendly message is displayed.
- (Case 42505) When payout functionality is enabled at the central site, 
               LMS will now check the transfered flag prior to validating vouchers as an additonal 
			   safety measure to reduce minor issues if incorrect replication is setup on the voucher table.

Lottery Version 3.0.7.0
- (Case 42884) LMS will now ping the web service to check for avaliable reports. Invalid report address will prompt a user friendly message.
- (Case 42097) After a fresh install, the login user name will be blank instead of 'Guest'
- (Case 42934) Now if no receipt data is found the following message will display: "There is no prior receipt available reprint.


Lottery Version 3.0.8.0
- (Case 42933) Modified the payout screen to display an error image when voucher does not exist. Minor visual indictator.
- (Case 43018) When LMS is installed it will default to (local) and (localhost) default settings.
- (Case 43064) Save button will be disabled if there are no flex numbers available. Added AllowFlexNumbers setting to AppSetting to set whether menu item is available.
- (Case 43066) Voucher Lot Status. Max Length of Voucher number set to 14.

Lottery Version 3.1.0
- (Case 43063) User can no longer use the word password (case insenstive) for their password.
- (Case 43757) LMS menus and reports can be disabled or enabled via the AppPermissionToGroup table in the database. 

Lottery Version 3.1.3
-  Modified application to be comptable with LotteryCentral Database 5.0.2

Lottery Version 3.1.3.1
-  51062 - Fixed Error when attempting to AddUser. 
-  52289 - Fixed AppUser First and Last names being listed incorrectly on View Users and Edit User.
-  52739 - Fixed AppUserEdit to allow unlocking of accounts after 10 failed password attempts.

Lottery version 3.1.4
-  52749 - Updated username to be between 3 and 10 characters.
-  51326 - Config file now defaults to database server (local) instead of developer settings.
-  52210 - Fixed report menu to not error out after first report loads. The same report can be opened any number of times. 

Lottery version 3.1.4.1
- 52950  - Changed Diamond Game logo on About interface
- 53088  - LMS username creation will to not allow usernames with non-alphanumeric chars.
- 53098  - Changed LMS InsertLogEvent sql code to correctly look up current userid to insert into EventLog table.

Version 7.2.4
- Modified Archiving to speed up the process:
  - No longer performs compression and no longer writes to CD
  - Data truncation process modified using temp tables to save time.
  - Archive times will be 1/4 to 1/2 of previous times.

DC Lottery Version 2.0.0.0
- Modified to import Paper Deals generated for DCL001 at any DC Retail location.

DC Lottery Version 2.0.1.0
- Added check to disable loading deals already loaded at other retail locations.

Lottery Version 3.0.0.0
- Modified to support both DC and Ontario (allow import of exported deals from
  OLG001 and OLGTST).

- Added strong password policy.
    1. Must be at least 8 characters in length.
    2. Contain at least one upper and lower case.
    3. Contain at least one digit or symbol.
    4. Cannot contain username or the words 'pass' or 'password' in any case combination.
    
- Added login tracking to LOGIN_INFO table.

Lottery version 3.0.2.0
- Removed menu items, forms, and references not used in a retail lottery setting (Case 22830).

  - Menu items: mnuScanDealRolls, mnuImportMasterDealsCompact, mnuImportMasterDealsBingo,
                mnuImportC3P, mnuDealSequence, mnuArchiveData, mnuDropOldEDeals,
                mnuGameSettings, mnuReportMasterDealImport

  - Forms: frmArchive, DealRollScan, CompactMasterImport, BingoMasterImport, DbArchive,
           DealSequence, eDealLoader, GameSettingsSelect, GameSetupBingo, GameTypeSelect
           ImportAmdBingo, ImportAmdC3P, ImportAmdEZTab2

  - References: CompLib, CDWriterXPLib, AxCDWriterXPLib, Xceed.zip

Lottery version 3.0.3.0
- Added support for new column ProductLine.EGMDealGCMatch. The new column provides a
  data-driven method, by ProductLine, to determine if the Game Code of an EGM must
  be the same as the Game Code of a Deal.

- Removed tabs on the Settings form that are not needed for a Lottery setting. Also
  removed corresponding config file settings.


Lottery version 3.0.4.0
- Modified import to update new column CASINO_FORMS.MASTER_HASH

Lottery version 3.0.8
- Validation to ensure the deal being imported is for the casino is now configurable via CASINO_SYSTEM_PARAMETERS table entry 'IMPORT_PARAMETERS'
- Deal Import will check the central system for the currently active CAS_ID. If it does not exist, the application will not allow a deal to be imported. This isn't a foolproof check for active replication. It only checks to see that replication was active at some point. This check will not be done if the central functionality is disabled in the CASINO_SYSTEM_PARAMETERS. (Case 23423)

Lottery version 3.1.0
- Invalid Account or Password will now appear for any DealImport login attempts. Change for consistentcy. (38631)
- LRDealImport will now import the Exported_Date field into the DEAL_SETUP table on the database. For reporting purposes. (39422)
- DealImport will now a new entry MASTER_CHECKSUM if the value exists in export data. This is to provide better version tracking and authentication for new deals. (39395)
- Updated certain central inqueries to be increase comptability with future database releases. Reduces complexity of updating Ontario. (39543) 

Lottery version 3.1.3
- While import a Deal, the application will now push GameCode, MasterHash and WinsPerDeal data to LMS correctly. This will resolve some blank reporting issues on LMS. (43164) 

Lottery version 3.1.6
- Changed Progressive Type ID type to support a value over 255. 
- During import, EGM_MATCH_DEAL_GC will be false for all paper types for Ontario Market. The functionality for Ontario has been moved to tpTransH. This is to support 
  both paper types. 2-ply will still require the deal to be played with the Game Title it was generated for, single ply will allow a deal to be played with a title of the same game family and math model.

Lottery version 3.1.8
- Changed the data type of ProgressiveTypeId variable from Tinyint to Int to allow values over 255.
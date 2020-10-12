SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure Name: GetCentralAutoRetailSetup

Created By:     Louis Epstein

Create Date:    04-22-2014

Description:    Gets retail information from the central server based on given retail number
Returns the following rows: 
SiteId, RetailerNumber, FirstSalesDate, FullName, AbbreviatedName, StreetAddress, 
City, State, ZipCode, PhoneNumber, FaxNumber, MailingName, MailingStreetAddress, 
MailingCity, MailingState, MailingZipCode

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 04-22-2014     v3.2.1
  Initial Coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[GetCentralAutoRetailSetup] 
      @RetailerNumber VarChar(8)
AS

SET NOCOUNT ON

DECLARE @sqlQuery nvarchar(max)

SELECT @sqlQuery = VALUE1 + '.GetRetailSetup ''' + @RetailerNumber + '''' FROM dbo.CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'CENTRAL_SERVER_LINK'
EXEC(@sqlQuery)


  
GO

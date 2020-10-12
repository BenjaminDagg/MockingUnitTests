SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: GetRetailSetup

Created By:     Louis Epstein

Create Date:    04-22-2014

Description:    Gets retail information from the based on given retail number
Returns the following rows: 
SiteId, RetailerNumber, FirstSalesDate, FullName, AbbreviatedName, StreetAddress, 
City, State, ZipCode, PhoneNumber, FaxNumber, MailingName, MailingStreetAddress, 
MailingCity, MailingState, MailingZipCode

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 04-22-2014     v5.0.0
  Initial Coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[GetRetailSetup]
@RetailerNumber varchar(8)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM [Site] S
JOIN SiteStatus SS ON SS.SiteId = S.SiteId
JOIN AppUser AU ON AU.AppUserId = SS.LastModifiedByAppUserId
LEFT OUTER JOIN CASINO C ON C.RETAILER_NUMBER = S.RetailerNumber
WHERE S.RetailerNumber = @RetailerNumber AND S.ApprovalDate < GETDATE() AND C.CAS_ID IS NULL)
BEGIN 
SELECT 
S.[SiteId]
,S.[RetailerNumber]
,S.[FirstSalesDate]
,S.[FullName]
,S.[AbbreviatedName]
,S.[StreetAddress]
,S.[City]
,S.[State]
,S.[ZipCode]
,S.[PhoneNumber]
,S.[FaxNumber]
,S.[MailingName]
,S.[MailingStreetAddress]
,S.[MailingCity]
,S.[MailingState]
,S.[MailingZipCode]
,SS.StatusCode AS SiteStatusId
,AU.UserName
,SS.StatusComment
FROM [Site] S
JOIN SiteStatus SS ON SS.SiteId = S.SiteId
JOIN AppUser AU ON AU.AppUserId = SS.LastModifiedByAppUserId
LEFT OUTER JOIN CASINO C ON C.RETAILER_NUMBER = S.RetailerNumber
WHERE S.RetailerNumber = @RetailerNumber AND S.ApprovalDate < GETDATE() AND C.CAS_ID IS NULL
END
ELSE
BEGIN
SELECT 
-1 AS [SiteId]
,NULL AS [RetailerNumber]
,NULL AS [FirstSalesDate]
,NULL AS [FullName]
,NULL AS [AbbreviatedName]
,NULL AS [StreetAddress]
,NULL AS [City]
,NULL AS [State]
,NULL AS [ZipCode]
,NULL AS [PhoneNumber]
,NULL AS [FaxNumber]
,NULL AS [MailingName]
,NULL AS [MailingStreetAddress]
,NULL AS [MailingCity]
,NULL AS [MailingState]
,NULL AS [MailingZipCode]
,NULL AS SiteStatusId
,NULL AS UserName
,NULL AS StatusComment
END


END
GO

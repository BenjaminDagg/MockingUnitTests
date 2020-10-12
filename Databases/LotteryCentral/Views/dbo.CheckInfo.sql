SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [dbo].[CheckInfo]
AS
SELECT CP.[CheckId]
      ,CP.[CheckNumber]
      ,CP.[CheckAmount]
      ,CP.[DatePrinted] AS CheckPrintedDate
      ,CP.[IsVoid] AS CheckIsVoid
      ,CASE WHEN CP.IsVoid = 1 THEN 'Void' ELSE 'Valid' END AS CheckStatus
      ,CP.[PreviousCheckNumber] AS ReplacedCheckNumber
      ,CP.[DateVoided] AS CheckVoidedDate
      
      ,VP.VoucherId
      ,VP.Barcode AS VoucherBarcode
      ,VP.TransAmount
      ,VP.PosWorkStation AS PayoutWorkstation
      ,VP.PayDateTime AS VoucherPayoutDate
      
      ,VPR.[VoucherPayoutReceiptId] 
      ,VPR.IsVoid AS ReceiptIsVoid
      ,CASE WHEN VPR.IsVoid = 1 THEN 'Void' ELSE 'Valid' END AS VoucherPayoutReceiptStatus
      ,VPR.PreviousVoucherPayoutReceiptId AS ReplacedReceiptId
      ,VPR.CashoutDate AS ReceiptIssuedDate
      
      ,CPI.FirstName + ' ' + CPI.LastName AS CheckIssuedToFullName
      ,CPI.FirstName AS CheckIssuedToFirstName
      ,CPI.LastName AS CheckIssuedToLastName
      ,CPI.[Address] + CHAR(13)+CHAR(10) + CPI.City + ',' + CPI.[State] + ' ' + LEFT(CPI.ZipCode, 5) + '-' + RIGHT(CPI.ZipCode, 4) AS CheckIssuedToAddress
      ,CPI.[Address] AS CheckIssuedToStreetAddress
      ,CPI.City AS CheckIssuedToCity
      ,CPI.[State] AS CheckIssuedToState
      ,LEFT(CPI.Zipcode, 5) + '-' + RIGHT(CPI.ZipCode, 4) AS CheckIssuedToZipcode
      ,CASE WHEN CPI.SSN IS NULL THEN NULL ELSE dbo.unf_DecryptValue(CPI.SSN) END AS CheckIssuedToSSN
      
      ,CS.[CentralSiteId]
      ,CS.CentralSiteName AS PayoutLocationName
      ,CS.StreetAddress + CHAR(13)+CHAR(10) + CS.City + ',' + CS.[State] + ' ' + LEFT(CS.ZipCode, 5) + '-' + RIGHT(CS.ZipCode, 4) AS PayoutLocationAddress
      ,CS.StreetAddress AS PayoutLocationStreetAddress
      ,CS.City AS PayoutLocationCity
      ,CS.[State] AS PayoutLocationState
      ,LEFT(CS.ZipCode, 5) + '-' + RIGHT(CS.ZipCode, 4) AS PayoutLocationZipCode
      
      ,V.VOUCHER_TYPE AS VoucherTypeId
      ,V.CREATE_DATE AS VoucherCreateDate
      ,V.CREATE_DATE AS VoucherPrintDate
      ,V.CREATED_LOC AS VoucherPrintedByMachine
      
      ,S.RetailerNumber
      ,VP.LocationId AS RetailerLocationId
      ,S.FullName AS RetailerName
      ,S.StreetAddress + CHAR(13)+CHAR(10) + S.City + ',' + S.[State] + ' ' + LEFT(S.ZipCode, 5) + '-' + RIGHT(S.ZipCode, 4) AS RetailerLocationAddress
      ,S.StreetAddress AS RetailerStreetAddress
      ,S.City AS RetailerCity
      ,S.[State] AS RetailerState
      ,LEFT(S.ZipCode, 5) + '-' + RIGHT(S.ZipCode, 4) AS RetailerZipCode
      ,'P: ' + CASE WHEN ISNUMERIC(S.PhoneNumber) = 1 AND LEN(S.PhoneNumber) = 10 THEN '(' + SUBSTRING(S.PhoneNumber, 1, 3) + ') ' + SUBSTRING(S.PhoneNumber, 4, 3) + '-' + SUBSTRING(S.PhoneNumber, 7, 4) ELSE S.PhoneNumber END + CHAR(13)+CHAR(10) +
       'F: ' + CASE        
			WHEN S.FaxNumber IS NULL THEN ''			
			WHEN ISNUMERIC(S.FaxNumber) = 0 OR CAST(S.FaxNumber AS BIGINT) <= 0 THEN ''			
			WHEN ISNUMERIC(S.FaxNumber) = 1 AND LEN(S.FaxNumber) = 10 THEN '(' + SUBSTRING(S.FaxNumber, 1, 3) + ') ' + SUBSTRING(S.FaxNumber, 4, 3) + '-' + SUBSTRING(S.FaxNumber, 7, 4) 
			ELSE S.FaxNumber END 
       AS RetailerContact
      ,CASE WHEN ISNUMERIC(S.PhoneNumber) = 1 AND LEN(S.PhoneNumber) = 10 THEN '(' + SUBSTRING(S.PhoneNumber, 1, 3) + ') ' + SUBSTRING(S.PhoneNumber, 4, 3) + '-' + SUBSTRING(S.PhoneNumber, 7, 4) ELSE S.PhoneNumber END AS RetailerPhoneNumber
      ,CASE        
			WHEN S.FaxNumber IS NULL THEN ''			
			WHEN ISNUMERIC(S.FaxNumber) = 0 OR CAST(S.FaxNumber AS BIGINT) <= 0 THEN ''		
			WHEN ISNUMERIC(S.FaxNumber) = 1 AND LEN(S.FaxNumber) = 10 THEN '(' + SUBSTRING(S.FaxNumber, 1, 3) + ') ' + SUBSTRING(S.FaxNumber, 4, 3) + '-' + SUBSTRING(S.FaxNumber, 7, 4) 
			ELSE S.FaxNumber END 
       AS RetailerFaxNumber
      
      ,ISNULL(PH1.WithHoldingAmount, 0) AS ChildSupportAmountWithheld
      ,ISNULL(PH2.WithHoldingAmount, 0) AS CentralCollectionAmountWithheld
      ,ISNULL(PH3.WithHoldingAmount, 0) AS VoluntaryExclusionAmountWithheld
      
      ,AUCPPrint.AppUserId AS CheckPrintedByAppUserId
      ,AUCPPrint.UserName AS CheckPrintedByUsername
      ,AUCPPrint.FirstName + ' ' + AUCPPrint.LastName AS CheckPrintedByFullName
      ,AUCPPrint.FirstName AS CheckPrintedByFirstName
      ,AUCPPrint.MiddleInitial AS CheckPrintedByMiddleInitial
      ,AUCPPrint.LastName AS CheckPrintedByLastName
      ,AUCPPrint.Email AS CheckPrintedByEmail
      
      ,AUCPVoid.AppUserId AS CheckVoidedByAppUserId
      ,AUCPVoid.UserName AS CheckVoidedByUsername
      ,AUCPVoid.FirstName + ' ' + AUCPVoid.LastName AS CheckVoidedByFullName
      ,AUCPVoid.FirstName AS CheckVoidedByFirstName
      ,AUCPVoid.MiddleInitial AS CheckVoidedByMiddleInitial
      ,AUCPVoid.LastName AS CheckVoidedByLastName
      ,AUCPVoid.Email AS CheckVoidedByEmail
      
      ,AUVPPayout.AppUserId AS VoucherPayedOutByAppUserId
      ,AUVPPayout.UserName AS VoucherPayedOutByUsername
      ,AUVPPayout.FirstName + ' ' + AUVPPayout.LastName AS VoucherPayedOutByFullName
      ,AUVPPayout.FirstName AS VoucherPayedOutByFirstName
      ,AUVPPayout.MiddleInitial AS VoucherPayedOutByMiddleInitial
      ,AUVPPayout.LastName AS VoucherPayedOutByLastName
      ,AUVPPayout.Email AS VoucherPayedOutByEmail
      
  FROM [CheckProcessing] CP
  JOIN CentralSite CS ON CS.CentralSiteId = CP.CentralSiteId
  JOIN VoucherPayoutReceipt VPR ON VPR.VoucherPayoutReceiptId = CP.VoucherPayoutReceiptId
  JOIN VoucherPayoutReceiptDetail VPRD ON VPRD.VoucherPayoutReceiptId = VPR.VoucherPayoutReceiptId
  JOIN VoucherPayout VP ON VP.VoucherPayoutId = VPRD.VoucherPayoutId
  JOIN CustomerPayoutInfo CPI ON CPI.VoucherPayoutReceiptId = VPR.VoucherPayoutReceiptId
  JOIN CASINO C ON C.LOCATION_ID = VP.LocationId
  JOIN [Site] S ON S.RetailerNumber = C.RETAILER_NUMBER
  JOIN VOUCHER V ON V.VOUCHER_ID = VP.VoucherId AND C.LOCATION_ID = V.LOCATION_ID
  LEFT OUTER JOIN AppUser AUCPPrint ON AUCPPrint.AppUserId = CP.PrintedByAppUserId
  LEFT OUTER JOIN AppUser AUCPVoid ON AUCPVoid.AppUserId = CP.PrintedByAppUserId
  LEFT OUTER JOIN AppUser AUVPPayout ON AUVPPayout.AppUserId = CP.PrintedByAppUserId
  LEFT OUTER JOIN PayoutWithHolding PH1 ON PH1.VoucherPayoutReceiptId = VPR.VoucherPayoutReceiptId AND PH1.PayoutWithHoldingType = 1
  LEFT OUTER JOIN PayoutWithHolding PH2 ON PH2.VoucherPayoutReceiptId = VPR.VoucherPayoutReceiptId AND PH2.PayoutWithHoldingType = 2
  LEFT OUTER JOIN PayoutWithHolding PH3 ON PH3.VoucherPayoutReceiptId = VPR.VoucherPayoutReceiptId AND PH3.PayoutWithHoldingType = 3









GO

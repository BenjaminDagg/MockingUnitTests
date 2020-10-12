SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: GetCentralAutoRetailSetup

Created By:     Louis Epstein

Create Date:    04-22-2014

Description:    Sets the InstallDate and FirstSalesDate to the current date

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 04-22-2014     v5.0.0
  Initial Coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[SetFirstSalesDate]
@RetailerNumber varchar(8)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

DECLARE @CurrentDate datetime

SET @CurrentDate = GETDATE()

    UPDATE [Site]
SET [FirstSalesDate] = @CurrentDate,
[InstallDate] = @CurrentDate
    WHERE RetailerNumber = @RetailerNumber AND FirstSalesDate IS NULL
    
    
END
GO

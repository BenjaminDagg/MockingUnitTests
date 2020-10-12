SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
--------------------------------------------------------------------------------
Procedure Name: SetCentralFirstSalesDate

Created By:     Louis Epstein

Create Date:    04-22-2014

Description:    Updates the first sales date for the site on the central system

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 04-22-2014     v3.2.1
  Initial Coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[SetCentralFirstSalesDate] 
      
AS

SET NOCOUNT ON

DECLARE @sqlQuery nvarchar(max)

SELECT @sqlQuery = VALUE1 + '.SetFirstSalesDate ''' + (SELECT RETAILER_NUMBER FROM CASINO WHERE SETASDEFAULT = 1) + '''' FROM dbo.CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'CENTRAL_SERVER_LINK'
EXEC(@sqlQuery)


  
GO

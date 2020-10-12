SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure GetProgressivePoolsGTC

Created 07-09-2009 by Terry Watkins

Description: Returns a list of all progressive pool values for given GTC.

Parameters: GameTypeCode

Change Log:

Changed By    Date            Database Version
  Change Description
--------------------------------------------------------------------------------
Louis Epstein 10-23-2013      v7.3.2
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[GetProgressivePoolsGTC]
@GameTypeCode char(2)
AS
BEGIN
SET NOCOUNT ON;

    SELECT [PROGRESSIVE_POOL_ID] AS ProgressivePoolID
  ,[DENOMINATION] AS Denomination
  ,[WinLevel] AS WinLevel
  ,[POOL_1] AS PoolAmount
  FROM PROGRESSIVE_POOL
  WHERE GAME_TYPE_CODE = @GameTypeCode
  
  
END
GO

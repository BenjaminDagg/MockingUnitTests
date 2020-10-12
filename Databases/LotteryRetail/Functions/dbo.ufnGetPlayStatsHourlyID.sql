SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function ufnGetAcctDate

Created 07-13-2009 by Terry Watkins

Purpose: Returns the current accounting Date.

Returns: DateTime value


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 07-13-2009     v6.0.8
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufnGetPlayStatsHourlyID](
   @MachineNumber Char(5),
   @CasinoMachNo  VarChar(8),
   @AcctDate      DateTime,
   @DealNumber    Int         = 0,
   @GameCode      VarChar(3),
   @Denom         SmallMoney  = 0,
   @CoinsBet      SmallInt    = 0,
   @LinesBet      SmallInt    = 0,
   @HourOfDay     Int
) RETURNS Int
AS

BEGIN
   -- Variable Declarations
   DECLARE @ReturnValue    Int

   -- Initialize the returnvalue to zero.
   SET @ReturnValue = 0
   
   -- Attempt to retrieve the PK of the matching row in PLAY_STATS_HOURLY...
   IF EXISTS(SELECT * FROM PLAY_STATS_HOURLY
             WHERE
                MACH_NO        = @MachineNumber AND
                CASINO_MACH_NO = @CasinoMachNo  AND
                ACCT_DATE      = @AcctDate      AND
                DEAL_NO        = @DealNumber    AND
                GAME_CODE      = @GameCode      AND
                DENOM          = @Denom         AND
                COINS_BET      = @CoinsBet      AND
                LINES_BET      = @LinesBet      AND
                HOUR_OF_DAY    = @HourOfDay)
      BEGIN
         -- Yes, so retrieve the PK value of the row to be updated.
         SELECT @ReturnValue = PLAY_STATS_HOURLY_ID
         FROM PLAY_STATS_HOURLY
         WHERE
            MACH_NO        = @MachineNumber AND
            CASINO_MACH_NO = @CasinoMachNo  AND
            ACCT_DATE      = @AcctDate      AND
            DEAL_NO        = @DealNumber    AND
            GAME_CODE      = @GameCode      AND
            DENOM          = @Denom         AND
            COINS_BET      = @CoinsBet      AND
            LINES_BET      = @LinesBet      AND
            HOUR_OF_DAY    = @HourOfDay
      END
   
   -- Set the function return value.
   RETURN @ReturnValue
END
GO

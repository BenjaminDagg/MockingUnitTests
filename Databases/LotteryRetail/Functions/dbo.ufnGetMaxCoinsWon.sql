SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Defined Function ufnGetMaxCoinsWon

Created 04-21-2009 by Terry Watkins

Purpose: Returns the maximum number of coins that can be won by a machine based
         upon the GameTypeCode.

Returns: Integer value

Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 04-21-2009     v6.0.5
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE FUNCTION [dbo].[ufnGetMaxCoinsWon]
   (@GameTypeCode    VarChar(2),
    @DealTypeCode    Char(1),
    @PayscaleName    VarChar(16),
    @GameMaxCoinsBet Int,
    @GameMaxLinesBet Int,
    @IsBuyAPay       Bit) RETURNS Integer
AS

BEGIN
   -- Variable Declarations
   DECLARE @ReturnValue   Integer
   DECLARE @UseMultiplier Bit
   
   -- Is this a Keno game?
   IF (@DealTypeCode = 'K')
      -- Yes, so retrieve from PAYSCALE_TIER_KENO
      BEGIN
         SELECT @ReturnValue = CAST(MAX(AWARD_FACTOR) * @GameMaxCoinsBet AS INTEGER)
         FROM PAYSCALE_TIER_KENO
         WHERE PAYSCALE_NAME = @PayscaleName
      END
   ELSE
      -- Not Keno
      BEGIN
         -- Is it a BuyAPay game?
         IF (@IsBuyAPay = 0)
            -- No, it is not a BuyAPay game.
            BEGIN
               SELECT
                  @ReturnValue = MAX(COINS_WON) * @GameMaxCoinsBet / @GameMaxLinesBet
               FROM PAYSCALE_TIER
               WHERE PAYSCALE_NAME = @PayscaleName
            END
         ELSE
            -- Yes, it is a BuyAPay game.
            BEGIN
               SELECT
                  @ReturnValue = MAX(COINS_WON),
                  @UseMultiplier = USE_MULTIPLIER
               FROM PAYSCALE_TIER
               WHERE PAYSCALE_NAME = @PayscaleName AND TIER_WIN_TYPE = 5
               GROUP BY USE_MULTIPLIER
               -- Double return value if Use Multiplier is true.
               IF (@UseMultiplier = 1) SET @ReturnValue = @ReturnValue * 2
            END
      END
   
   -- Set the function return value.
   RETURN @ReturnValue
END


GO

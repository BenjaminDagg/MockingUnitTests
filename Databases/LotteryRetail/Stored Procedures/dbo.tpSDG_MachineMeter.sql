SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpSDG_MachineMeter

  Created: 01/13/2005 by Terry Watkins

  Purpose: Returns meter totals for the specified machine.
           Created to support SDG Player Tracking.

Arguments:
   @MachineNbr: Machine number to report on.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 01-10-2005     v4.0.1
  Initial coding.

A. Murthy     09-01-2006     v5.0.7
  When MoneyWon/MoneyPlayed values are >= 20 million cents, roll-over all
  counters to 0. Per D.DeMuelanere (Bally)
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpSDG_MachineMeter] @MachineNbr Char(5)
AS

-- Variable Declarations
DECLARE @ErrorID           Int
DECLARE @GamesPlayed       Int
DECLARE @VoucherInCount    Int
DECLARE @VoucherOutCount   Int
DECLARE @JackpotOutCount   Int

DECLARE @MoneyPlayed       BigInt
DECLARE @MoneyWon          BigInt
DECLARE @BillInMeter       BigInt
DECLARE @Bill1Meter        BigInt
DECLARE @Bill2Meter        BigInt
DECLARE @Bill5Meter        BigInt
DECLARE @Bill10Meter       BigInt
DECLARE @Bill20Meter       BigInt
DECLARE @Bill50Meter       BigInt
DECLARE @Bill100Meter      BigInt
DECLARE @BillOtherMeter    BigInt
DECLARE @VoucherInAmount   BigInt
DECLARE @VoucherOutAmount  BigInt
DECLARE @JackpotOutAmount  BigInt

-- Variable Initialization
SET @ErrorID = 0

-- Retrieve data and convert dollar amounts (money) to cents (int) values.
SELECT
   @MoneyPlayed         = CAST(AMOUNT_PLAYED * 100 AS BigInt),
   @MoneyWon            = CAST(AMOUNT_WON * 100 AS BigInt),
   @GamesPlayed         = PLAY_COUNT,
   @BillInMeter         = CAST(AMOUNT_IN_TOTAL * 100 AS BigInt),
   @Bill1Meter          = CAST(AMOUNT_IN_1 * 100 AS BigInt),
   @Bill2Meter          = CAST(AMOUNT_IN_2 * 100 AS BigInt),
   @Bill5Meter          = CAST(AMOUNT_IN_5 * 100 AS BigInt),
   @Bill10Meter         = CAST(AMOUNT_IN_10 * 100 AS BigInt),
   @Bill20Meter         = CAST(AMOUNT_IN_20 * 100 AS BigInt),
   @Bill50Meter         = CAST(AMOUNT_IN_50 * 100 AS BigInt),
   @Bill100Meter        = CAST(AMOUNT_IN_100 * 100 AS BigInt),
   @BillOtherMeter      = CAST(AMOUNT_IN_OTHER * 100 AS BigInt),
   @VoucherInAmount     = CAST(TICKET_IN_TOTAL * 100 AS BigInt),
   @VoucherInCount      = TICKET_IN_COUNT,
   @VoucherOutAmount    = CAST(TICKET_OUT_TOTAL * 100 AS BigInt),
   @VoucherOutCount     = TICKET_OUT_COUNT,
   @JackpotOutAmount    = CAST(JACKPOT_TICKET_OUT * 100 AS BigInt),
   @JackpotOutCount     = JACKPOT_TICKET_COUNT
FROM MACHINE_METER
WHERE MACH_NO = @MachineNbr

--
IF (@@ROWCOUNT = 0)
   SET @ErrorID = -1
ELSE
   -- If MoneyPlayed/MoneyWon >= 20 million cents then Roll-Over all counters to 0 (per D. DeMeulanere @ Bally)
   BEGIN
      IF (@MoneyWon >= 20000000 ) OR (@MoneyPlayed >= 20000000 )
         BEGIN
            SET @MoneyPlayed = 0
            UPDATE MACHINE_METER SET AMOUNT_PLAYED = 0

            SET @MoneyWon = 0
            UPDATE MACHINE_METER SET AMOUNT_WON = 0

            SET @GamesPlayed = 0
            UPDATE MACHINE_METER SET PLAY_COUNT = 0

            SET @BillInMeter = 0
            UPDATE MACHINE_METER SET AMOUNT_IN_TOTAL = 0

            SET @Bill1Meter = 0
            UPDATE MACHINE_METER SET AMOUNT_IN_1 = 0

            SET @Bill2Meter = 0
            UPDATE MACHINE_METER SET AMOUNT_IN_2 = 0

            SET @Bill5Meter = 0
            UPDATE MACHINE_METER SET AMOUNT_IN_5 = 0

            SET @Bill10Meter = 0
            UPDATE MACHINE_METER SET AMOUNT_IN_10 = 0

            SET @Bill20Meter = 0
            UPDATE MACHINE_METER SET AMOUNT_IN_20 = 0

            SET @Bill50Meter = 0
            UPDATE MACHINE_METER SET AMOUNT_IN_50 = 0

            SET @Bill100Meter = 0
            UPDATE MACHINE_METER SET AMOUNT_IN_100 = 0

            SET @BillOtherMeter = 0
            UPDATE MACHINE_METER SET AMOUNT_IN_OTHER = 0

            SET @VoucherInAmount = 0
            UPDATE MACHINE_METER SET TICKET_IN_TOTAL = 0

            SET @VoucherInCount = 0
            UPDATE MACHINE_METER SET TICKET_IN_COUNT = 0

            SET @VoucherOutAmount = 0
            UPDATE MACHINE_METER SET TICKET_OUT_TOTAL = 0

            SET @VoucherOutCount = 0
            UPDATE MACHINE_METER SET TICKET_OUT_COUNT = 0

            SET @JackpotOutAmount = 0
            UPDATE MACHINE_METER SET JACKPOT_TICKET_OUT = 0

            SET @JackpotOutCount = 0
            UPDATE MACHINE_METER SET JACKPOT_TICKET_COUNT = 0
         END

   END 

-- Generate the resultset to be returned.
SELECT
   @ErrorID                     AS ErrorID,
   ISNULL(@MoneyPlayed, 0)      AS MoneyPlayed,
   ISNULL(@MoneyWon, 0)         AS MoneyWon,
   ISNULL(@GamesPlayed, 0)      AS GamesPlayed,
   ISNULL(@BillInMeter, 0)      AS BillInMeter,
   ISNULL(@Bill1Meter, 0)       AS Bill1Meter,
   ISNULL(@Bill2Meter, 0)       AS Bill2Meter,
   ISNULL(@Bill5Meter, 0)       AS Bill5Meter,
   ISNULL(@Bill10Meter, 0)      AS Bill10Meter,
   ISNULL(@Bill20Meter, 0)      AS Bill20Meter,
   ISNULL(@Bill50Meter, 0)      AS Bill50Meter,
   ISNULL(@Bill100Meter, 0)     AS Bill100Meter,
   ISNULL(@BillOtherMeter, 0)   AS BillOtherMeter,
   ISNULL(@VoucherInAmount, 0)  AS VoucherInAmount,
   ISNULL(@VoucherInCount, 0)   AS VoucherInCount,
   ISNULL(@VoucherOutAmount, 0) AS VoucherOutAmount,
   ISNULL(@VoucherOutCount, 0)  AS VoucherOutCount,
   ISNULL(@JackpotOutAmount, 0) AS JackpotOutAmount,
   ISNULL(@JackpotOutCount, 0)  AS JackpotOutCount,
   CAST(0 AS BigInt)            AS ProgressiveContributions,
   CAST(0 AS BigInt)            AS ProgressiveAwards
GO

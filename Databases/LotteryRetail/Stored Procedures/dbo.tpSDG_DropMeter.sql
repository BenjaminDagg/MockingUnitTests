SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Procedure: tpSDG_DropMeter user stored procedure.

  Created: 10/13/2004 by Terry Watkins

  Purpose: Returns summary data for the SDG DropMeter message

Arguments: @MachNbr:  DGE Internal Machine number to report on.


Change Log:

Date       By                Database version
  Change Description
--------------------------------------------------------------------------------
04-21-2005 Terry Watkins     v4.1.0
  Added retrieval of PROMO_IN_AMOUNT and PROMO_IN_COUNT

09-16-2005 Terry Watkins     v4.2.2
  Changed BusinessDay to pass back current accounting date instead of the
   current accounting date minus 1 day.

A. Murthy 01-16-2006         v5.0.1
  Modified update to MACH_SETUP.ACTIVE_FLAG so that on error, the flag is set
  to 0 only if it is currently set to 1 (data type changed from Bit to TinyInt).

Terry Watkins 11-03-2009     v7.0.0
  Uses new function dbo.ufnGetAcctDate() to retrieve the accounting date.
  @AcctDate changed from VarChar(16) to DateTime.
--------------------------------------------------------------------------------
*/
CREATE  PROCEDURE [dbo].[tpSDG_DropMeter] @MachineNbr Char(5)
AS

-- Variable Declarations
DECLARE @AcctDate          DateTime
DECLARE @CasinoMachNbr     VarChar(8)
DECLARE @DropMachineID     Int
DECLARE @IsActive          TinyInt
DECLARE @IsRemoved         Bit
DECLARE @TerminalStatus    VarChar(3)

-- Variable Initialization
SET @TerminalStatus = 'ON'

-- Start by retrieving Machine information.
SELECT
   @CasinoMachNbr   = CASINO_MACH_NO,
   @IsRemoved       = REMOVED_FLAG,
   @IsActive        = ACTIVE_FLAG
FROM MACH_SETUP ms
WHERE MACH_NO = @MachineNbr

-- Reset the Terminal Status to OFF if removed or inactive.
IF (@IsRemoved = 1) OR (@IsActive = 0) SET @TerminalStatus = 'OFF'

-- Get Current Accounting Date.
SET @AcctDate = dbo.ufnGetAcctDate()

-- Retrieve the Primary Key value for the last drop for the specified machine.
SELECT @DropMachineID = ISNULL(DROP_MACHINE_ID, 0)
FROM DROP_MACHINE
WHERE
   MACH_NO = @MachineNbr AND
   DTIMESTAMP = (SELECT MAX(DTIMESTAMP) FROM DROP_MACHINE WHERE MACH_NO = @MachineNbr)

-- Retrieve the result set to be returned...
SELECT
   @CasinoMachNbr                             AS SlotID,
   ONE_DOLLAR_AMT                             AS Bills1,
   TWO_DOLLAR_AMT                             AS Bills2,
   FIVE_DOLLAR_AMT                            AS Bills5,
   TEN_DOLLAR_AMT                             AS Bills10,
   TWENTY_DOLLAR_AMT                          AS Bills20,
   FIFTY_DOLLAR_AMT                           AS Bills50,
   HUNDRED_DOLLAR_AMT                         AS Bills100,
   CAST(0 AS INT)                             AS BillsOther,
   DROP_AMOUNT                                AS DropDollars,
   TICKET_IN_AMOUNT                           AS TicketDroppedValue,
   TICKET_IN_COUNT                            AS TicketDroppedCount,
   PROMO_IN_AMOUNT                            AS PromoDroppedValue,
   PROMO_IN_COUNT                             AS PromoDroppedCount,
   CAST(0 AS INT)                             AS CoinDroppedValue,
   CAST(0 AS INT)                             AS CoinDroppedCount,
   CONVERT(CHAR(10), @AcctDate, 101)          AS BusinessDay,
   @TerminalStatus                            AS TerminalStatus
FROM DROP_MACHINE
WHERE DROP_MACHINE_ID = @DropMachineID
GO

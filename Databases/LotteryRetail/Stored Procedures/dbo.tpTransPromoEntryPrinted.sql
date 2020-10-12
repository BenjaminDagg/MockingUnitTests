SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
User Stored Procedure tpTransPromoEntryPrinted

Created 03-11-2014 by Eloy Bencomo

Desc: Handles PromoEntryPrinted messages from machines.

Return values: ErrorID
               ErrorDescription
               ShutDownFlag
 
Called by: Transaction Portal

Parameters:
   @MachineNumber       Machine number
   @PromoEntryType      Promo Entry Type, 1 = Amount, 2 = Count
   @TimeStamp           Date and time sent


Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpTransPromoEntryPrinted]
   @MachineNumber       VarChar(5),
   @PromoEntryType      INT,
   @TimeStamp			DateTime
AS
-- SET NOCOUNT ON to prevent return of unwanted messages
SET NOCOUNT ON

-- Variable Declarations
DECLARE @AcctDate          DateTime
DECLARE @Balance           Money
DECLARE @CasinoID          VarChar(6)
DECLARE @CasinoTransID     Int
DECLARE @Debug             Bit
DECLARE @ErrorDescription  VarChar(256)
DECLARE @ErrorSource       VarChar(64)
DECLARE @ErrorID           Int
DECLARE @GameCode          VarChar(3)
DECLARE @LocationID        Int
DECLARE @LockupMachine     Int
DECLARE @MachNbrAsInt      Int
DECLARE @PromoEntryByAmt   Int
DECLARE @PromoEntryByCnt   Int
DECLARE @EventCode         VarChar(2)
DECLARE @MsgText           VarChar(2048)
DECLARE @MachineTimeStamp         DateTime
DECLARE @TransID           SmallInt

-- Variable Initialization
SET @MachineTimeStamp = @TimeStamp
SET @Balance          = 0
SET @Debug            = 0
SET @ErrorDescription = ''
SET @ErrorSource      = 'tpTransPromoEntryPrinted Stored Procedure'
SET @ErrorID          = 0
SET @GameCode         = ''
SET @LocationID       = 0
SET @LockupMachine    = 0
SET @MachNbrAsInt     = ISNULL(CAST(@MachineNumber AS Int), 0)
SET @PromoEntryByAmt  = 0
SET @PromoEntryByCnt  = 0
SET @EventCode        = 'SP'
SET @MsgText          = ''
SET @TimeStamp        = GETDATE()
SET @TransID          = 88
IF (@PromoEntryType = 2) SET @TransID = 89

-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpTransPromoEntryPrinted'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransPromoEntryPrinted Arguments - MachineNumber: ' + ISNULL(@MachineNumber, '<null>') +
         '  PromoEntryPrinted: ' + ISNULL(CAST(@PromoEntryType AS VARCHAR), '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Retrieve Casino Information.
SELECT
   @CasinoID     = CAS_ID,
   @LocationID   = LOCATION_ID
FROM CASINO
WHERE SETASDEFAULT = 1

-- Get Current Accounting Date to record in the audit table.
SET @AcctDate = dbo.ufnGetAcctDate()

-- Update MACH_SETUP.PLAY_STATUS
IF EXISTS (SELECT * FROM dbo.MACH_SETUP WHERE MACH_NO = @MachineNumber)
BEGIN
-- If the machine exists, log Promo Entry Printed message event in the audit table.
   EXEC @CasinoTransID = dbo.tpInsertCasinoTrans
      @CasinoID        = @CasinoID,
      @DealNo          = 0,
      @RollNo          = 0,
      @TicketNo        = 0,
      @Denom           = 0,
      @TransAmt        = 0,
      @Barcode         = '',
      @TransID         = @TransID,
      @CurrentAcctDate = @AcctDate,
      @TimeStamp       = @TimeStamp,
      @MachineNumber   = @MachineNumber,
      @CardAccount     = 'INTERNAL',
      @Balance         = @Balance,
      @GameCode        = @GameCode,
      @CoinsBet        = 0,
      @LinesBet        = 0,
      @TierLevel       = 0,
      @PressUpCount    = 0,
      @LocationID      = @LocationID,
      @MachineTimeStamp = @MachineTimeStamp
      
END
ELSE
   -- Invalid machine
   SET @ErrorID = 104

-- Increment Promo Schedule Counts
IF @ErrorID = 0
BEGIN
   DECLARE @PromoID INT
   DECLARE @PromoScheduleCount INT
    
   SELECT @PromoID = PromoScheduleID, @PromoScheduleCount = COUNT(*)    
   FROM PROMO_SCHEDULE WHERE PromoStarted = 1 AND PromoEnded = 0 AND @MachineTimeStamp BETWEEN PromoStart AND PromoEnd 
   GROUP BY PromoScheduleID
       
   -- Is there a schedule row?
   IF (@PromoScheduleCount > 1)
   BEGIN
      SET @ErrorID = 144 -- Invalid TransId for Promo Operation
   END
   ELSE IF (@PromoID IS NOT NULL AND @PromoScheduleCount = 1)
      BEGIN
         IF (@TransID = 88)
         BEGIN
            UPDATE PROMO_SCHEDULE
            SET TOTAL_PROMO_AMOUNT_TICKETS = TOTAL_PROMO_AMOUNT_TICKETS + 1
            WHERE
               PromoScheduleID = @PromoID
         END
         ELSE IF (@TransID = 89)
         BEGIN
            UPDATE PROMO_SCHEDULE
            SET TOTAL_PROMO_FACTOR_TICKETS = TOTAL_PROMO_FACTOR_TICKETS + 1
            WHERE
              PromoScheduleID = @PromoID
         END
         ELSE SET @ErrorID = 144 -- Invalid TransId for Promo Operation
      END
   ELSE
   BEGIN
   -- Active Promo Schedule not found
      SET @ErrorID = 143
   END
END

-- Update Casino Event Log if not found 
IF (@ErrorID <> 0)
BEGIN
   -- Insert Error into the Casino_Event_Log
   SET @MsgText =
      'Description: Promo Schedule not found. Error: ' + ISNULL(CAST(@ErrorID AS VARCHAR), '<null>') +
      '. Machine Number: ' + ISNULL(@MachineNumber, '<null>') + '.'

   INSERT INTO CASINO_EVENT_LOG
      (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
   VALUES
      (@EventCode, @ErrorSource, @MsgText, @ErrorID, @MachineNumber)
END

-- Return results to client
SELECT
   @ErrorID            AS ErrorID,
   @ErrorDescription   AS ErrorDescription,
   @LockupMachine      AS ShutDownFlag
GO

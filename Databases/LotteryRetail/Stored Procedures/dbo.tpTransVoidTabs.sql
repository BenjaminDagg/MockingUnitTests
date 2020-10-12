SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Name: tpTransVoidTabs

Desc: Handles request from EGM to deactivate tabs.
Called by: Transaction Portal
Author: Terry Watkins
Date: 06-14-2012

Parameters:
   @CardAccount     Card Account of tech loading roll/deck
   @DealNumber      Deal Number of paper loaded
   @RollNumber      Roll Number of paper loaded
   @FirstTicket     First ticket to be deactivated
   @DeactivateCount Number of tabs to deactivate or 0 if this procedure is to determine which tabs to deactivate
   @MachineNumber   Machine identifier requesting deactivation

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 06-14-2012     LRAS v3.0.6
  Initial coding.
  
Louis Epstein 10-25-2013     v3.1.6
  Added machine timestamp functionality
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpTransVoidTabs]
   @CardAccount     VarChar(20),
   @DealNumber      Int,
   @RollNumber      Int,
   @FirstTicket     Int,
   @DeactivateCount Int,
   @MachineNumber   Char(5),
   @TimeStamp DateTime
AS

-- Variable Declarations
DECLARE @AcctDate          DateTime
DECLARE @Balance           Money
DECLARE @CasinoID          VarChar(6)
DECLARE @CasinoTransID     Int
DECLARE @Debug             Bit
DECLARE @EDealTableName    VarChar(128)
DECLARE @ErrorDescription  VarChar(256)
DECLARE @ErrorID           Int
DECLARE @ErrorSource       VarChar(64)
DECLARE @EventDesc         VarChar(1024)
DECLARE @LastTicket        Int
DECLARE @LocationID        Int
DECLARE @LockupMachine     Int
DECLARE @LogToCasinoTrans  Bit
DECLARE @MachGameCode      VarChar(3)
DECLARE @MachNbrAsInt      Int
DECLARE @MsgText           VarChar(2048)
DECLARE @IntValue          Int
DECLARE @SQLStatement      VarChar(128)
DECLARE @TabsPerRoll       Int
DECLARE @TicketRollNumber  Int
DECLARE @TicketStatus      Int
DECLARE @MachineTimeStamp  DateTime
DECLARE @TransID           SmallInt
DECLARE @TSQLErrMessage    nVarChar(2048)

-- Variable Initialization
SET @MachineTimeStamp   = @TimeStamp
SET @AcctDate           = dbo.ufnGetAcctDate()
SET @Balance            = 0
SET @CasinoTransID      = 0
SET @Debug              = 0
SET @ErrorID            = 0
SET @ErrorDescription   = ''
SET @ErrorSource        = 'tpTransVoidTabs Stored Procedure'
SET @LocationID         = 0
SET @LockupMachine      = 0
SET @LogToCasinoTrans   = 0
SET @MachGameCode       = ''
SET @MachNbrAsInt       = CAST(@MachineNumber AS Int)
SET @TabsPerRoll        = 0
SET @TimeStamp          = GETDATE()
SET @TransID            = 72


-- Suppress return of unwanted stats.
SET NOCOUNT ON

-- Retrieve Casino Information.
SELECT
   @CasinoID   = CAS_ID,
   @LocationID = LOCATION_ID
FROM CASINO WHERE SETASDEFAULT = 1

-- Retrieve Machine Information.
SELECT
   @MachGameCode = GAME_CODE,
   @Balance      = BALANCE
FROM MACH_SETUP
WHERE MACH_NO = @MachineNumber

-- Retrieve number of tabs per roll for the deal.
SELECT @TabsPerRoll = TABS_PER_ROLL FROM DEAL_SETUP WHERE DEAL_NO = @DealNumber
                  
-- Check debug mode.
SELECT @Debug = ISNULL(DEBUG_MODE, 0) FROM DEBUG_SETTING WHERE DEBUG_ENTITY = 'tpTransVoidTabs'

-- If in Debug mode, save argument values...
IF (@Debug = 1)
   BEGIN
      SET @MsgText =
         'tpTransVoidTabs Arguments - CardAccount: ' + ISNULL(@CardAccount, '<null>') +
         '  DealNumber: '      + ISNULL(CAST(@DealNumber AS VarChar), '<null>') +
         '  RollNumber: '      + ISNULL(CAST(@RollNumber AS VarChar), '<null>') +
         '  FirstTicket: '     + ISNULL(CAST(@FirstTicket AS VarChar), '<null>') +
         '  DeactivateCount: ' + ISNULL(CAST(@DeactivateCount AS VarChar), '<null>') +
         '  MachineNumber: '   + ISNULL(@MachineNumber, '<null>')
      
      EXEC InsertDebugInfo @TransID, @MsgText, @MachNbrAsInt
   END

-- Build the eDeal table name
SET @EDealTableName = 'eDeal.dbo.Deal' + CAST(@DealNumber AS VarChar)

IF (@DeactivateCount > 0)
   -- The EGM knows the first ticket number and the number of tabs to deactivate.
   BEGIN
      -- Set flag so we log to Casino Trans
      SET @LogToCasinoTrans = 0
      
      -- Calculate the last ticket number to be deactivated.
      SET @LastTicket = @FirstTicket + @DeactivateCount - 1
      
      -- Build the SQL to deactivate ticket(s).
      --SET @SQLStatement = 'UPDATE ' + @EDealTableName +
      --                     ' SET IsActive = 0 WHERE TicketNumber BETWEEN ' +
      --                     CAST(@FirstTicket AS VarChar) + ' AND ' +
      --                     CAST(@LastTicket AS VarChar)
      ---- Execute update of the eDeal Deal table.
      --EXEC (@SQLStatement)
      
      ---- Insert a row into the DEACTIVATED_TAB table for reporting...
      --EXEC InsertDeactivatedTab
      --   @MachineNumber = @MachineNumber,
      --   @DealNumber    = @DealNumber,
      --   @RollNumber    = @RollNumber,
      --   @FirstTicket   = @FirstTicket,
      --   @LastTicket    = @LastTicket
   END
ELSE IF (@DeactivateCount = 0)
   -- The EGM does not know how many tickets, if any, to be deactivated.
   -- It does know the Deal, Roll, and first good ticket number.
   -- The @FirstTicket argument will be one less than the ticket number from load roll.
   BEGIN
      -- Set the last ticket number to the first ticket number because
      -- they will need to be evaluated in reverse order.
      SET @LastTicket = @FirstTicket
      
      -- GetPaperTicketStatus returns 0 if the ticket is active.
      EXEC @TicketStatus = GetPaperTicketStatus @DealNumber = @DealNumber, @TicketNumber = @LastTicket
      
      -- Is the ticket active?
      IF (@TicketStatus = 0)
         -- Yes, the ticket number passed to this procedure is Active so deactivation is required.
         BEGIN
            -- Set flag so we log to Casino Trans
            SET @LogToCasinoTrans = 0
            
            -- Initialize the roll number of the ticket to incoming roll number
            SET @TicketRollNumber = @RollNumber
            
            -- Find the lowest ticket number to deactivate...
            WHILE (@TicketStatus = 0 AND @TicketRollNumber = @RollNumber)
               BEGIN
                  SET @FirstTicket = @FirstTicket - 1
                  SET @TicketRollNumber = @FirstTicket / @TabsPerRoll + SIGN(@FirstTicket % @TabsPerRoll)
                  IF (@TicketRollNumber = @RollNumber)
                     BEGIN
                        -- Check the next ticket...
                        EXEC @TicketStatus = GetPaperTicketStatus
                           @DealNumber   = @DealNumber,
                           @TicketNumber = @FirstTicket
                        IF (@TicketStatus <> 0)
                           SET @FirstTicket = @FirstTicket + 1
                     END
                  ELSE
                     -- Moved past the beginning of the roll.
                     SET @FirstTicket = @FirstTicket + 1
               END
            
            ---- Deactivate the ticket(s).   
            --SET @SQLStatement = 'UPDATE ' + @EDealTableName +
            --                    ' SET IsActive = 0 WHERE TicketNumber BETWEEN ' +
            --                    CAST(@FirstTicket AS VarChar) + ' AND ' +
            --                    CAST(@LastTicket AS VarChar)
            ---- Execute update of the eDeal Deal table.
            --EXEC (@SQLStatement)
            
            ---- Insert a row into the DEACTIVATED_TAB table for reporting...
            --EXEC InsertDeactivatedTab
            --   @MachineNumber = @MachineNumber,
            --   @DealNumber    = @DealNumber,
            --   @RollNumber    = @RollNumber,
            --   @FirstTicket   = @FirstTicket,
            --   @LastTicket    = @LastTicket
         END
   END

IF (@LogToCasinoTrans = 1)
   BEGIN
   BEGIN TRY
         -- Log transaction.
         EXEC @CasinoTransID = tpInsertCasinoTrans
            @CasinoID        = @CasinoID,
            @DealNo          = @DealNumber,
            @RollNo          = @RollNumber,
            @TransAmt        = 0,
            @TransID         = @TransID,
            @CurrentAcctDate = @AcctDate,
            @TimeStamp       = @TimeStamp,
            @MachineNumber   = @MachineNumber,
            @CardAccount     = @CardAccount,
            @Balance         = @Balance,
            @GameCode        = @MachGameCode,
            @LocationID      = @LocationID,
            @MachineTimeStamp = @MachineTimeStamp
      END TRY
      BEGIN CATCH
         -- Store the TSQL error number.
         SELECT @IntValue       = ERROR_NUMBER(),
                @ErrorSource    = ERROR_PROCEDURE(),
                @TSQLErrMessage = ERROR_MESSAGE()
         
         SET @EventDesc = 'Insert of Void Tabs into CASINO_TRANS failed. ' + @TSQLErrMessage
      
      
          -- Insert a row into the CASINO_EVENT_LOG table.
         INSERT INTO CASINO_EVENT_LOG
            (EVENT_CODE, EVENT_SOURCE, EVENT_DESC, ERROR_NO, MACH_NO)
         VALUES
            ('FI', @ErrorSource, @EventDesc, @IntValue, @MachineNumber)
            
      END CATCH
   END

-- Return results to client
SELECT
   @ErrorID          AS ErrorID,
   @ErrorDescription AS ErrorDescription,
   @LockupMachine    AS ShutDownFlag
GO

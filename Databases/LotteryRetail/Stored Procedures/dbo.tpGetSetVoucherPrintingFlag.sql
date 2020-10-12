SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
/*
--------------------------------------------------------------------------------
Stored Procedure: tpGetSetVoucherPrintingFlag

Created: 02-06-2006 by A. Murthy

Purpose: To either get or set the value of the MACH_SETUP.VOUCHER_PRINTING
         for a MachineNumber based upon whether the "GetOrSet" parm is "G" or "S"

Input  : @MachNo    : The machine number whose VOUCHER_PRINTING we want to get or set.
         @GetOrSet  : is either "G" or "S"
         @FlagValue : 0 or 1 default 0

Returns: MACH_SETUP.VOUCHER_PRINTING ( 0 or 1 or -1 for non-existent machine record.)


Change Log

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
A.Murthy      02-06-2006     v5.0.8
  Initial Coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[tpGetSetVoucherPrintingFlag]
   @MachNo    VarChar(8),
   @GetOrSet  Char(1),
   @FlagValue Bit = 0
AS

-- Variable Declarations
DECLARE @ReturnValue     Int
DECLARE @VoucherPrinting Bit

BEGIN
   -- Check if we are to "Get" the value of MACH_SETUP.VOUCHER_PRINTING...
   IF (@GetOrSet = 'G')
      BEGIN
         SELECT @VoucherPrinting = VOUCHER_PRINTING FROM MACH_SETUP WHERE MACH_NO = @MachNo
         
         IF (@@RowCount = 1)
            -- Return the current value of the VOUCHER_PRINTING.
            SET @ReturnValue = CAST(@VoucherPrinting AS Int)
         ELSE
            -- Select failed, pass back -1 so that we can shut-down machine.
            SET @ReturnValue = -1
      END
   ELSE IF (@GetOrSet = 'S')
      -- We have to "Set" the value of MACH_SETUP.VOUCHER_PRINTING column.
      BEGIN
         UPDATE MACH_SETUP SET VOUCHER_PRINTING = @FlagValue WHERE MACH_NO = @MachNo
         
         IF (@@RowCount = 1)
            -- Return the value we have set VOUCHER_PRINTING to.
            SET @ReturnValue = CAST(@FlagValue AS Int)
         ELSE
            -- Update failed, pass back -1 so that we can shut-down machine.
            SET @ReturnValue = -1
      END
   
   -- Set the function return value.
   SELECT @ReturnValue As VoucherPrintingFlag
END
GO

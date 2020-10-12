CREATE TABLE [dbo].[VOUCHER]
(
[VOUCHER_ID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[LOCATION_ID] [int] NOT NULL,
[VOUCHER_TYPE] [smallint] NOT NULL CONSTRAINT [DF_VOUCHER_VOUCHER_TYPE] DEFAULT ((0)),
[BARCODE] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VOUCHER_AMOUNT] [money] NOT NULL CONSTRAINT [DF_VOUCHER_AMOUNT] DEFAULT ((0)),
[CREATE_DATE] [datetime] NOT NULL,
[CREATED_LOC] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REDEEMED_LOC] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REDEEMED_STATE] [bit] NOT NULL CONSTRAINT [DF_VOUCHER_REDEEMED_STATE] DEFAULT ((0)),
[REDEEMED_DATE] [datetime] NULL,
[CHECK_VALUE] [varbinary] (8) NULL,
[CT_TRANS_NO_VC] [int] NOT NULL CONSTRAINT [DF_VOUCHER_CT_TRANS_NO] DEFAULT ((0)),
[CT_TRANS_NO_VR] [int] NOT NULL CONSTRAINT [DF_VOUCHER_CT_TRANS_NO_VR] DEFAULT ((0)),
[CT_TRANS_NO_JP] [int] NOT NULL CONSTRAINT [DF_VOUCHER_CT_TRANS_NO_JP] DEFAULT ((0)),
[IS_VALID] [bit] NOT NULL CONSTRAINT [DF_VOUCHER_IS_VALID] DEFAULT ((0)),
[SESSION_PLAY_AMOUNT] [money] NOT NULL CONSTRAINT [DF_VOUCHER_SESSION_AMOUNT_PLAYED] DEFAULT ((0)),
[UCV_TRANSFERRED] [bit] NOT NULL CONSTRAINT [DF_VOUCHER_TRANSFERRED] DEFAULT ((0)),
[UCV_TRANSFER_DATE] [datetime] NULL,
[GAME_TITLE_ID] [int] NOT NULL CONSTRAINT [DF_VOUCHER_GAME_TITLE_ID] DEFAULT ((0)),
[PROMO_VOUCHER_SESSION_ID] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Update Trigger ti_Voucher_Insert
Created 03-27-2007 by Terry Watkins
--------------------------------------------------------------------------------
*/
CREATE TRIGGER [dbo].[ti_Voucher_Insert] ON [dbo].[VOUCHER] 
FOR INSERT
AS
-- Variable Declarations
DECLARE @UserName VarChar(128)

-- Store current user name in lower case.
SET @UserName = LOWER(USER_NAME())

IF (@UserName <> 'tp')
   -- User is not TP so raise an error...
   BEGIN
      RAISERROR('You are not authorized to modify VOUCHER table data.', 16, 1)
      ROLLBACK
   END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Update Trigger tu_Voucher_Delete
Created 04-27-2007 by Terry Watkins

04-27-2007 Terry Watkins
  Allow deletion by tp user only.
--------------------------------------------------------------------------------
*/
CREATE TRIGGER [dbo].[tu_Voucher_Delete] ON [dbo].[VOUCHER]
FOR DELETE
AS

-- Variable Declarations
DECLARE @UserName VarChar(128)

-- Store current user name in lower case.
SET @UserName = LOWER(USER_NAME())
IF (@UserName <> 'tp')
   BEGIN
      RAISERROR('You are not authorized to modify VOUCHER table data.', 16, 1)
      ROLLBACK TRANSACTION
   END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Update Trigger tu_Voucher_Update
Created 05-02-2005 by Terry Watkins

03-27-2007 Terry Watkins
  Added code to force updates by tp user only.

07-22-2008 Aldo Zamora
  Changed code to allow modifications only by VMod role members.
--------------------------------------------------------------------------------
*/
CREATE TRIGGER [dbo].[tu_Voucher_Update] ON [dbo].[VOUCHER] 
FOR UPDATE
AS
-- Variable Declarations
DECLARE @AmtNew   Money
DECLARE @AmtOld   Money
DECLARE @UserName VarChar(128)
DECLARE @IsInRole Bit

-- Store current user name in lower case.
SET @IsInRole = [dbo].[UserInRole]('VMod', CURRENT_USER)

IF (@IsInRole = 1)
   BEGIN
      IF UPDATE(VOUCHER_AMOUNT)
         BEGIN
            SELECT @AmtOld = VOUCHER_AMOUNT FROM Deleted
            SELECT @AmtNew = VOUCHER_AMOUNT FROM Inserted
            IF (@AmtOld <> @AmtNew)
               BEGIN
                  RAISERROR ('Invalid Voucher Amount change.', 16, 1)
                  ROLLBACK TRANSACTION
               END
         END
   END
ELSE
   -- User is not TP so raise an error...
   BEGIN
      RAISERROR('You are not authorized to modify VOUCHER table data.', 16, 1)
      ROLLBACK
   END
GO
ALTER TABLE [dbo].[VOUCHER] ADD CONSTRAINT [PK_VOUCHER] PRIMARY KEY CLUSTERED  ([VOUCHER_ID], [LOCATION_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_BARCODE] ON [dbo].[VOUCHER] ([BARCODE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_VOUCHER_CREATED_LOC_REDEEMED_STATE] ON [dbo].[VOUCHER] ([CREATED_LOC], [REDEEMED_STATE]) INCLUDE ([REDEEMED_DATE], [VOUCHER_AMOUNT], [VOUCHER_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_VOUCHER_CL_RS_RD] ON [dbo].[VOUCHER] ([CREATED_LOC], [REDEEMED_STATE], [REDEEMED_DATE]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_VOUCHER_CT_TRANS_NO_JP] ON [dbo].[VOUCHER] ([CT_TRANS_NO_JP]) INCLUDE ([VOUCHER_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_VOUCHER_CT_TRANS_NO_VR] ON [dbo].[VOUCHER] ([CT_TRANS_NO_VR]) INCLUDE ([VOUCHER_ID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores Voucher data.', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Barcode as a character string', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'BARCODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Checksum computed from barcode, amount & redeemed_state', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'CHECK_VALUE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and Time created', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'CREATE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location (Machine) where voucher was created', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'CREATED_LOC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to CASINO_TRANS table for Jackpot Vouchers', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'CT_TRANS_NO_JP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to CASINO_TRANS table for Voucher Created', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'CT_TRANS_NO_VC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to CASINO_TRANS table for Voucher Redeemed', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'CT_TRANS_NO_VR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'GameTitleID of the machine where the voucher was printed', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'GAME_TITLE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if the voucher is valid (game machine finished printing the voucher)', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'IS_VALID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location Identifier', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'LOCATION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to the PROMO_VOUCHER_SESSION table', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'PROMO_VOUCHER_SESSION_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time voucher was redeemed', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'REDEEMED_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location (Machine or POS station) where voucher was redeemed', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'REDEEMED_LOC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if voucher has been redeemed', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'REDEEMED_STATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Session amount played as reported by the EGM', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'SESSION_PLAY_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time unclaimed voucher was transferred to Central Office', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'UCV_TRANSFER_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating if unpaid voucher was transferred to the Central Office', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'UCV_TRANSFERRED'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Voucher amount in Dollars', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'VOUCHER_AMOUNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity Int', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'VOUCHER_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'(0: Ordinary, 1: Jackpot, 2: Hand Pay, 3: Jackpot Hand Pay)', 'SCHEMA', N'dbo', 'TABLE', N'VOUCHER', 'COLUMN', N'VOUCHER_TYPE'
GO

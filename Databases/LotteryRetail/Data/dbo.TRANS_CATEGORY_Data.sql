SET IDENTITY_INSERT [dbo].[TRANS_CATEGORY] ON
INSERT INTO [dbo].[TRANS_CATEGORY] ([TRANS_CATEGORY_ID], [SHORT_NAME], [LONG_NAME]) VALUES (1, 'PLAY', 'Play Transactions (Lose, Win, Jackpot, Forfeit)')
INSERT INTO [dbo].[TRANS_CATEGORY] ([TRANS_CATEGORY_ID], [SHORT_NAME], [LONG_NAME]) VALUES (2, 'MONEY', 'Money Transactions (Money/Vouchers in or out of machines, Drop)')
INSERT INTO [dbo].[TRANS_CATEGORY] ([TRANS_CATEGORY_ID], [SHORT_NAME], [LONG_NAME]) VALUES (3, 'OPEN', 'Door open (Machine, Logic Board, Cashbox)')
INSERT INTO [dbo].[TRANS_CATEGORY] ([TRANS_CATEGORY_ID], [SHORT_NAME], [LONG_NAME]) VALUES (4, 'CARD', 'Card Transactions (Insert, Extract)')
INSERT INTO [dbo].[TRANS_CATEGORY] ([TRANS_CATEGORY_ID], [SHORT_NAME], [LONG_NAME]) VALUES (5, 'STATUS', 'Status Transactions')
INSERT INTO [dbo].[TRANS_CATEGORY] ([TRANS_CATEGORY_ID], [SHORT_NAME], [LONG_NAME]) VALUES (6, 'REQUEST', 'Machine Request (Shutdown, Setup, Ticket)')
INSERT INTO [dbo].[TRANS_CATEGORY] ([TRANS_CATEGORY_ID], [SHORT_NAME], [LONG_NAME]) VALUES (7, 'MACHINE', 'Machine changes (Roll change, new logic board, etc.)')
INSERT INTO [dbo].[TRANS_CATEGORY] ([TRANS_CATEGORY_ID], [SHORT_NAME], [LONG_NAME]) VALUES (8, 'TRANSFER', 'Monetary transfer (EGM to Host or Host to EGM)')
SET IDENTITY_INSERT [dbo].[TRANS_CATEGORY] OFF

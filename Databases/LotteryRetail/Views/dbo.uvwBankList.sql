SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[uvwBankList]
AS
SELECT
   b.BANK_NO AS BankNbr,
   ISNULL(b.BANK_DESCR, '')          AS BankDesc,
   b.ENTRY_TICKET_FACTOR             AS [Entry Ticket Factor],
   b.ENTRY_TICKET_AMOUNT             AS [Entry Ticket Amount],
   b.LOCKUP_AMOUNT                   AS [Lockup Amt],
   b.DBA_LOCKUP_AMOUNT               AS [DBA Lockup Amt],
   ISNULL(gt.GAME_TYPE_CODE, '')     AS GameTypeCode,
   ISNULL(gt.LONG_NAME, '')          AS GameTypeName,
   CASE gt.PROGRESSIVE_TYPE_ID WHEN 0 THEN 'No' ELSE 'Yes' END AS ProgFlag,
   ISNULL(gt.MAX_COINS_BET, 1)       AS MaxCoins,
   ISNULL(gt.MAX_LINES_BET, 1)       AS MaxLines,
   gt.PRODUCT_ID                     AS [Product ID],
   ISNULL(p.PRODUCT_DESCRIPTION, '') AS Product,
   b.PRODUCT_LINE_ID                 AS [Product Line ID],
   pl.LONG_NAME                      AS ProductLine
FROM BANK b
   LEFT OUTER JOIN GAME_TYPE    gt ON b.GAME_TYPE_CODE = gt.GAME_TYPE_CODE
   LEFT OUTER JOIN PRODUCT_LINE pl ON b.PRODUCT_LINE_ID = pl.PRODUCT_LINE_ID
   LEFT OUTER JOIN PRODUCT       p ON gt.PRODUCT_ID = p.PRODUCT_ID
GO

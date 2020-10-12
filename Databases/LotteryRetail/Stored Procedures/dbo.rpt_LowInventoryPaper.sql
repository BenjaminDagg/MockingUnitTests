SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure: rpt_LowInventoryPaper user stored procedure.

  Created: 09-24-2007 by Terry Watkins

Description:
   This procedure will report the Form Numbers of all the Paper Deals that
   are within 95% of being played out.

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Terry Watkins 07-20-2007     6.0.1
  Initial coding.
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[rpt_LowInventoryPaper]

AS
BEGIN

-- Variable Declarations
DECLARE @DealNbr           Int
DECLARE @DealsAt95Percent  Int
DECLARE @NextTicket        Int
DECLARE @TabsPerDeal       Int
DECLARE @TotalDeals        Int

DECLARE @FormNumb          VarChar(10)
DECLARE @GameTypeCode      VarChar(8)

DECLARE @MaxAcctDate       DateTime

DECLARE @ResultsTable      Table (GameTypeCode  VarChar(2),
                                  FormNumber    VarChar(10),
                                  OpenDeals     Int,
                                  DealsAt95Pct  Int)

-- SET NOCOUNT ON to suppress extra result sets interfering with SELECT statements
SET NOCOUNT ON

-- Get the most recent ACCT_DATE when there was machine activity.
SELECT @MaxAcctDate = MAX(ACCT_DATE) FROM MACHINE_STATS

-- Declare a Cursor that returns distinct GAME_TYPE_CODEs from BANK
-- for any Machine that has had activity within the last 7 days.
DECLARE GameTypeCodeList CURSOR FOR
	SELECT DISTINCT b.GAME_TYPE_CODE 
    FROM BANK b
       JOIN MACH_SETUP m ON b.BANK_NO = m.BANK_NO
    WHERE MACH_NO IN
		(SELECT DISTINCT ms.MACH_NO FROM MACHINE_STATS ms 
		 WHERE DATEDIFF(DAY, @MaxAcctDate, ms.ACCT_DATE) <= 7)

-- For each Game_Type_Code get the Active Form # associated with it.
OPEN GameTypeCodeList

FETCH NEXT FROM GameTypeCodeList INTO @GameTypeCode
WHILE @@FETCH_STATUS = 0
   BEGIN
      -- Declare a cursor to retrieve all the active
      -- paper Form Numbers for this Game_Type_Code.
      DECLARE FormNumberList CURSOR FOR
	      SELECT FORM_NUMB
          FROM CASINO_FORMS
          WHERE
             GAME_TYPE_CODE = @GameTypeCode AND
             IS_ACTIVE =1                   AND
             IS_PAPER = 1
      
      OPEN FormNumberList
      FETCH NEXT FROM FormNumberList INTO @FormNumb
      WHILE @@FETCH_STATUS = 0
         BEGIN
            --PRINT 'GameTypeCode = ' + @GameTypeCode + '  Form Numb = ' + @FormNumb
            
            -- Initialize the Total Deal & Deals At 95% counters
            SET @TotalDeals = 0
            SET @DealsAt95Percent = 0
            
            -- Get open Deals that belong to each Form from DEAL_SETUP.
            -- Note: Join to Deal Sequence to get only Dakata Deals (not Compact or Bingo)
            DECLARE DealList CURSOR FOR
               SELECT
                  ds.DEAL_NO,
                  ds.TABS_PER_ROLL * ds.NUMB_ROLLS AS TABS_PER_DEAL,
                  dsq.NEXT_TICKET
               FROM DEAL_SETUP ds
                  JOIN DEAL_SEQUENCE dsq ON ds.DEAL_NO = dsq.DEAL_NO
               WHERE
                  ds.FORM_NUMB = @FormNumb AND
                  ds.IS_OPEN = 1
            
            OPEN DealList
            FETCH NEXT FROM DealList INTO @DealNbr, @TabsPerDeal, @NextTicket
            WHILE @@FETCH_STATUS = 0
               BEGIN
                  -- PRINT 'Deal Number: '   + CAST(@DealNbr AS VarChar) +
                  --       '  TPD: '         + CAST(@TabsPerDeal AS VarChar) +
                  --       '  Next Ticket: ' + CAST(@NextTicket AS VarChar)
                  
                  -- Increment the Total Deal Counter
                  SET @TotalDeals = @TotalDeals + 1
                  
                  -- If this DealNo is at 95 % increment the Deals At 95% counter
                  IF (@NextTicket > ((95 * @TabsPerDeal) / 100 ))
                     SET @DealsAt95Percent = @DealsAt95Percent + 1
                  
                  FETCH NEXT FROM DealList INTO @DealNbr, @TabsPerDeal, @NextTicket
               END -- Deal_No_Cursor
               
               -- Insert the Row Data into the Table var. for later select.
               INSERT INTO @ResultsTable VALUES
               (@GameTypeCode, @FormNumb, @TotalDeals, @DealsAt95Percent)
            
            CLOSE DealList
            DEALLOCATE DealList
            
            FETCH NEXT FROM FormNumberList INTO @FormNumb
         END -- FormNumberList cursor fetch loop.
      
      CLOSE FormNumberList
      DEALLOCATE FormNumberList
      
      FETCH NEXT FROM GameTypeCodeList INTO @GameTypeCode
   END -- GameTypeCodeList cursor fetch loop.

CLOSE GameTypeCodeList
DEALLOCATE GameTypeCodeList

-- Return the Result Set of the report.
SELECT GameTypeCode, FormNumber, OpenDeals, DealsAt95Pct
FROM @ResultsTable ORDER BY FormNumber

END

GO

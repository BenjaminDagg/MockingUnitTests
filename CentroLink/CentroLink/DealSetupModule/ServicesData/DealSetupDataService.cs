using System.Collections.Generic;
using CentroLink.DealSetupModule.Models;
using Framework.Infrastructure.Data.Database;
using Framework.Infrastructure.Data.DataSources;

namespace CentroLink.DealSetupModule.ServicesData
{
    public class DealSetupDataService : ApplicationDbService, IDealSetupDataService
    {

        public DealSetupDataService(IDbConnectionInfo dbConnectionInfo) : base(dbConnectionInfo)
        {
        }

        public List<LowInventoryPaperResult> GetLowInventoryPaper()
        {
			//TODO: BitOmni to DG Do you want this stored procedure to be refactored. Using cursor and difficult logic
            var result = Db.Fetch<LowInventoryPaperResult>("EXEC [rpt_LowInventoryPaper]");

            return result;
        }

		public List<DealSetupListModel> DealSetup()
        {
            const string sql = @"
SELECT	ds.DEAL_NO DealNumber, 
			ds.DEAL_DESCR [Description], 
			cf.Is_Paper as IsPaper,
			ds.NUMB_ROLLS NumberOfRolls,
			ds.TABS_PER_ROLL TabsPerRoll,
            ds.COST_PER_TAB CostPerTab,
			ds.JP_AMOUNT JackpotAmount,
			ds.FORM_NUMB FormNumber,
			ds.TAB_AMT TabAmount,
			ds.TYPE_ID TypeId,
			ds.GAME_CODE GameCode,
			ds.IS_OPEN IsOpen,
			ISNULL(dts.PLAY_COUNT, 0) TabsPlayed,
			ISNULL(gt.PRODUCT_ID, 0) ProductId,
			ISNULL(p.PRODUCT_DESCRIPTION, '') as ProductDescription
	FROM DEAL_SETUP ds	
	LEFT OUTER JOIN DEAL_STATS dts ON ds.DEAL_NO = dts.DEAL_NO 
	LEFT OUTER JOIN GAME_SETUP gs ON ds.GAME_CODE = gs.GAME_CODE 
	LEFT OUTER JOIN GAME_TYPE gt ON gt.GAME_TYPE_CODE = gs.GAME_TYPE_CODE
	LEFT OUTER JOIN CASINO_FORMS cf on ds.FORM_NUMB = cf.FORM_NUMB
	LEFT JOIN PRODUCT p on gt.PRODUCT_ID = p.PRODUCT_ID
	WHERE ds.DEAL_NO > 0 
	ORDER BY ds.DEAL_NO";

            var list = Db.Fetch<DealSetupListModel>(sql);

            return list;


        }

    }
}

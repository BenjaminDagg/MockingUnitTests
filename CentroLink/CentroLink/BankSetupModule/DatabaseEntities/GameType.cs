// ReSharper disable RedundantUsingDirective
// ReSharper disable DoNotCallOverridableMethodsInConstructor
// ReSharper disable InconsistentNaming
// ReSharper disable PartialTypeWithSinglePart
// ReSharper disable PartialMethodWithSinglePart
// ReSharper disable RedundantNameQualifier
// ReSharper disable UnusedMember.Global

using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using NPoco;

namespace CentroLink.BankSetupModule.DatabaseEntities
{

    // ************************************************************************
    // POCO classes

    // GAME_TYPE
	[ExcludeFromCodeCoverage]   //code generated 
    [TableName("GAME_TYPE")]
	[PrimaryKey("GAME_TYPE_CODE", AutoIncrement=false)]
    public partial class GameType
    {

		[Column("GAME_TYPE_CODE")]
		[MaxLength(2)]
        public string GameTypeCode { get; set; } // GAME_TYPE_CODE (Primary key)

		[Column("LONG_NAME")]
		[MaxLength(64)]
        public string LongName { get; set; } // LONG_NAME

		[Column("TYPE_ID")]
		[MaxLength(1)]
        public string TypeId { get; set; } // TYPE_ID

		[Column("GAME_CATEGORY_ID")]
        public int GameCategoryId { get; set; } // GAME_CATEGORY_ID

		[Column("PRODUCT_ID")]
        public byte ProductId { get; set; } // PRODUCT_ID

		[Column("PROGRESSIVE_TYPE_ID")]
        public int ProgressiveTypeId { get; set; } // PROGRESSIVE_TYPE_ID

		[Column("BARCODE_TYPE_ID")]
        public short BarcodeTypeId { get; set; } // BARCODE_TYPE_ID

		[Column("MAX_COINS_BET")]
        public short MaxCoinsBet { get; set; } // MAX_COINS_BET

		[Column("MAX_LINES_BET")]
        public byte MaxLinesBet { get; set; } // MAX_LINES_BET

		[Column("MULTI_BET_DEALS")]
        public bool MultiBetDeals { get; set; } // MULTI_BET_DEALS

		[Column("SHOW_PAY_CREDITS")]
        public bool ShowPayCredits { get; set; } // SHOW_PAY_CREDITS

		[Column("IS_ACTIVE")]
        public bool IsActive { get; set; } // IS_ACTIVE

        public GameType()
        {
            GameCategoryId = 0;
            ProgressiveTypeId = 0;
            BarcodeTypeId = 0;
            MultiBetDeals = false;
            ShowPayCredits = true;
            InitializePartial();
        }
        partial void InitializePartial();
    }

}

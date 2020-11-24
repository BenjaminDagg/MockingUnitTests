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

    // PRODUCT_LINE
    [ExcludeFromCodeCoverage]   //code generated 
    [TableName("PRODUCT_LINE")]
	[PrimaryKey("PRODUCT_LINE_ID", AutoIncrement=false)]
    public partial class ProductLine
    {

		[Column("PRODUCT_LINE_ID")]
        public short ProductLineId { get; set; } // PRODUCT_LINE_ID (Primary key)

		[Column("LONG_NAME")]
		[MaxLength(64)]
        public string LongName { get; set; } // LONG_NAME

		[Column("GAME_CLASS")]
        public short GameClass { get; set; } // GAME_CLASS

		[Column("EGM_DEAL_GC_MATCH")]
        public bool EgmDealGcMatch { get; set; } // EGM_DEAL_GC_MATCH

		[Column("IS_ACTIVE")]
        public bool IsActive { get; set; } // IS_ACTIVE

        public ProductLine()
        {
            GameClass = 0;
            EgmDealGcMatch = false;
            IsActive = true;
            InitializePartial();
        }
        partial void InitializePartial();
    }

}

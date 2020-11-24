// ReSharper disable RedundantUsingDirective
// ReSharper disable DoNotCallOverridableMethodsInConstructor
// ReSharper disable InconsistentNaming
// ReSharper disable PartialTypeWithSinglePart
// ReSharper disable PartialMethodWithSinglePart
// ReSharper disable RedundantNameQualifier
// ReSharper disable UnusedMember.Global
using System;
using System.Diagnostics.CodeAnalysis;
using System.Collections.Generic;
using NPoco;
using System.ComponentModel.DataAnnotations;

namespace CentroLink.LocationSetupModule.DatabaseEntities
{

    // ************************************************************************
    // POCO classes

    // TPI
	[ExcludeFromCodeCoverage]   //code generated 
    [TableName("TPI")]
	[PrimaryKey("TPI_ID", AutoIncrement=false)]
    public partial class Tpi
    {

		[Column("TPI_ID")]
        public int TpiId { get; set; } // TPI_ID (Primary key)

		[Column("SHORT_NAME")]
		[MaxLength(16)]
        public string ShortName { get; set; } // SHORT_NAME

		[Column("LONG_NAME")]
		[MaxLength(64)]
        public string LongName { get; set; } // LONG_NAME
    }

}

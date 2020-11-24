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

namespace CentroLink.MachineSetupModule.DatabaseEntities
{

    // ************************************************************************
    // POCO classes

    // MACH_SETUP_GAMES
	[ExcludeFromCodeCoverage]   //code generated 
    [TableName("MACH_SETUP_GAMES")]
	[PrimaryKey("GAME_CODE", AutoIncrement=false)]
    public partial class MachSetupGame
    {

		[Column("MACH_NO")]
		[MaxLength(5)]
        public string MachNo { get; set; } // MACH_NO (Primary key)

		[Column("LOCATION_ID")]
        public int LocationId { get; set; } // LOCATION_ID

		[Column("GAME_CODE")]
		[MaxLength(3)]
        public string GameCode { get; set; } // GAME_CODE (Primary key)

		[Column("BANK_NO")]
        public int BankNo { get; set; } // BANK_NO

		[Column("TYPE_ID")]
		[MaxLength(1)]
        public string TypeId { get; set; } // TYPE_ID

		[Column("GAME_RELEASE")]
		[MaxLength(16)]
        public string GameRelease { get; set; } // GAME_RELEASE

		[Column("MATH_DLL_VERSION")]
		[MaxLength(16)]
        public string MathDllVersion { get; set; } // MATH_DLL_VERSION

		[Column("MATH_LIB_VERSION")]
		[MaxLength(16)]
        public string MathLibVersion { get; set; } // MATH_LIB_VERSION

        public bool IsEnabled { get; set; } // IsEnabled

        // Foreign keys
        [Ignore]                //Ignore Navigation properties from being mapped for NPOCO
        public virtual MachSetup MachSetup { get; set; } //  FK_MACH_SETUP_MACH_NO
    }

}

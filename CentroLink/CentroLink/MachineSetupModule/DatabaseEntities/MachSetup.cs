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
using Framework.Core.Timers;

namespace CentroLink.MachineSetupModule.DatabaseEntities
{

    // ************************************************************************
    // POCO classes

    // MACH_SETUP
	[ExcludeFromCodeCoverage]   //code generated 
    [TableName("MACH_SETUP")]
	[PrimaryKey("LOCATION_ID", AutoIncrement=false)]
    public partial class MachSetup
    {

		[Column("MACH_NO")]
		[MaxLength(5)]
        public string MachNo { get; set; } // MACH_NO (Primary key)

		[Column("LOCATION_ID")]
        public int LocationId { get; set; } // LOCATION_ID (Primary key)

		[Column("MODEL_DESC")]
		[MaxLength(64)]
        public string ModelDesc { get; set; } // MODEL_DESC

		[Column("TYPE_ID")]
		[MaxLength(1)]
        public string TypeId { get; set; } // TYPE_ID

		[Column("GAME_CODE")]
		[MaxLength(3)]
        public string GameCode { get; set; } // GAME_CODE

		[Column("BANK_NO")]
        public int? BankNo { get; set; } // BANK_NO

		[Column("CASINO_MACH_NO")]
		[MaxLength(8)]
        public string CasinoMachNo { get; set; } // CASINO_MACH_NO

		[Column("IP_ADDRESS")]
		[MaxLength(24)]
        public string IpAddress { get; set; } // IP_ADDRESS

		[Column("PLAY_STATUS")]
        public bool PlayStatus { get; set; } // PLAY_STATUS

		[Column("PLAY_STATUS_CHANGED")]
        public DateTime? PlayStatusChanged { get; set; } // PLAY_STATUS_CHANGED

		[Column("ACTIVE_FLAG")]
        public byte ActiveFlag { get; set; } // ACTIVE_FLAG

		[Column("REMOVED_FLAG")]
        public bool RemovedFlag { get; set; } // REMOVED_FLAG

		[Column("BALANCE")]
        public decimal Balance { get; set; } // BALANCE

		[Column("PROMO_BALANCE")]
        public decimal PromoBalance { get; set; } // PROMO_BALANCE

		[Column("LAST_ACTIVITY")]
        public DateTime? LastActivity { get; set; } // LAST_ACTIVITY

		[Column("LAST_CONNECT")]
        public DateTime? LastConnect { get; set; } // LAST_CONNECT

		[Column("LAST_DISCONNECT")]
        public DateTime? LastDisconnect { get; set; } // LAST_DISCONNECT

		[Column("MACH_SERIAL_NO")]
		[MaxLength(15)]
        public string MachSerialNo { get; set; } // MACH_SERIAL_NO

		[Column("VOUCHER_PRINTING")]
        public bool VoucherPrinting { get; set; } // VOUCHER_PRINTING

		[Column("METER_TRANS_NO")]
        public int MeterTransNo { get; set; } // METER_TRANS_NO

		[Column("SD_RS_FLAG")]
        public bool SdRsFlag { get; set; } // SD_RS_FLAG

		[Column("GAME_RELEASE")]
		[MaxLength(16)]
        public string GameRelease { get; set; } // GAME_RELEASE

		[Column("GAME_CORE_LIB_VERSION")]
		[MaxLength(16)]
        public string GameCoreLibVersion { get; set; } // GAME_CORE_LIB_VERSION

		[Column("GAME_LIB_VERSION")]
		[MaxLength(16)]
        public string GameLibVersion { get; set; } // GAME_LIB_VERSION

		[Column("MATH_DLL_VERSION")]
		[MaxLength(16)]
        public string MathDllVersion { get; set; } // MATH_DLL_VERSION

		[Column("MATH_LIB_VERSION")]
		[MaxLength(16)]
        public string MathLibVersion { get; set; } // MATH_LIB_VERSION

		[Column("OS_VERSION")]
		[MaxLength(16)]
        public string OsVersion { get; set; } // OS_VERSION

		[Column("SYSTEM_VERSION")]
		[MaxLength(16)]
        public string SystemVersion { get; set; } // SYSTEM_VERSION

		[Column("SYSTEM_LIB_A_VERSION")]
		[MaxLength(16)]
        public string SystemLibAVersion { get; set; } // SYSTEM_LIB_A_VERSION

		[Column("SYSTEM_CORE_LIB_VERSION")]
		[MaxLength(16)]
        public string SystemCoreLibVersion { get; set; } // SYSTEM_CORE_LIB_VERSION

        public DateTime? InstallDate { get; set; } // InstallDate

        public DateTime? RemoveDate { get; set; } // RemoveDate

        public bool MultiGameEnabled { get; set; } // MultiGameEnabled

		[MaxLength(24)]
        public string TransactionPortalIpAddress { get; set; } // TransactionPortalIpAddress

        public int? TransactionPortalControlPort { get; set; } // TransactionPortalControlPort

        // Reverse navigation
        [Ignore]                //Ignore Navigation properties from being mapped for NPOCO
        public virtual ICollection<MachSetupGame> MachSetupGames { get; set; } // Many to many mapping

        public MachSetup()
        {
            PlayStatus = false;
            ActiveFlag = 1;
            RemovedFlag = false;
            Balance = 0m;
            PromoBalance = 0m;
            VoucherPrinting = false;
            MeterTransNo = 0;
            SdRsFlag = false;
            GameRelease = "";
            GameCoreLibVersion = "";
            GameLibVersion = "";
            MathDllVersion = "";
            MathLibVersion = "";
            OsVersion = "";
            SystemVersion = "";
            SystemLibAVersion = "";
            SystemCoreLibVersion = "";
            InstallDate = SystemClock.Now;
            MultiGameEnabled = false;
            MachSetupGames = new List<MachSetupGame>();
            InitializePartial();
        }
        partial void InitializePartial();
    }

}

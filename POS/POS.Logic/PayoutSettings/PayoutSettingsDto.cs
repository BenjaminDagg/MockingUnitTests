


namespace POS.Core.PayoutSettings
{
    public class PayoutSettingsDto
    {
        //commenting out unused properties

        //public string SecondaryCasinoId { get; set; }
        public decimal LockupAmount { get; set; }
        public bool AllowReceiptReprint { get; set; }

        //public bool SavePosCardInserts { get; set; }

        //public decimal DollarsPerPoint { get; set; }

        //public int RedeemMultiple { get; set; }
        public bool CashierCanActivate { get; set; }

        //public int PayoutTabs { get; set; }

        //public int VoucherExpireDays { get; set; }
        public decimal PayoutThreshold { get; set; }
        public int LocationId { get; set; }

    }
}

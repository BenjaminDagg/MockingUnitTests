using POS.Core.Config;

namespace POS.Infrastructure.Config
{
    public class VoucherSettingsFileConfig : /*FileConfigItem,*/ IVoucherSettings
    {
        public int VoucherCharacterLength { get; set; }
    }
}



using POS.Core.Config;

namespace POS.Infrastructure.Config
{
    public class NeedApprovalConfig : INeedApproval
    {
        public bool IsApprovalRequired { get ; set ; }
    }
}

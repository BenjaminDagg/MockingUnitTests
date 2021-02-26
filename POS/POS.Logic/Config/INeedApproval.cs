namespace POS.Core.Config
{
    public interface INeedApproval
    {
        bool IsApprovalRequired { get; set; }
    }
}

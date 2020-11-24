using System.ComponentModel.DataAnnotations;
using Framework.Infrastructure.Data.Configuration;

namespace CentroLink.MachineSetupModule.Settings
{
    public class TransactionPortalSettings : DataConfigItem
    {
        /// <summary>
        /// Milliseconds before a connection or message times out.
        /// </summary>
        [Required]
        public int TransactionPortalConnectionTimeout { get; set; }
    }
}
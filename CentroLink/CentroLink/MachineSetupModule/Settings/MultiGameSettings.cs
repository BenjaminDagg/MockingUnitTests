
using Framework.Infrastructure.Data.Configuration;

namespace CentroLink.MachineSetupModule.Settings
{
    /// <summary>
    /// Database config for multi game settings
    /// </summary>
    public class MultiGameSettings : DataConfigItem
    {
        /// <summary>
        /// Gets or sets a value indicating whether [multi game enabled].
        /// </summary>
        /// <value>
        ///   <c>true</c> if [multi game enabled]; otherwise, <c>false</c>.
        /// </value>
        public bool MultiGameEnabled { get; set; }
    }
}
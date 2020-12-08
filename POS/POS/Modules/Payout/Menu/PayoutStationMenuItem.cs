using Framework.WPF.FontAwesome;
using Framework.WPF.Menu;

namespace POS.Modules.Payout.Menu
{
    public class PayoutStationMenuItem : MenuItem
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="MaintenanceMenuItem"/> class.
        /// </summary>
        public PayoutStationMenuItem()
        {
            Name = "Payout Station";
            AllowAnyAuthenticatedUser = true;
            FontAwesomeIcon = FontAwesomeIcons.Ticket;

            SortOrder = 200;
        }

        /// <summary>
        /// Gets a value indicating whether class performs an action.
        /// If false this menu will be invisible if there are no children the user has access to
        /// </summary>
        public override bool PerformsAction => false;

        /// <summary>
        /// Executes button click.
        /// </summary>
        public override void Execute()
        {
            IsExpanded = !IsExpanded;
        }
    }
}

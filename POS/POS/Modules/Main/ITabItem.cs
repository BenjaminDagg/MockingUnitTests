using Caliburn.Micro;
using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Modules.Main
{
    public interface ITabItem : IScreen
    {
        int IndexPriority { get; set; }
        bool UserHasPermission { get; set; }
        bool Enabled { get; set; }
        bool AllowAuthenticatedUser { get; set; }
    }
}

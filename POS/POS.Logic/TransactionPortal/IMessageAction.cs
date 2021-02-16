using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Core.TransactionPortal
{
    public interface IMessageAction
    {
        string Name { get; }
        Action<object> this[string name] { get; }
        void ConfigureCommandAction(string command, Action<object> action);
        void Execute(string message);
        void Execute(string message, string[] actions);
    }
}

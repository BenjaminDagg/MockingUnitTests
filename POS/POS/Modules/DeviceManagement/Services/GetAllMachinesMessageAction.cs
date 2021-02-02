using POS.Core.TransactionPortal;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace POS.Modules.DeviceManagement.Services
{
    public class GetAllMachinesMessageAction : IMessageAction
    {
        public GetAllMachinesMessageAction()
        {
            ActionStore = new Dictionary<string, Action<object>>();
        }
        IDictionary<string, Action<object>> _actionStore;
        public IDictionary<string, Action<object>> ActionStore
        {
            get { return _actionStore; }
            set { _actionStore = value; }
        }

        public string Name => nameof(GetAllMachinesMessageAction);

        public Action<object> this[string name] 
        { 
            get  
            {
                if (ActionStore.ContainsKey(name))
                {
                    return ActionStore[name];
                }
                else
                {
                    return null;
                }
            }
        }

        public void Execute(string message)
        {
            if (ActionStore != null && ActionStore.Count > 0)
            {
                var fields = ValidateAndParseReceivedData(message);
                foreach (var action in ActionStore.Keys)
                {
                    ActionStore[action].Invoke(fields);
                }
            }
        }

        public void Execute(string message, string[] actions)
        {
            if (ActionStore != null && ActionStore.Count > 0)
            {
                var fields = ValidateAndParseReceivedData(message);

                if(actions != null && actions.Length > 0)
                {
                    foreach(var action in actions)
                    {
                        if(ActionStore.ContainsKey(action))
                        {
                            ActionStore[action].Invoke(fields);
                        }
                    }
                }
            }
        }

        private string[] ValidateAndParseReceivedData(string dataRecieved)
        {
            int errorCode = default;
            string[] fields;
            try
            {
                fields = dataRecieved.Split(',');
                if (fields != null)
                {
                    if (((fields.Length - 8) % 9) != 0)
                    {
                        throw new FormatException("Invalid data recieved from TP Service");
                    }

                    if (fields.GetUpperBound(0) > 4)
                    {
                        var messageSequenceInProperFormat = Regex.IsMatch(fields[0], @"\A^\d+$\Z");
                        var transTypeInProperFormat = Regex.IsMatch(fields[1], @"^\w+$");
                        var timeStampInProperFormat = Regex.IsMatch(fields[2], @"^\d{4}[-]\d\d-\d\d \d\d:\d\d:\d\d$");
                        var errorCodeInProperFormat = Regex.IsMatch(fields[3], @"^\d+$");

                        if (messageSequenceInProperFormat &&
                            transTypeInProperFormat)
                        {
                            var transType = fields[1];

                            if (timeStampInProperFormat &&
                                errorCodeInProperFormat)
                            {
                                errorCode = Convert.ToInt32(fields[3]);
                            }

                            if (errorCode == 0 && transType == "Z")
                            {
                                return fields;
                            }
                        }
                    }
                }
            }
            catch
            {
                throw;
            }

            return fields;
        }
    }
}

using POS.Core.TransactionPortal;
using POS.Modules.DeviceManagement.Constants;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace POS.Modules.DeviceManagement.Services
{
    public class GetAllMachinesMessageAction : IMessageAction
    {
        public GetAllMachinesMessageAction()
        {
            _actionStore = new Dictionary<string, Action<object>>();
        }
        IDictionary<string, Action<object>> _actionStore;

        public void ConfigureCommandAction(string command, Action<object> action)
        {
            if (!_actionStore.ContainsKey(command))
            {
                _actionStore.Add(command, action);
            }
        }

        public string Name => nameof(GetAllMachinesMessageAction);

        public Action<object> this[string name]
        {
            get
            {
                if (_actionStore.ContainsKey(name))
                {
                    return _actionStore[name];
                }
                else
                {
                    return null;
                }
            }
        }

        public void Execute(string message)
        {
            if (_actionStore != null && _actionStore.Count > 0)
            {
                var fields = ValidateAndParseReceivedData(message);
                if (fields != null)
                {
                    foreach (var action in _actionStore.Keys)
                    {
                        _actionStore[action]?.Invoke(fields);
                    }
                }
            }
        }

        public void Execute(string message, string[] actions)
        {
            if (_actionStore != null && _actionStore.Count > 0)
            {
                var fields = ValidateAndParseReceivedData(message);

                if (fields != null)
                {
                    if (actions != null && actions.Length > 0)
                    {
                        foreach (var action in actions)
                        {
                            if (_actionStore.ContainsKey(action))
                            {
                                _actionStore[action]?.Invoke(fields);
                            }
                        }
                    }
                }
            }
        }

        private string[] ValidateAndParseReceivedData(string dataRecieved)
        {
            var IsNotNullOrEmpty = !String.IsNullOrEmpty(dataRecieved);
            var isConfiguredToHandleMessage = IsConfiguredToHandleMessage(dataRecieved);

            if (IsNotNullOrEmpty && isConfiguredToHandleMessage)
            {
                int errorCode = default;
                string[] fields;
                try
                {
                    fields = dataRecieved.Split(',');
                    if (fields != null)
                    {
                        var messageCommand = fields[6];

                        if (messageCommand == TransactionPortalActions.COMMAND_GETALLMACHINES)
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
                        else
                        {
                            return null;
                        }
                    }
                }
                catch
                {
                    throw;
                }
            }

            return null;
        }

        private IEnumerable<String> GetConfiguredActionNames()
        {
            return _actionStore.Keys;
        }

        private bool IsConfiguredToHandleMessage(string messageRecieved)
        {
            foreach (var configuredActionName in GetConfiguredActionNames())
            {
                if (messageRecieved.Contains(configuredActionName))
                {
                    return true;
                }
            }
            return false;
        }
    }
}

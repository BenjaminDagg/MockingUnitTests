using System;
using POS.Core.ValueObjects;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace POS.Core.Transaction
{
    public class PrintCashDrawerHistory
    {
        public string Username { get; set; }

        public List<(string Type, Double Amount, DateTime TransactionDate)> PrintList { get; set; }

        public PrintCashDrawerHistory(string username, List<(string Type, Double Amount, DateTime TransactionDate)> printList)
        {
            Username = username;
            PrintList = printList;
        }
    }
}

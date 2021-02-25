using POS.Core.CashDrawer;
using POS.Core.Transaction;
using POS.Modules.Payout.Models;
using System;
using System.Collections.Generic;

namespace POS.Modules.CashDrawerHistorys.Models
{
    public static class CashDrawerHistoryTranslator
    {
        public static CashDrawerHistory Translate(CashDrawerHistoryDto cashDrawerHistoryDto)
        {
            if(cashDrawerHistoryDto == null)
            {
                return null;
            }

            var type = (TransactionType)Enum.Parse(typeof(TransactionType), cashDrawerHistoryDto.TransactionType);

            return new CashDrawerHistory
            {
                Type = type,
                TypeName = TranslateTransactionTypeName(type),
                Amount = TranslateAmountBasedOnTransactionType(cashDrawerHistoryDto.Amount, type),
                CreatedDate = cashDrawerHistoryDto.CreatedDate
            };
        }

        public static CashDrawerHistoryDto Translate(CashDrawerHistory cashDrawerHistory)
        {
            if (cashDrawerHistory == null)
            {
                return null;
            }

            return new CashDrawerHistoryDto
            {
                TransactionType = cashDrawerHistory.Type.ToString(),
                Amount = cashDrawerHistory.Amount,
                CreatedDate = cashDrawerHistory.CreatedDate
            };
        }

        public static IEnumerable<CashDrawerHistory> Translate(IEnumerable<CashDrawerHistoryDto> cashDrawerHistoryDtos)
        {
            if (cashDrawerHistoryDtos == null)
            {
                return null;
            }

            List<CashDrawerHistory> cashDrawerHistories = new List<CashDrawerHistory>();

            foreach (CashDrawerHistoryDto cashDrawerHistoryDto in cashDrawerHistoryDtos)
            {
                cashDrawerHistories.Add(Translate(cashDrawerHistoryDto));
            }

            return cashDrawerHistories;
        }

        private static string TranslateTransactionTypeName(TransactionType transactionType)
        {
            switch (transactionType)
            {
                case TransactionType.A:
                    return "Add";
                case TransactionType.R:
                    return "Remove";
                case TransactionType.P:
                    return "Payout";
                case TransactionType.S:
                    return "Starting Balance";
                case TransactionType.E:
                    return "Ending Balance";
                default:
                    return String.Empty;
            }
        }

        private static double TranslateAmountBasedOnTransactionType(double amount, TransactionType transactionType)
        {
            switch (transactionType)
            {
                case TransactionType.R:
                case TransactionType.P:
                    return -(amount);
                default:
                    return amount;
            }
        }
    }
}

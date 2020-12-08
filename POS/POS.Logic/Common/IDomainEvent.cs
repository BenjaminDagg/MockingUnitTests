using System;

namespace POS.Core.Common
{
    public interface IDomainEvent
    {
        DateTime DateTimeEventOccurred { get; }
    }
}

using System;
using CSharpFunctionalExtensions;

namespace POS.Core.ValueObjects
{
    public class SessionId : ValueObject<SessionId>
    {
        public static readonly SessionId None = new SessionId(null);


        public string Value { get; }

        private SessionId(string username)
        {
            Value = $"{username}_{DateTime.Now:yymmdd_hhmm_ss}";
        }

        public static Result<SessionId> Create(string username)
        {
            username = (username ?? string.Empty).Trim();
            return string.IsNullOrEmpty(username) 
                ? Result.Failure<SessionId>("Username is required") 
                : Result.Success(new SessionId(username));
        }

        protected override bool EqualsCore(SessionId other)
        {
            return Value == other.Value;
        }

        protected override int GetHashCodeCore()
        {
            return Value.GetHashCode();
        }

        public static implicit operator string(SessionId sessionId)
        {
            return sessionId?.Value ?? string.Empty;
        }
    }
}

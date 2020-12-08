using System;
using System.Linq.Expressions;
using POS.Core.Common.DomainValidation.Interfaces;

namespace POS.Core.Common.DomainValidation
{
    public class IsNotNull<TEntity> : ISpecification<TEntity>
    {
        private readonly Expression<Func<TEntity, object>> _expression;

        public IsNotNull(Expression<Func<TEntity, object>> expression)
        {
            _expression = expression;
        }

        public bool IsSatisfiedBy(TEntity entity)
        {
            var value = _expression.Compile()(entity);
            var type = typeof(TEntity);

            if (type == typeof(string))
                return !string.IsNullOrEmpty(value as string);
            if (type == typeof(int))
                return ((int)value) > 0;
            if (type == typeof(DateTime))
                return !((DateTime)value).Equals(DateTime.MinValue);

            return value != null;
        }
    }

}

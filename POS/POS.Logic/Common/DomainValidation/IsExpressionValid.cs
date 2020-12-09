using POS.Core.Common.DomainValidation.Interfaces;
using System;
using System.Linq.Expressions;

namespace POS.Core.Common.DomainValidation
{
    public class IsExpressionValid<TEntity> : ISpecification<TEntity>
    {
        private readonly Expression<Func<TEntity, bool>> _expression;

        public IsExpressionValid(Expression<Func<TEntity, bool>> expression)
        {
            _expression = expression;
        }

        public bool IsSatisfiedBy(TEntity entity) => this._expression.Compile()(entity);
    }

}

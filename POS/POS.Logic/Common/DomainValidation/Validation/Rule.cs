using POS.Core.Common.DomainValidation.Interfaces;

namespace POS.Core.Common.DomainValidation.Validation
{
    public class Rule<TEntity> : IRule<TEntity>
    {
        private readonly ISpecification<TEntity> _specification;

        public string ErrorMessage { get; }

        public Rule(ISpecification<TEntity> spec, string errorMessage)
        {
            _specification = spec;
            ErrorMessage = errorMessage;
        }

        public bool Validate(TEntity entity) => this._specification.IsSatisfiedBy(entity);
    }
}

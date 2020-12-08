

using POS.Core.Common.DomainValidation.Validation;

namespace POS.Core.Common.DomainValidation.Interfaces
{
    public interface IValidator<in TEntity>
    {
        ValidationResult Validate(TEntity entity);
    }
}

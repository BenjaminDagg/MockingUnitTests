namespace POS.Core.Common.DomainValidation.Interfaces
{
    public interface ISpecification<in T>
    {
        bool IsSatisfiedBy(T entity);
    }
}

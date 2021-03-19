using Framework.Infrastructure.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;

namespace POS.Modules.Main.ViewModels
{
    public class MessageBoxPromptViewModel : Framework.WPF.Modules.Shell.ViewModels.PromptBoxViewModel, IDataErrorInfo
    {
        protected EntityValidationResult ValidationResult;

        public List<ValidationResult> Errors => ValidationResult?.Errors;

        public bool ValidationEnabled { get; set; }

        public Action<string> ModelPropertyChanged;

        public virtual bool Validate()
        {
            ValidationEnabled = true;

            foreach (var property in GetType().GetProperties())
            {
                NotifyOfPropertyChange(property.Name);
            }

            if (ValidationResult == null)
            {
                ValidateEntity();
            }

            Error = ValidationResult.GetErrorSummary();

            return ValidationResult.HasError == false;
        }

        public string this[string columnName]
        {
            get
            {
                ModelPropertyChanged?.Invoke(columnName);

                return ValidateProperty(columnName);
            }
        }

        protected virtual void ValidateEntity()
        {
            ValidationResult = new EntityValidatorService().Validate(this);
        }

        protected virtual void ExcludeValidationOnProperty(string propertyName, bool shouldExclude)
        {
            if (shouldExclude)
            {
                ValidationResult.Errors.RemoveAll(validationResult => validationResult.MemberNames.ToList().Contains(propertyName)) ;
            }
        }

        protected virtual string ValidateProperty(string propertyName)
        {
            if (ValidationEnabled == false) return string.Empty;

            ValidateEntity();
            var validationErrors = ValidationResult.Errors.Where(validationResult => validationResult.MemberNames.Contains(propertyName));
            var errors = validationErrors.Select(validationResult => validationResult.ErrorMessage).ToList();

            var output = string.Empty;
            for (int i = 0; i < errors.Count; i++)
            {
                if (i == errors.Count - 1)
                {
                    output += errors[i];
                }
                else
                {
                    output += errors[i] + Environment.NewLine;
                }
            }

            return output;
        }

        public string Error { get; set; }
    }
}
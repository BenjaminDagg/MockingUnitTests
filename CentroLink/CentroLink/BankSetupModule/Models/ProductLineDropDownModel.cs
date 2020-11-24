namespace CentroLink.BankSetupModule.Models
{
    /// <summary>
    /// class used in add product dropdown and queries to populate that dropdown in add/edit screen
    /// </summary>
    public class ProductLineDropDownModel
    {
        public int ProductLineId { get; set; }

        public string Description { get; set; }
    }
}
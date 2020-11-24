namespace CentroLink.DealStatusModule.Models
{
    public class DealStatusFilterItem
    {
        public int Status { get; set; }

        public string Text { get; set; }

        public DealStatusFilterItem()
        {
            
        }

        public DealStatusFilterItem(int status, string text)
        {
            Status = status;
            Text = text;

        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using CentroLink.LocationSetupModule.DatabaseEntities;
using CentroLink.LocationSetupModule.Models;
using CentroLink.LocationSetupModule.ServicesData;
using Framework.Infrastructure.Identity.Services;

namespace CentroLink.LocationSetupModule.Services
{
    public class LocationSetupService : ILocationSetupService
    {
        private readonly ILocationSetupDataService _dataService;
        private readonly IUserSession _userSession;

        public LocationSetupService(ILocationSetupDataService dataService, IUserSession userSession)
        {
            _dataService = dataService;
            _userSession = userSession;
        }

        public bool CheckPermission(string permissionName)
        {
            return _userSession.HasPermission(permissionName);

        }

        public List<LocationListModel> GetLocationSetupList()
        {
            
            var locations = _dataService.GetCasinos();

            var result = new List<LocationListModel>();

            foreach (var location in locations)
            {
                var item = new LocationListModel()
                {
                    DgeId = location.CasId,
                    LocationId = location.LocationId,
                    LocationName = location.CasName,
                    RetailNumber = location.RetailerNumber,
                    IsDefault = location.Setasdefault,
                };

                if (location.FromTime == null)
                {
                    item.AccountStartTime = "N/A";
                }
                else
                {
                    var time = (DateTime) location.FromTime;

                    item.AccountStartTime = time.ToString("HH:mm:ss");
                }


                if (location.ToTime == null)
                {
                    item.AccountEndTime = "N/A";
                }
                else
                {
                    var time = (DateTime)location.ToTime;

                    item.AccountEndTime = time.ToString("HH:mm:ss");
                }

                result.Add(item);
            }

            return result;
        }

        protected string SanitizePhoneNumber(string phoneNumber)
        {
            if (phoneNumber == null) return "";

            var result = phoneNumber
                .Replace("(", "")
                .Replace(")", "")
                .Replace(" ", "")
                .Replace("-", "");

            return result;
        }

        public void CreateLocation(AddLocationValidationModel location)
        {
           

            var phoneNumber = SanitizePhoneNumber(location.Phone);
            var locationId = int.Parse(location.LocationId);
            var faxNumber = SanitizePhoneNumber(location.Fax);


            _dataService.InsertCasino(locationId, location.RetailerNumber, location.DgeId,
                location.LocationName,
                location.Address1, location.Address2, location.City, location.City, location.ZipCode, phoneNumber,
                faxNumber, location.SelectedTpi.TpiId, location.CashoutTimeout, location.SweepAccount,
                location.MaxBalanceAdjustment, location.PayoutAuthorizationAmount, location.SetLocationAsDefault,
                location.JackpotLockup, location.PrintPromoTickets, location.AllowTicketReprint,
                location.SummarizePlay, location.AutoDrop);

        }

        public void UpdateLocation(AddLocationValidationModel location)
        {
            var casino = _dataService.GetCasinoById(location.DgeId);

            var phoneNumber = SanitizePhoneNumber(location.Phone);
            var faxNumber = SanitizePhoneNumber(location.Fax);


            casino.CasName = location.LocationName;
            casino.Address1 = location.Address1;
            casino.Address2 = location.Address2;
            casino.City = location.City;
            casino.State = location.State;
            casino.Zip = location.ZipCode;
            casino.Phone = phoneNumber;
            casino.Fax = faxNumber;
            casino.CashoutTimeout = location.CashoutTimeout;
            casino.Setasdefault = location.SetLocationAsDefault;
            casino.ReprintTicket = location.AllowTicketReprint;
            casino.AutoDrop = location.AutoDrop;
            casino.PrintPromoTickets = location.PrintPromoTickets;
            casino.SummarizePlay = location.SummarizePlay;
            casino.JackpotLockup = location.JackpotLockup;
            casino.PayoutThreshold = location.PayoutAuthorizationAmount;
            casino.MaxBalAdjustment = location.MaxBalanceAdjustment;
            casino.SweepAcct = location.SweepAccount;
            casino.TpiId = location.SelectedTpi.TpiId;

            _dataService.UpdateCasino(casino);

        }

        public EditLocationValidationModel GetLocationEditModel(string dgeId)
        {
            var casino = _dataService.GetCasinoById(dgeId);
            var tpiList = GetTpiList();

            var model = new EditLocationValidationModel()
            {
                LocationName = casino.CasName,
                Address1 = casino.Address1,
                Address2 = casino.Address2,
                City = casino.City,
                State = casino.State,
                ZipCode = casino.Zip,
                LocationId = casino.LocationId.ToString(),
                RetailerNumber = casino.RetailerNumber,
                Phone = casino.Phone,
                Fax = casino.Fax,
                DgeId = casino.CasId,
                CashoutTimeout = casino.CashoutTimeout,
                SetLocationAsDefault = casino.Setasdefault,
                AllowTicketReprint = casino.ReprintTicket ?? false,
                AutoDrop = casino.AutoDrop,
                PrintPromoTickets = casino.PrintPromoTickets,
                SummarizePlay = casino.SummarizePlay,
                JackpotLockup = casino.JackpotLockup,
                PayoutAuthorizationAmount = casino.PayoutThreshold,
                MaxBalanceAdjustment = casino.MaxBalAdjustment,
                SweepAccount = casino.SweepAcct
            };

            model.TpiList = tpiList;
            model.SelectedTpi = tpiList.SingleOrDefault(x => x.TpiId == casino.TpiId);

            return model;

        }

        public List<Tpi> GetTpiList()
        {
            return _dataService.GetTpiList();
        }
    }
}
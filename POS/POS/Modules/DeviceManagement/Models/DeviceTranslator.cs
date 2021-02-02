using POS.Core;
using POS.Core.DeviceManager;
using System;
using System.Collections.Generic;

namespace POS.Modules.DeviceManagement.Models
{
    public static class DeviceTranslator
    {
        public static Device Translate(MachineDto machineDto, IDictionary<string, object> properties)
        {
            Device device = new Device
            {
                ActionEnabled = true
            };

            if (machineDto != null)
            {
                device.DegID = machineDto.MachineNo;
                device.CasinoMachNumber = machineDto.CasinoMachNo;
                device.IP = machineDto.IpAddress;

                device.Balance = machineDto.Balance;
                device.Description = machineDto.ModelDesc;
                device.LastPlayed = machineDto.LastActivity;
            }

            if (properties != null)
            {
                device.Connected = true;
                device.TransType = Convert.ToString(properties[nameof(Device.TransType)]);

                var machineStatus = Convert.ToString(properties[nameof(Device.MachineStatus)]);
                var voucherPrinting = Convert.ToString(properties[nameof(Device.VoucherPrinting)]);

                if(!String.IsNullOrEmpty(voucherPrinting) && voucherPrinting == "1")
                {
                    if (machineStatus == "1")
                    {
                        device.Online = true;
                    }
                    device.OnlineStatus = POSResources.UIDeviceHaltedStatus;
                }
                else if(machineStatus == "1")
                {
                    device.Online = true;
                    device.OnlineStatus = POSResources.UIDeviceOnlineStatus;
                }
                else if (machineStatus == "0")
                {
                    device.OnlineStatus = POSResources.UIDeviceOfflineStatus;
                }
                else
                {
                    device.OnlineStatus = POSResources.UIDeviceUnknownStatus;
                }
            }

            return device;
        }
    }
}

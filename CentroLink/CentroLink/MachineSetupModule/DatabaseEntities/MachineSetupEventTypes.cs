namespace CentroLink.MachineSetupModule.DatabaseEntities
{
    /// <summary>
    /// Class that holds event type id in EventType database table for machine setup events
    /// </summary>
    public enum MachineSetupEventTypes
    {
        MachineSetupAdded = 1100,
        MachineSetupGameAdded = 1101,

        MachineSetupModified = 1102,
        MachineSetupGameModified = 1103,
        MachineSetupGameRemoved = 1104,
        MachineSetupGameTitleEnableSentToTp = 1105,
        MachineSetupGameTitleEnableReceivedFromTp = 1106
    }
}
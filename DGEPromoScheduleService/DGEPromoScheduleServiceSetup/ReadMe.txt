Version 6.0.2
- Initial version


Version 7.0.0
- Added support for new Application Authorization which will not allow the application to run if database
  flag requires authorization and a hash of files does not match hash value distributed with the application.

- Made the log entry configurable when there is nothing to be done.

- Added routine to record application version info to Casino.APP_INFO at startup.


Version 7.2.0.0
- Modified so the service can send EntryTicketOn and EntryTicketOff messages to multiple TPs.
  Note that the Serverlist includes the IP address and port number separated by a colon (:) character.
  To send to more than one TP, use a comma separated list like this:

   192.168.83.3:4551,192.168.83.4:4551,192.168.83.5:4551,192.168.83.6:4551

  For a single TP enter the IP and port like this:

   192.168.168.1:4551

- Changed database connection to use mas with appropriate pwd.

- Removed dependancies on SQL Server and TP so it can run on any server.

- Replaced My.Application.Info.Version.ToString with
  System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString()

Version 7.2.5.0
- Application Authentication is now required each time the service starts, it is
  no longer data driven via the CASINO.AUTHENTICATE_APPS column value.
  
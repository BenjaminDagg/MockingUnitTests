              TransactionPortal: 7.2.2.0
                     DB version: 7.2.2
                    TPC Version: 7.0.0.0
          Bingo Blower Version : 7.0.0.0
                    Deal Import: 7.2.2.0  
                    Deal Server: 7.0.0.0
DGEPromoTicketScheduleProcessor: 7.0.0.0
                         M.A.S.: 7.2.2
               Software Changes: ALL: Modified TpiClient::HandleMessage (in Project Tpi) to update new EGM Version
                                      column values in MACH_SETUP upon receiving ReadyToPlay message.
                                      
                                      Modified TpiClient::GetNewBarcode to add the last 3 digits of the machine number
                                      to the Barcode to avoid duplicate barcode values.
                                      
                                      Modified TpiClient::HandleMessage adding support for new ProgC3Play message
                                      for Class 3 Progressive support.
                                      
               Database Changes: See ReadMe.txt in package\database folder


              TransactionPortal: 7.2.3.0
               Software Changes: ALL: Modified response elements in Messages.xml and Transactions.xml.
                                      Removed IsMicroTab element and added TabTypeID and TabsPerRoll elements.

              DC Lottery TransactionPortal: 2.0.5
               Software Changes: Modified TransactionPortal:ProjectInstaller. After installation of TranscationPortal,
                                 the configuration file will dynamically set the TransactionPortal.log path to
                                 the installation path. 

    	      Lottery TransactionPortal: 3.0.6
               Software Changes: Added support for PlayStatus Message
			         Records Machine Connection Status on Machine Connect, Disconnect and TP Shutdown
				 Additional Cleanup Functionality on TpiClient and Machine objects.
				 Added support for message VoidTabs which will deactivate tabs given parameters from the machine.
				 
			 Lottery TransactionPortal: 3.0.8
               Software Changes:   -	New feature VoucherPrintingFlag will automatically reset to false, if it is active for 
										more than the allowed timeout period. The allowed interval before timeout is controlled
										by VoucherPrintFlagTimeout (default 120 seconds) in the config file. This should 
										resolve most cases where VoucherPrintFlag gets stuck. (Case 38235)
										If after the timeout period, the flag is still reset, the machine should be restarted
										and then wait again. Functionality can be disabled by setting the 
										VoucherPrintFlagTimeoutEnabled value in the config file to 0 (default 1).
								   -	Implemented mechanism to detect duplicate transactions when the machine sends multiple requests during 
								        an unusually long network latency / hiccup. This would then cause balance adjustments on the database or machine
										lockups because the system would not pass the validation of the transaction since it was seen as duplicate. 
										The transaction portal now keeps track of the last (M,W,L,J) response sent to the EGM. 
										If the EGM sends a duplicate message matching the last valid response, the TP will simply re-send the last 
										message and not attempt to process it. This should reduce machine lockups caused by network hiccups. This change is
										persistent in the database and the TP will remember the last response for each EGM even if the service is restarted. (Case 35036)
										
			 Lottery TransactionPortal: 3.1.4
			   Version Changes: Version bumped from 3.0.8 to 3.1.4 to be consistent with the LRAS Package
               Software Changes:   -	Changed validation and voucher creation to support 6 digit location ID. Removed validation of location ID being between 1000 and 9999.
			                            CASINO_SYSTEM_PARAMETER entry: VOUCHER_PRINT_OPTIONS  Value1 will now control if the Casino Name (true) or Address is printed (false) is printed in the address field of the voucher

			Lottery TransactionPortal: 3.1.5
               Software Changes:   -	Added functionality to record ticket number when tab errors occur
                                   -    Added functionality to record door closed events
								   -    RotateTpLog.vbs will now reference Program Files instead of Program Files (x86).

			Lottery TransactionPortal: 3.1.6
               Software Changes:   -	Inserted bills will now be recorded even when there is a balance adjustment. DB change tpTransM (37562)
                                   -    Both Machine and server timestamps are now recorded for transactions and events and reported where applicable (45274).

			Lottery TransactionPortal: 3.1.7
               Software Changes:   -	Added support to handle Restricted-Credit (FreePlay) Vouchers.

			Lottery TransactionPortal: 3.1.8
               Software Changes:   -	SaveLastMachineMessage no longer throws an exception if the database has gone offline or the database request has timed out.

            Lottery TransactionPortal: 3.2.0
               Software Changes:   -	Machine Reboot requests (from TPC) are now logged in the transaction portal log. (47589)
										When a EntryTicketPrinted is sent form the machine, it will appear in the machine activity report. (48120)
										The system will now record the amount of each type of PromoEntryTicket is printed when it prints during a given schedule. (48200)

			Lottery TransactionPortal: 3.2.1
               Software Changes:   -	Added functionality lock out and activate EGMs from the central location. (49102)

			Lottery TransactionPortal: 3.2.4
               Software Changes:   -	Version Bumped to 3.2.4 from 3.2.1
										EntryTicketPrinted was not included in the messages.xml casuing TP to ignore messages. (51379)

			Lottery TransactionPortal: 3.2.5
               Software Changes:   -	Added functionality to send expiration time in months

			Lottery TransactionPortal: 3.2.8
										Version bumped to match latest version of lottery package
				Software Changes:   -	Now whenever a message is sent with invalid message it will respond with the following message: {MachineSequence},{TransType},{TimeStamp},230,Invalid message format,0 (48012)
				                    -   Added logging for when the TPC sends a Reboot command. (52759)
									-   When a progressive jackpot occurs Transaction Portal will now notify all machines that are part of the progressive and send updated progressive pools. (52529)

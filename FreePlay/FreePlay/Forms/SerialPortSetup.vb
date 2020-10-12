Imports System.IO.Ports

Public Class SerialPortSetup

   Private mCOMPort As SerialPort

   Private mCOMportName As String

   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event for the Close button.
      '--------------------------------------------------------------------------------

      ' Close this form.      
      Me.Close()

   End Sub

   Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Save button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDisplayText As String = ""

      ' Set the member variable.
      mCOMportName = cboCOMPort.SelectedItem

      If IsPrinterValid() Then
         ' Save the COM Port name to my.settings.
         My.Settings.COMPort = mCOMportName

         ' Build the display message.
         lDisplayText = String.Format("{0} is now the default serial port.", mCOMportName)

         ' Log the the message.
         Logging.Log(lDisplayText)


         ' Close the form.
         Me.Close()
     
      Else
         ' Build the display message.
         lDisplayText = String.Format("Unable to communicate to the printer on {0}. Check the connections and try again.", mCOMportName)

         ' Set the selected COM Port back to be the same as the config setting.
         cboCOMPort.SelectedItem = My.Settings.COMPort

         ' Disable the Save button.
         btnSave.Enabled = False

      End If

      ' Show the message.
      MessageBox.Show(lDisplayText, "Serial Port Save Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)

   End Sub

   Private Sub cboCOMPort_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboCOMPort.SelectedIndexChanged
      '--------------------------------------------------------------------------------
      ' If a new COMport was selected enable the Save button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      If cboCOMPort.SelectedItem <> My.Settings.COMPort Then
         ' A different COMPort was selected, enable the Save button.
         btnSave.Enabled = True
      Else
         btnSave.Enabled = False
      End If

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this Form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Initialize the DGESmartForm class
      Call InitializeBase()

      ' Populate the COMport ComboBox control.
      Call LoadCOMport()

   End Sub

   Private Sub LoadCOMport()
      '--------------------------------------------------------------------------------
      ' Populate the COMport ComboBox control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lCOMPort() As String
      Dim lDefaultCOMPort As String
      Dim lErrorText As String

      Try

         ' Get the config file setting.
         lDefaultCOMPort = My.Settings.COMPort

         ' Populate the cbCOMPort ComboBox.
         lCOMPort = GetCOMPorts()
         cboCOMPort.DataSource = lCOMPort

         ' Show the default COMport in the ComboBox.
         If IsValidCOMPort(lDefaultCOMPort) Then
            cboCOMPort.SelectedItem = lDefaultCOMPort
         Else
            cboCOMPort.SelectedIndex = -1
         End If

         ' Populate the textbox controls with the COMPort settings.
         txtBaudRate.Text = My.Settings.COMBaudRate
         txtDataBits.Text = My.Settings.COMDataBits
         txtParity.Text = My.Settings.COMParity
         txtStopBits.Text = My.Settings.COMStopBits
         txtHandshaking.Text = My.Settings.COMHandShake

         ' Disable the Save button.
         btnSave.Enabled = False

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = Me.Name & "::LoadCOMport error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Serial Port Setup Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End Try

   End Sub

   Private Function CharToInt(ByVal aChar As Char) As Integer
      '--------------------------------------------------------------------------------
      ' Convert a char to its ASCII integer value.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      Return Convert.ToInt32(aChar)

   End Function

   Private Function IsPrinterValid() As Boolean
      '--------------------------------------------------------------------------------
      ' Checks printer status and returns a PrinterStatus object with
      ' properties populated.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = False

      Dim lCommandString As String
      Dim lErrorText As String = ""
      Dim lFields() As String
      Dim lHexValue As String = "05"
      Dim lPrinterStatus As String

      Try
         ' Build the command string to get the printer status.
         lCommandString = Char.ConvertFromUtf32(Convert.ToInt32(lHexValue, 16))

         ' Send printer status command.
         If WriteToCOMPort(lCommandString) Then

            Threading.Thread.Sleep(100)

            ' Store printer status.
            lPrinterStatus = mCOMPort.ReadExisting

            ' Did we receive a status message?
            If lPrinterStatus.Length > 0 Then
               ' Split the returned printer status string into an array of field values.
               lFields = lPrinterStatus.Split("|".ToCharArray)
               ' Is the printer status in the correct format?
               If lFields(0) = "*S" AndAlso lFields(9) = "*" Then
                  ' Yes, the printer is valid.
                  lReturn = True
               End If
            End If
         End If


      Catch ex As Exception
         ' Handle the exception.  Build the error text.
         lErrorText = Me.Name & "::IsPrinterValid error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Serial Port Setup Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function WriteToCOMPort(ByVal aCommandString As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Function that sends command string to the printer.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      Dim lErrorText As String = ""
      Dim lExceptionError As String = ""
      Dim lHandShake As String = My.Settings.COMHandShake
      Dim lParity As String = My.Settings.COMParity


      Try
         If mCOMPort Is Nothing Then
            mCOMPort = New SerialPort
         End If

         ' Is the COMPort open?
         If mCOMPort.IsOpen = False Then
            ' No, So open it...
            With mCOMPort
               .PortName = mCOMportName
               .BaudRate = My.Settings.COMBaudRate

               Select Case lParity
                  Case "None"
                     .Parity = Parity.None

                  Case "Even"
                     .Parity = Parity.Even

                  Case "Odd"
                     .Parity = Parity.Odd
               End Select

               .StopBits = My.Settings.COMStopBits
               .DataBits = My.Settings.COMDataBits

               Select Case lHandShake
                  Case "XonXoff"
                     .Handshake = Handshake.XOnXOff

                  Case "None"
                     .Handshake = Handshake.None

                  Case "Hardware"
                     .Handshake = Handshake.RequestToSend
               End Select

            End With

            ' Open Serial Port connection.
            mCOMPort.Open()

         End If

         If mCOMPort.IsOpen = True Then
            ' Send printer print command.
            mCOMPort.Write(aCommandString)
         Else
            ' Unable to open the COM Port.
            lReturn = False
         End If

      Catch ex As Exception

         lReturn = False

         ' Handle the exception.  Build the error text.
         lExceptionError = Me.Name & "::WriteToCOMPort error: " & ex.Message
         lErrorText = String.Format("Unable to open {0}. Check the connection settings and try again.", mCOMportName)
         Logging.Log(String.Format("{0} : {1}", lErrorText, lExceptionError))
         MessageBox.Show(lErrorText, " Serial Port Setup Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

      ' Set the fucntion return value.
      Return lReturn

   End Function

End Class
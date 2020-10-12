Public Class DealRollScan

   ' [Privte variables]
   Private mActivationCount As Integer = 0
   Private mDealContext As Integer
   Private mDTDealBox As DataTable
   Private mDTDealQueue As DataTable

   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Cancel button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub btnImport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnImport.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Import button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDR As DataRow
      Dim lfxReturn As FunctionReturn
     
      Dim lDealNumber As Integer


      For Each lDR In mDTDealQueue.Rows
         lDealNumber = lDR.Item("DealNumber")

         ' Call function to create the eDeal.Dealxxxxx table and populate it with edf file contents...
         lfxReturn = CreateDealTable(lDealNumber)

         If lfxReturn.Success Then

         Else

         End If

      Next

   End Sub

   'Private Sub DealRollScan_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.DoubleClick

   '   Dim lZipfileName As String = "C:\Temp\ZiptestXceed.zip"
   '   Dim lFileList(2) As String

   '   lFileList(0) = "\\Herring\edeal\DealGen\DealData\11500\DGE11500.edf"
   '   lFileList(1) = "\\Herring\edeal\DealGen\DealData\11501\DGE11501.edf"
   '   lFileList(2) = "\\Herring\edeal\DealGen\DealData\11502\DGE11502.edf"

   '   Xceed.Zip.QuickZip.Zip(lZipfileName, "DGxfer@1", True, False, False, lFileList)

   'End Sub

   Private Sub Me_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler for this Form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Save current size and location for next open...
      With My.Settings
         .DRSSize = Me.Size
         .Save()
      End With

   End Sub

   Private Sub Me_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this Form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Initialize the Deal Context.
      mDealContext = 0

      ' Setup the DealQueue DataTable...
      mDTDealQueue = New DataTable("DealQueue")
      With mDTDealQueue
         .Columns.Add("FormNumber", GetType(String))
         .Columns.Add("DealNumber", GetType(Integer))
         .Columns.Add("BoxCount", GetType(Integer))
         .Columns.Add("MaxBoxCount", GetType(Integer))
         .Columns.Add("CanProcess", GetType(Boolean))
      End With

      ' Setup DealBox DataTable...
      mDTDealBox = New DataTable("DealBoxes")
      With mDTDealBox
         .Columns.Add("FormNumber", GetType(String))
         .Columns.Add("DealNumber", GetType(Integer))
         .Columns.Add("BoxNumber", GetType(Integer))
      End With

      ' Initialize the DataGridView control.
      Call InitGrid()

      ' Restore the last saved size of this form.
      Me.Size = My.Settings.DRSSize

   End Sub

   Private Sub txtScanText_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles txtScanText.KeyDown

      If e.KeyCode = Keys.Enter Then
         e.Handled = True
      End If

   End Sub

   Private Sub txtScanText_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtScanText.TextChanged
      '--------------------------------------------------------------------------------
      ' TextChanged event handler for the ScanText TextBox control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDR As DataRow
      Dim lDRA() As DataRow

      Dim lHasTerminator As Boolean
      Dim lIsNewDealContext As Boolean = False

      Dim lBoxCount As Integer
      Dim lBoxNumber As Integer
      Dim lDCount As Integer
      Dim lDealNumber As Integer
      Dim lMaxBoxCount As Integer

      Dim lEdfFile As String
      Dim lEdfFolder As String = My.Settings.edfFolderSpec
      Dim lErrorText As String = ""
      Dim lFilterExp As String
      Dim lFormNumber As String = ""
      Dim lText As String = txtScanText.Text

      Dim lFieldData() As String


      ' We expect the last scanned character to be an asterisk.
      ' Does the scanned text end with the appropriate terminator?
      lHasTerminator = lText.EndsWith("*")

      If lHasTerminator Then
         ' We expect only 1 terminator character.
         If CharacterCount(lText, "*"c) > 1 Then
            txtScanText.Clear()
            lErrorText = "Invalid number of line terminators."
         Else
            ' Store the number of field delimiters.
            lDCount = CharacterCount(lText, "+"c)
            If lDCount = 2 Then
               ' Remove the trailing asterisk.
               lText = lText.TrimEnd("*".ToCharArray)

               ' Split into fields.
               lFieldData = lText.Split("+".ToCharArray)

               ' Store field values...
               lFormNumber = lFieldData(0)

               ' Convert Deal Number field to an integer.
               If Integer.TryParse(lFieldData(1), lDealNumber) Then
                  ' Convert Box Number field to an integer.
                  If Integer.TryParse(lFieldData(2), lBoxNumber) Then
                     ' Is this a re-scan?
                     If DealBoxExists(lDealNumber, lBoxNumber) Then
                        ' Yes, so set error text.
                        lErrorText = String.Format("Deal {0} Box {1} has already been scanned.", lDealNumber, lBoxNumber)
                     ElseIf EDealLoaded(lDealNumber) Then
                        ' eDeal.Dealxxxxx already exists
                        lErrorText = String.Format("Deal {0} results are alread loaded.", lDealNumber, lBoxNumber)
                     Else
                        ' Has the Deal Number context changed?
                        lIsNewDealContext = (lDealNumber <> mDealContext)
                        If lIsNewDealContext Then
                           ' Yes, get the max box count for the form.
                           lMaxBoxCount = GetBoxCountLocal(lFormNumber)
                           If lMaxBoxCount = -1 Then lMaxBoxCount = GetBoxCountRemote(lFormNumber)

                           ' Build the fully qualified edf filename so we can make sure it exists...
                           lEdfFile = Path.Combine(lEdfFolder, String.Format("DGE{0}.edf", lDealNumber))

                           ' See if the Deal is already loaded locally.
                           If lMaxBoxCount = -1 Then
                              lErrorText = String.Format("Deal Number {0} belongs to Form {1} which could not be found.", lDealNumber, lFormNumber)
                           ElseIf DealLoadedLocally(lDealNumber) Then
                              lErrorText = String.Format("Deal Number {0} is already loaded at this location.", lDealNumber)
                           ElseIf DealLoadedRemotely(lDealNumber) Then
                              lErrorText = String.Format("Deal Number {0} is already loaded at another location.", lDealNumber)
                           ElseIf Not File.Exists(lEdfFile) Then
                              lErrorText = String.Format("Deal data file for Deal Number {0} not found.", lDealNumber)
                           Else
                              ' Reset the Deal Context value.
                              mDealContext = lDealNumber
                           End If

                        Else
                           ' Not a new Deal Context, try to get MaxBoxCount from mDTDealQueue, if that fails, call functions
                           ' that retrieve from the databases...
                           lFilterExp = String.Format("DealNumber = {0} AND FormNumber = '{0}'", lDealNumber, lFormNumber)
                           lDRA = mDTDealQueue.Select(lFilterExp)
                           If lDRA.Length > 0 Then
                              lDR = lDRA(0)
                              lMaxBoxCount = lDR.Item("MaxBoxCount")
                           Else
                              lMaxBoxCount = GetBoxCountLocal(lFormNumber)
                              If lMaxBoxCount = -1 Then lMaxBoxCount = GetBoxCountRemote(lFormNumber)
                           End If

                           ' Evaluate Deal Number and Box number...
                           If lMaxBoxCount = -1 Then
                              lErrorText = String.Format("Deal Number {0} belongs to Form {1} which could not be found.", lDealNumber, lFormNumber)
                           ElseIf lBoxNumber < 1 Then
                              lErrorText = String.Format("Invalid Box number ({0}) was scanned, Box numbers for Form {1} should be in the range of 1 to {2}.", lBoxNumber, lFormNumber, lMaxBoxCount)
                           ElseIf lBoxNumber > lMaxBoxCount Then
                              lErrorText = String.Format("Box number {0} was scanned but there should not be more than {1} boxes for Form {2}.", lBoxNumber, lMaxBoxCount, lFormNumber)
                           End If
                        End If
                     End If
                  Else
                     ' Conversion of Box Number to an integer failed...
                     lErrorText = "Box Number could not be converted to an integer value."
                  End If
               Else
                  ' Conversion of Deal Number to an integer failed...
                  lErrorText = "Deal Number could not be converted to an integer value."
               End If
            End If
         End If

         ' Did the scan result in an error?
         If lErrorText.Length > 0 Then
            ' Yes, so show the error text, clear the Scan TextBox control, and reset the DealContext to zero...
            lblScanResult.Text = lErrorText
            txtScanText.Clear()
            mDealContext = 0
         Else
            ' No scan error, does the scan have the correct terminator and do we have a Form Number?
            If lHasTerminator AndAlso lFormNumber.Length > 0 Then
               ' Yes, so add the Form/Deal/Box to the mDTDealBox DataTable...
               lDR = mDTDealBox.NewRow
               lDR.Item("FormNumber") = lFormNumber
               lDR.Item("DealNumber") = lDealNumber
               lDR.Item("BoxNumber") = lBoxNumber
               mDTDealBox.Rows.Add(lDR)
               txtScanText.Clear()
               lblScanResult.Text = ""

               ' Now we either insert a new Deal Context row or update an existing one...
               lFilterExp = String.Format("DealNumber = {0} AND FormNumber = '{1}'", lDealNumber, lFormNumber)
               lDRA = mDTDealQueue.Select(lFilterExp)

               ' Is there already a row for the current deal and form?
               If lDRA.Length = 0 Then
                  ' No, so add one.
                  lDR = mDTDealQueue.NewRow
                  lDR.Item("FormNumber") = lFormNumber
                  lDR.Item("DealNumber") = lDealNumber
                  lDR.Item("BoxCount") = 1
                  lDR.Item("MaxBoxCount") = lMaxBoxCount
                  If lMaxBoxCount = 1 Then
                     lDR.Item("CanProcess") = True
                  Else
                     lDR.Item("CanProcess") = False
                  End If
                  mDTDealQueue.Rows.Add(lDR)
               Else
                  ' Yes, so update it.
                  lDR = mDTDealQueue.Select(lFilterExp)(0)
                  lBoxCount = lDR.Item("BoxCount") + 1
                  lDR.Item("BoxCount") = lBoxCount
                  ' Get the MaxBoxCount and see if that many have been scanned...
                  lMaxBoxCount = lDR.Item("MaxBoxCount")
                  If lBoxCount = lMaxBoxCount Then
                     lDR.Item("CanProcess") = True
                     lblScanResult.Text = String.Format("Deal Number {0} is ready to process.", lDealNumber)
                     If Not btnImport.Enabled Then btnImport.Enabled = True
                  End If
               End If

            End If
         End If
      End If

   End Sub

   Private Function CreateDealTable(ByVal aDealNumber As Integer) As FunctionReturn
      '--------------------------------------------------------------------------------
      ' Creates and populates a Deal Table in the eDeal database.
      ' Returns T/F to indicate if the Deal table was successfully loaded or not.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lReturn As FunctionReturn

      Dim lDropTable As Boolean = False

      Dim lDealTableName As String = "Deal" & aDealNumber.ToString
      Dim lEdfFolder As String = My.Settings.edfFolderSpec
      Dim lFormatFile As String
      Dim lSourceFile As String
      Dim lSQL As String


      ' Assume success.
      lReturn = New FunctionReturn(True)

      Try
         ' Initialize the Process Step to a value of 1.
         lReturn.ProcessStep = 1

         ' Build the fully qualified edf filename...
         lSourceFile = Path.Combine(lEdfFolder, String.Format("DGE{0}.edf", aDealNumber))

         ' Increment the process step value. 2
         lReturn.IncrementProcessStep()

         ' Call function that creates a format file if necessary and returns the format file name.
         lFormatFile = GetFormatFile()

         ' Increment the process step value. 3
         lReturn.IncrementProcessStep()

         ' Does the edf file exist?
         If File.Exists(lSourceFile) Then
            ' Yes, so create a Deal table in the eDeal database...
            lSDA = New SqlDataAccess(gConnectEDeal, True, 600)

            ' Build the SQL statement to create the table.
            lSQL = String.Format("CREATE TABLE {0} ([TicketNumber] [int] NOT NULL , [Subset] [int] NOT NULL , [Barcode] [varchar](128) ", lDealTableName) & _
                   "COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL , [IsActive] [bit] NOT NULL ) ON [PRIMARY]"
            Try
               ' Increment the process step value. 4
               lReturn.IncrementProcessStep()

               ' Create the table...
               lSDA.ExecuteSQLNoReturn(lSQL)

            Catch ex As Exception
               ' Handle the error...
               With lReturn
                  .Success = False
                  .ErrorText = String.Format("{0}::CreateDealTable error creating Deal {1}: {2}", Me.Name, aDealNumber, ex.Message)
               End With

            End Try
           
            ' Any errors yet?
            If lReturn.Success Then
               ' No, so increment the process step (5) and add the Primary key...
               lReturn.IncrementProcessStep()

               lSQL = String.Format("ALTER TABLE {0} WITH NOCHECK ADD CONSTRAINT [PK_{0}] PRIMARY KEY  CLUSTERED ([TicketNumber]) ON [PRIMARY]", lDealTableName)
               Try
                  lSDA.ExecuteSQLNoReturn(lSQL)

               Catch ex As Exception
                  ' Handle the error...
                  lDropTable = True
                  With lReturn
                     .Success = False
                     .ErrorText = String.Format("{0}::CreateDealTable failed adding PK for Deal {1}: {2}", Me.Name, aDealNumber, ex.Message)
                  End With
               End Try
            End If

            ' Any errors yet?
            If lReturn.Success Then
               ' No, so increment the process step (6) and add the IsActive Default contraint...
               lReturn.IncrementProcessStep()

               lSQL = String.Format("ALTER TABLE {0} WITH NOCHECK ADD CONSTRAINT [DF_{0}_IsActive] DEFAULT (1) FOR [IsActive]", lDealTableName)
               Try
                  lSDA.ExecuteSQLNoReturn(lSQL)

               Catch ex As Exception
                  ' Handle the error...
                  lDropTable = True
                  With lReturn
                     .Success = False
                     .ErrorText = String.Format("{0}::CreateDealTable::Add IsActive Default failed. Deal {1}: {2}", Me.Name, aDealNumber, ex.Message)
                  End With

               End Try
            End If

            ' Insert the data from the edf file.
            If lReturn.Success Then
               ' Increment the process step value. 7
               lReturn.IncrementProcessStep()

               ' Build insert statement.
               lSQL = String.Format("BULK INSERT [{0}] FROM '{1}' WITH (FORMATFILE = '{2}')", _
                      lDealTableName, lSourceFile, lFormatFile)

               Try
                  lSDA.ExecuteSQLNoReturn(lSQL)

               Catch ex As Exception
                  ' Handle the error...
                  lDropTable = True
                  With lReturn
                     .Success = False
                     .ErrorText = String.Format("{0}::LoadDealFiles::Bulk Insert failed. Deal {1}: {2}", Me.Name, aDealNumber, ex.Message)
                  End With
               End Try
            End If
         Else
            ' Source edf file was not found...
            With lReturn
               .Success = False
               .ErrorText = String.Format("{0}::CreateDealTable error: Source file '{1}' was not found.", Me.Name, lSourceFile)
            End With
         End If

      Catch ex As Exception
         ' Handle the exception...
         With lReturn
            .Success = False
            .ErrorText = String.Format("{0}::CreateDealTable error: {1}", Me.Name, ex.Message)
         End With

      End Try

      ' If the table was created but not successfully populated, drop the table.
      If lDropTable Then
         Try
            lSQL = String.Format("DROP TABLE {0}", lDealTableName)
            lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the exception...
            lReturn.WarningText = String.Format("Failed to drop eDeal table {0}.", lDealTableName)

         End Try
      End If

      ' Cleanup
      If lSDA IsNot Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If


      ' Set the function return value.
      Return lReturn

   End Function

   Private Function DealAvailable(ByVal aDealNumber As Integer, ByVal aFormNumber As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Returns T/F to indicate if the specified Deal Number is available to retrieve
      ' from the central repository of Deals.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...


   End Function

   Private Function DealBoxExists(ByVal aDealNumber As Integer, ByVal aBoxNumber As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Returns T/F to indicate if the specified Deal Number is already loaded locally.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDRA() As DataRow
      Dim lReturn As Boolean = True
      Dim lErrorText As String = ""

      Try
         ' Select matching Deal and Box row.
         lDRA = mDTDealBox.Select(String.Format("DealNumber = {0} AND BoxNumber = {1}", aDealNumber, aBoxNumber))

         ' Set value to be returned.
         lReturn = (lDRA.Length > 0)

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = Me.Name & "::DealBoxExists error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Scan Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function DealLoadedLocally(ByVal aDealNumber As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Returns T/F to indicate if the specified Deal Number is already loaded locally.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDT As DataTable
      Dim lReturn As Boolean = True
      Dim lCount As Integer
      Dim lErrorText As String = ""


      ' Build SQL statement to retrieve a count of existing Deals in DEAL_SETUP and retrieve the count...
      lDT = CreateDT(String.Format("SELECT COUNT(*) AS DSCount FROM DEAL_SETUP WHERE DEAL_NO = {0}", aDealNumber), lErrorText)

      ' lDT will be Nothing if the retrieval failed.
      If lDT IsNot Nothing Then
         ' Retrieval succeeded, get the count and use it to set the function return value.
         lCount = lDT.Rows(0).Item(0)
         lReturn = (lCount > 0)
      Else
         ' Failed to perform local deal check.
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function EDealLoaded(ByVal aDealNumber As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Returns T/F to indicate if the specified Deal Number is already loaded locally.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing

      Dim lReturn As Boolean = True

      Dim lCount As Integer = 1

      Dim lErrorText As String
      Dim lSQL As String

      Try
         lSDA = New SqlDataAccess(gConnectEDeal, True, 60)
         lSQL = String.Format("SELECT COUNT(*) FROM sys.tables WHERE [name] = 'Deal{0}'", aDealNumber)
         lDT = lSDA.CreateDataTable(lSQL)
         lCount = lDT.Rows(0).Item(0)
         lReturn = (lCount > 0)

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = Me.Name & "::EDealLoaded error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Scan Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function DealLoadedRemotely(ByVal aDealNumber As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Returns T/F to indicate if the specified Deal Number is already loaded at
      ' another location.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDT As DataTable
      Dim lReturn As Boolean = True
      Dim lCount As Integer
      Dim lErrorText As String = ""
      Dim lSQL As String


      ' Build the SQL SELECT statement...
      lSQL = String.Format("SELECT COUNT(*) AS CentralDealCount FROM {0}.dbo.DEAL_SETUP WHERE DEAL_NO = {1}", My.Settings.CentralLinkName, aDealNumber)

      ' Retrieve the count...
      lDT = CreateDT(lSQL, lErrorText)

      ' lDT will be Nothing if the retrieval failed.
      If lDT IsNot Nothing Then
         ' Retrieval succeeded, get the count and use it to set the function return value.
         lCount = lDT.Rows(0).Item(0)
         lReturn = (lCount > 0)
      Else
         ' Failed to perform local deal check.
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function GetBoxCountLocal(ByVal aFormNumber As String) As Integer
      '--------------------------------------------------------------------------------
      ' Returns the number of boxes for Deals of the specified Form Number.
      ' If the Form is not loaded locally, it returns -1.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDT As DataTable
      Dim lRollCount As Integer
      Dim lReturn As Integer = -1
      Dim lErrorText As String = ""


      Try
         ' Retrieve the number of Rolls per Deal for the specified Form Number...
         lDT = CreateDT(String.Format("SELECT NUMB_ROLLS FROM CASINO_FORMS WHERE FORM_NUMB = '{0}'", aFormNumber), lErrorText)

         ' Did CreateDT succeed?
         If lDT IsNot Nothing Then
            ' Yes, was data returned?
            If lDT.Rows.Count > 0 Then
               ' Yes, so get the roll count and calculate the Box count as the number of rolls divided by 2...
               lRollCount = lDT.Rows(0).Item("NUMB_ROLLS")
               lReturn = lRollCount \ 2
            End If
         Else
            ' Build the error message.
            lErrorText = Me.Name & "::GetBoxCountLocal error: " & lErrorText
         End If

      Catch ex As Exception
         ' Handle the exception
         lReturn = -1

         ' Build the error message.
         lErrorText = Me.Name & "::GetBoxCountLocal error: " & ex.Message

      End Try

      ' Were there errors?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show the error.
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function GetBoxCountRemote(ByVal aFormNumber As String) As Integer
      '--------------------------------------------------------------------------------
      ' Returns the number of boxes for Deals of the specified Form Number.
      ' If the Form is not found on the central system, it returns -1.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDT As DataTable
      Dim lRollCount As Integer
      Dim lReturn As Integer = -1
      Dim lErrorText As String = ""
      Dim lSQL As String


      Try
         ' Retrieve the number of Rolls per Deal for the specified Form Number...
         lSQL = String.Format("SELECT NUMB_ROLLS FROM {0}.dbo.CASINO_FORMS WHERE FORM_NUMB = '{1}'", My.Settings.CentralLinkName, aFormNumber)
         lDT = CreateDT(lSQL, lErrorText)

         ' Did CreateDT succeed?
         If lDT IsNot Nothing Then
            ' Yes, was data returned?
            If lDT.Rows.Count > 0 Then
               ' Yes, so get the roll count and calculate the Box count as the number of rolls divided by 2...
               lRollCount = lDT.Rows(0).Item("NUMB_ROLLS")
               lReturn = lRollCount \ 2
            End If
         Else
            ' Build the error message.
            lErrorText = Me.Name & "::GetBoxCountLocal error: " & lErrorText
         End If

      Catch ex As Exception
         ' Handle the exception
         lReturn = -1

         ' Build the error message.
         lErrorText = Me.Name & "::GetBoxCountLocal error: " & ex.Message

      End Try

      ' Were there errors?
      If lErrorText.Length > 0 Then
         ' Yes, so log and show the error.
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Sub InitGrid()
      '--------------------------------------------------------------------------------
      ' Initialize the Grid.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDgvColumn As DataGridViewColumn

      With dgvDealBoxes
         .BackgroundColor = Color.White
         .ReadOnly = True
         .RowHeadersWidth = 20
         .BackColor = Color.White
         .ForeColor = Color.MidnightBlue
         .DataSource = mDTDealBox
      End With

      For Each lDgvColumn In dgvDealBoxes.Columns
         Select Case lDgvColumn.Name
            Case "FormNumber"
               With lDgvColumn
                  .DisplayIndex = 0
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderText = "Form Nbr"
               End With

            Case "DealNumber"
               With lDgvColumn
                  .DisplayIndex = 1
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Deal Nbr"
               End With

            Case "BoxNumber"
               With lDgvColumn
                  .DisplayIndex = 2
                  .Width = 80
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Box Nbr"
               End With

            Case Else
               ' Hide any columns not handled above.
               lDgvColumn.Visible = False

         End Select
      Next

   End Sub

End Class
Imports System.Drawing.Printing

' Purpose : To print the contents of "DataGrid1"

Public Class PrintHandler

#Region " Declarations "

   Const DATE_FORMAT_MDY = "MM/dd/yyyy"

   ' Count of columns printed per page.
   Private myLastColPrinted As Integer = -1

   ' Flag indicating if number of columns exceedes
   ' width of page.
   Private myPageWidthExceeded As Boolean = False

   'Page counter.
   Private myPageNo As Integer = 0

   'Count of lines printed so far.
   Private myLinesPrintedSoFar As Integer = 0

   'Count of dataset lines processed so far.
   Private myRowsProcessedSoFar As Integer = -1

   'Number of DataSet rows to print.
   Private myDataSetRows As Integer = 0

   'Number of DataSet columns to print.
   Private myNumberOfColumns As Integer = 0

   'Index of the table within the DataSet to print.
   Private myTableIndex As Integer = 0

   'Input DataSet whose rows will be printed. If the dataset has a
   'filter applied, the remaining rows are stored in an array. The 
   'array's contents are then printed. 
   Private myDataSetToPrint As DataSet
   Private myFilteredRows As DataRow()

   'Flag indicating dataset is filtered.
   Private myDatasetFiltered As Boolean = False

   'Title to print on the report.
   Private myReportTitle As String = ""

   'If the number of lines to print exceeds this
   ' value a confirmation dialog is displayed.
   ' A value of 0 means "do not prompt".
   Private myLineThreshold As Integer = 0

   'Brush to use for printing.
   Private myDrawBrush As New SolidBrush(Color.Black)

   'Font to use for printing. This is different than the
   ' font displayed in the grid but looks better when printed.
   'The grid font is "Microsoft Sans Serif", 8.25
   Private myDrawFont As New Font("Courier New", 8)

   'Font to use to print the report title.
   Private myDrawFontBold As New Font("Microsoft Sans Serif", 10, FontStyle.Bold)

   'Flag indicating if the PageSetupDialog was shown.
   Private myPageSetUp As Boolean = False

   'PrintDocument to process. Declared WithEvents so
   'Windows can fire its PrintPage event when its
   'Print method is invoked.
   Private WithEvents myDocumentToPrint As PrintDocument

#End Region

#Region " Constructor Code "

   Friend Sub New()

      myDocumentToPrint = New PrintDocument

   End Sub

#End Region

#Region " Class Properties "

   Public Property NumberOfColumns() As Integer

      '
      ' Number of dataset columns to print.
      '

      Get
         NumberOfColumns = myNumberOfColumns
      End Get

      Set(ByVal theValue As Integer)
         myNumberOfColumns = theValue
      End Set

   End Property

   Public WriteOnly Property ReportTitle() As String

      '
      ' Allows setting the title to be used for the report.
      '
      Set(ByVal theValue As String)
         myReportTitle = theValue
      End Set

   End Property

   Public WriteOnly Property LineThreshold() As Integer

      '
      ' If the number of lines to print exceeds this
      ' value a confirmation prompt is displayed.
      '
      Set(ByVal theValue As Integer)
         myLineThreshold = theValue
      End Set

   End Property

   Public WriteOnly Property TableIndex() As Integer

      '
      ' Index of the table within the DataSet to print.
      '

      Set(ByVal theValue As Integer)
         myTableIndex = theValue
      End Set

   End Property

   Public WriteOnly Property DataSetToPrint() As DataSet

      '
      ' Sets the dataset whose content is to be printed.
      '

      Set(ByVal theValue As DataSet)
         Try
            myDataSetToPrint = theValue
            '
            ' Get the total number of DataSet rows to print.
            '
            Dim aFilter As String = myDataSetToPrint.Tables(myTableIndex).DefaultView.RowFilter.Trim

            If aFilter = "" Then
               myDatasetFiltered = False
               myDataSetRows = myDataSetToPrint.Tables(myTableIndex).Rows.Count - 1
            Else
               myDatasetFiltered = True
               myDataSetRows = myDataSetToPrint.Tables(myTableIndex).DefaultView.Count - 1
               myFilteredRows = myDataSetToPrint.Tables(myTableIndex).Select(aFilter)
            End If

         Catch e As Exception
            Throw New Exception("Error initializing the print data.", e)
         End Try
      End Set

   End Property

#End Region

#Region " Public Method to Setup Print Page "

   Public Sub PageSetupDialog(ByVal theShowDialogFlag As Boolean)

      '
      ' Display the Page Setup Dialog.
      '

      Try
         '
         ' Set the PageSetupDialog's print document to 
         ' the current document.
         '
         Dim aPS As New PageSetupDialog
         aPS.Document = myDocumentToPrint

         '
         ' On the first call to the print dialog
         ' initialize the document's properties.
         '
         If Not myPageSetUp Then
            With aPS.Document.DefaultPageSettings
               .Margins.Top = 50
               .Margins.Left = 50
               .Margins.Right = 50
               .Margins.Bottom = 50
               .Landscape = True
            End With
         End If

         '
         ' Display the PageSetupDialog.
         '
         If theShowDialogFlag Then aPS.ShowDialog()
         myPageSetUp = True

      Catch e As Exception
         Throw New Exception("Error displaying Page Setup dialog.", e)
      End Try

   End Sub

#End Region

#Region " Public Print/Preview Methods "

   Public Sub PrintPreview()

      '
      ' Display a page Preview window showing what the 
      ' printed dataset will look like.
      '

      Try
         '
         ' Get out if no dataset was passed in.
         '
         If myDataSetToPrint Is Nothing Then Exit Sub
         If myTableIndex > myDataSetToPrint.Tables.Count Then Exit Sub
         If myDataSetToPrint.Tables(myTableIndex).Rows.Count = 0 Then Exit Sub

         '
         ' Reset counters.
         '
         myPageNo = 0
         myLinesPrintedSoFar = 0


         '
         ' Inintialize the page settings.
         '
         If Not myPageSetUp Then
            PageSetupDialog(False)
         End If


         '
         ' Show the Print Preview Dialog.
         '
         Dim aPrevDialog As New PrintPreviewDialog

         With aPrevDialog
            .Document = myDocumentToPrint
            .Size = New System.Drawing.Size(600, 400)
            .Top = (Screen.PrimaryScreen.Bounds.Height - 600) \ 2
            .Left = (Screen.PrimaryScreen.Bounds.Width - 400) \ 2

            .ShowDialog()
         End With

      Catch e As Exception
         Throw New Exception("Unable to preview report.", e)
      End Try

   End Sub

   Public Sub Print()

      '
      ' Print the contents of a dataset.
      '

      Try
         '
         ' Get out if no dataset was passed in.
         '
         If myDataSetToPrint Is Nothing Then Exit Sub
         If myTableIndex > myDataSetToPrint.Tables.Count Then Exit Sub
         If myDataSetToPrint.Tables(myTableIndex).Rows.Count = 0 Then Exit Sub


         '
         ' Confirm printing large amounts of data.
         '
         If myLineThreshold > 0 Then
            Dim aLines As Integer = myDataSetToPrint.Tables(myTableIndex).Rows.Count

            If aLines > myLineThreshold And myLineThreshold <> 0 Then
               If MessageBox.Show( _
                       "There are approximately " & aLines.ToString & " lines to print." & _
                        gCrLf & gCrLf & _
                       "Print anyway?", "Print Confirmation", _
                       MessageBoxButtons.YesNo, MessageBoxIcon.Question, _
                       MessageBoxDefaultButton.Button2) = DialogResult.No Then

                  Exit Sub
               End If
            End If
         End If

         ' Reset counters.
         myPageNo = 0
         myLinesPrintedSoFar = 0

         ' Inintialize the PageSetup.
         If Not myPageSetUp Then PageSetupDialog(False)

         ' Print the document.
         myDocumentToPrint.Print()

      Catch e As Exception
         Throw New Exception("Unable to print report.", e)

      End Try

   End Sub

#End Region

#Region " PrintPage Callback event "

   Private Sub PrintDataSet(ByVal Sender As Object, ByVal ev As PrintPageEventArgs) Handles myDocumentToPrint.PrintPage
      '--------------------------------------------------------------------------------
      ' This call-back procedure is called by the PrintDocument's PrintPage 
      ' event for each page to be printed (until ev.HasMorePages = False.
      '--------------------------------------------------------------------------------

      On Error GoTo ErrorHandler

      Dim aValue As String
      Dim aLeftMargin As Single = ev.MarginBounds.Left
      Dim aTextHeight As Single = myDrawFont.GetHeight(ev.Graphics)
      Dim aXPos As Single = aLeftMargin
      Dim aYPos As Single = ev.MarginBounds.Top
      Dim aColIndex As Integer = 0
      Dim aRowIndex As Integer
      Dim aLinesFilled As Integer
      Dim aLinesPerPage As Integer = 0
      Dim aCharactersFitted As Integer
      Dim aLinesPrintedThisPage As Integer = 0
      Dim aColsToPrint As Integer
      Dim aLinesPrintedSoFar As Integer = myLinesPrintedSoFar
      Dim aFirstColToPrint As Integer
      Dim aRow As DataRow
      Dim aCol As DataColumn
      Dim aStringSize As New SizeF
      Dim aLayoutSize As New SizeF
      Dim aNewStringFormat As New StringFormat
      Dim aHeaderObj As New System.Text.StringBuilder
      Dim aSeparatorObj As New System.Text.StringBuilder ' --apm change
      Dim aPrintIt As Boolean


      ' Set the number of dataset columns to print. Use the
      ' "NumberOfColumns" property value if set otherwise 
      ' print all columns.
      With myDataSetToPrint.Tables(myTableIndex).Columns
         If myNumberOfColumns = 0 Then
            aColsToPrint = .Count - 1
         Else
            If myNumberOfColumns > .Count Then
               aColsToPrint = .Count - 1
            Else
               aColsToPrint = myNumberOfColumns - 1
            End If
         End If
      End With

      ' Calculate the number of lines per page.
      aLinesPerPage = Int(ev.MarginBounds.Height / aTextHeight)
      aLayoutSize.Height = aTextHeight
      aNewStringFormat.FormatFlags = StringFormatFlags.NoWrap
      myPageNo += 1

      ' Create a header line.
      If myReportTitle = "" Then
         myReportTitle = myDataSetToPrint.Tables(myTableIndex).TableName
      End If

      With aHeaderObj
         .Append("Date: ")
         .Append(Format(Today, DATE_FORMAT_MDY))
         .Append("      " & myReportTitle & "      ")
         .Append("Page: ")
         .Append(myPageNo.ToString)
      End With

      ' See how wide it is.
      aStringSize = ev.Graphics.MeasureString(aHeaderObj.ToString, myDrawFontBold)
      aLayoutSize.Width = ev.MarginBounds.Width - 20

      ' Add spaces until it is centered.
      ' $5.00 if you can do this more efficiently and accurately.
      Do Until aStringSize.Width >= aLayoutSize.Width
         aHeaderObj.Insert(17, " ", 1)
         aHeaderObj.Insert(aHeaderObj.Length - 10, " ", 1)
         aStringSize = ev.Graphics.MeasureString(aHeaderObj.ToString, myDrawFontBold)
      Loop

      ' Print the header.
      ev.Graphics.DrawString(aHeaderObj.ToString, myDrawFontBold, myDrawBrush, aXPos, aYPos)

      ' Build the separator line by appending "-". --apm change
      aYPos += 1 * aTextHeight
      aStringSize = ev.Graphics.MeasureString("-", myDrawFontBold)
      aLayoutSize.Width = ev.MarginBounds.Width - 20
      Do Until aStringSize.Width >= aLayoutSize.Width
         aSeparatorObj.Append("-")
         aStringSize = ev.Graphics.MeasureString(aSeparatorObj.ToString, myDrawFontBold)
      Loop

      ' Print the separator line. --apm change
      ev.Graphics.DrawString(aSeparatorObj.ToString, myDrawFontBold, myDrawBrush, aXPos, aYPos)

      ' Skip a line and increment the line count.
      aYPos += 2 * aTextHeight
      aLinesPrintedThisPage += 3


      ' Print the column names.
      myPageWidthExceeded = False
      aFirstColToPrint = myLastColPrinted + 1

      For aColIndex = aFirstColToPrint To aColsToPrint
         aCol = myDataSetToPrint.Tables(myTableIndex).Columns(aColIndex)
         ' See how many characters to print based on the PrintWidth 
         ' extended attribute. If this was not set when the dataset 
         ' was built then use the width of the column's Caption. If 
         ' it was set to a value of -1 then the column is not visible 
         ' in the grid in which case we do not want to print it.
         '
         If aCol.ExtendedProperties.Item("PrintWidth") Is Nothing Then
            aPrintIt = True
            aStringSize = ev.Graphics.MeasureString(aCol.Caption, myDrawFont)
            aLayoutSize.Width = aStringSize.Width
         Else
            aPrintIt = (aCol.ExtendedProperties.Item("PrintWidth") > 0)
            aLayoutSize.Width = aCol.ExtendedProperties.Item("PrintWidth")
         End If
         aStringSize = ev.Graphics.MeasureString(aCol.Caption, myDrawFont, _
                       aLayoutSize, aNewStringFormat, aCharactersFitted, aLinesFilled)

         ' Conditionally print the column header. If the Caption 
         ' property was not set it defaults to the actual column name.
         If aPrintIt Then
            ' See if the column can fit on the page.
            If (aXPos + aLayoutSize.Width) <= ev.MarginBounds.Right Then
               ev.Graphics.DrawString(Left(aCol.Caption, aCharactersFitted), myDrawFont, myDrawBrush, aXPos, aYPos)
               aXPos += aLayoutSize.Width

               myLastColPrinted = aColIndex
            Else
               ' Column exceeds page with.
               myPageWidthExceeded = True
               Exit For
            End If
         Else
            myLastColPrinted = aColIndex
         End If
      Next

      ' Increment the number of lines processed.
      aLinesPrintedThisPage += 1

      ' Print the separator line. --apm change
      aXPos = aLeftMargin
      aYPos += 1 * aTextHeight
      ev.Graphics.DrawString(aSeparatorObj.ToString, myDrawFont, myDrawBrush, aXPos, aYPos)

      ' Increment the number of lines processed.
      aLinesPrintedThisPage += 1

      ' Print the rows in the dataset/array. If this dataset
      ' was displayed in a datagrid the order the rows are printed
      ' may not match their display order in the grid because the 
      ' grid and dataset are not kept in sync (and as far as I can
      ' tell you cannot use the CurrenyManager to map back to the 
      ' datagrid - although you can map from grid to dataset).
      ' Column order may also differ.

      For aRowIndex = myLinesPrintedSoFar To myDataSetRows
         If myDatasetFiltered Then
            aRow = myFilteredRows(aRowIndex)
         Else
            aRow = myDataSetToPrint.Tables(myTableIndex).Rows.Item(aRowIndex)
         End If

         ' Track the number of rows processed.
         myRowsProcessedSoFar += 1

         ' Skip deleted rows. No special handling required for 
         ' new or changed rows. By default the row value contains
         ' the "current" value which is the "New" or "Changed" value.
         If aRow.RowState <> DataRowState.Deleted Then
            aXPos = aLeftMargin
            aYPos += aTextHeight

            For aColIndex = aFirstColToPrint To myLastColPrinted
               '
               ' Get the value of the column.
               '
               aValue = aRow(aColIndex).ToString

               ' See how many character's of the column's value will
               ' fit in the width specified for the column.
               aCol = myDataSetToPrint.Tables(myTableIndex).Columns(aColIndex)

               If aCol.ExtendedProperties.Item("PrintWidth") Is Nothing Then
                  aPrintIt = True
                  aStringSize = ev.Graphics.MeasureString(aCol.Caption, myDrawFont)
                  aLayoutSize.Width = aStringSize.Width
               Else
                  aPrintIt = (aCol.ExtendedProperties.Item("PrintWidth") > 0)
                  aLayoutSize.Width = aCol.ExtendedProperties.Item("PrintWidth")
               End If
               aStringSize = ev.Graphics.MeasureString(aValue, myDrawFont, aLayoutSize, aNewStringFormat, aCharactersFitted, aLinesFilled)

               ' Trim the column's value to the specified width.
               If aPrintIt Then
                  If aValue.Length > aCharactersFitted Then
                     aValue = Left(aValue, aCharactersFitted)
                  End If

                  ' Apply additional formatting based on the column's data type.
                  '
                  'Select Case Row(intColIndex).GetType.Name.ToUpper
                  '    Case "STRING"
                  '    Case "INT32"
                  '    Case "DECIMAL"
                  '    Case "DATETIME"
                  'End Select

                  ' Print the column's value. 
                  ev.Graphics.DrawString(aValue, myDrawFont, myDrawBrush, aXPos, aYPos)
                  aXPos += aLayoutSize.Width
               End If
            Next

            ' Print the separator line. --apm change
            aYPos += 1 * aTextHeight
            ev.Graphics.DrawString(aSeparatorObj.ToString, myDrawFont, myDrawBrush, aLeftMargin, aYPos)

            ' Track the number of lines printed.
            aLinesPrintedThisPage += 2 ' --apm change from 1 to 2
            myLinesPrintedSoFar += 1
            If aLinesPrintedThisPage > aLinesPerPage Then Exit For
            If myLinesPrintedSoFar > myDataSetRows Then Exit For
         End If

         ' If we processed the entire dataset, we are done.
         If myRowsProcessedSoFar > myDataSetRows Then Exit For
      Next

      ' If the number of columns to print exceeds the
      ' page with, reset the number of lines printed so
      ' far for the remainder of the columns print the
      ' data for the same set of rows.
      If myPageWidthExceeded Then
         myLinesPrintedSoFar = aLinesPrintedSoFar
      End If

      ' If all columns have been printed, reset
      ' the starting column to print.
      If myLastColPrinted >= aColsToPrint Then
         myLastColPrinted = -1
      End If

      ' If there are more lines to be printed, print another page.
      ' Setting HasMorePages True causes this procedure to be re-invoked.
      If myLinesPrintedSoFar <= myDataSetRows And myRowsProcessedSoFar < myDataSetRows Then
         ev.HasMorePages = True
      Else
         ev.HasMorePages = False
         myPageNo = 0
         myLinesPrintedSoFar = 0
         myRowsProcessedSoFar = -1
         myLastColPrinted = -1
      End If

      aCol = Nothing
      aRow = Nothing
      aHeaderObj = Nothing
      Exit Sub


ErrorHandler:
      Throw New Exception("Error formatting report output.", Err.GetException)
   End Sub

#End Region

End Class


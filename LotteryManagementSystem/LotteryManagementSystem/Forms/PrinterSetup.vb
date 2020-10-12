Imports System.Drawing.Printing

Public Class PrinterSetup

   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close button.
      '--------------------------------------------------------------------------------

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub Me_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lPrinterName As String

      ' Show the current printer setup.
      cbReportPrinter.Text = My.Settings.ReportPrinter

      ' If Payouts are not allowed hide controls.
      If gAllowPayouts = False Then
         cbReceiptPrinter.Visible = False
         lblReceiptPrinter.Visible = False
      Else
         cbReceiptPrinter.Text = My.Settings.ReceiptPrinter
      End If


      ' Retrieve a list of installed printers...
      For Each lPrinterName In PrinterSettings.InstalledPrinters
         cbReportPrinter.Items.Add(lPrinterName)
         cbReceiptPrinter.Items.Add(lPrinterName)
      Next

   End Sub

   Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Save button.
      '--------------------------------------------------------------------------------

      ' Save the current printer selection...
      With My.Settings
         .ReportPrinter = Me.cbReportPrinter.Text
         .ReceiptPrinter = Me.cbReceiptPrinter.Text
         .Save()
      End With

      ' Display success message.
      MessageBox.Show("Printer Setup Saved.", "Printer Setup Status", MessageBoxButtons.OK, MessageBoxIcon.Information)

      ' Close this form.
      Me.Close()

   End Sub

End Class
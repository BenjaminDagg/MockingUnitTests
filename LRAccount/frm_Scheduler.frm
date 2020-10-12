VERSION 5.00
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomct2.ocx"
Begin VB.Form frm_Scheduler 
   Caption         =   "Set Accounting Period"
   ClientHeight    =   2490
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   5460
   ControlBox      =   0   'False
   Icon            =   "frm_Scheduler.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   2490
   ScaleWidth      =   5460
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close"
      Height          =   375
      Left            =   3105
      TabIndex        =   18
      Top             =   1980
      Width           =   960
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "&Save"
      Height          =   375
      Left            =   1395
      TabIndex        =   17
      Top             =   1980
      Width           =   960
   End
   Begin VB.Frame frProgressiveTracking 
      Caption         =   "Progressive Tracking Process"
      Height          =   1410
      Left            =   360
      TabIndex        =   12
      Top             =   4680
      Visible         =   0   'False
      Width           =   4740
      Begin VB.CheckBox cbProgTrackEnabled 
         Caption         =   "Process Enabled"
         CausesValidation=   0   'False
         Enabled         =   0   'False
         Height          =   195
         Left            =   225
         TabIndex        =   13
         Top             =   405
         Width           =   1545
      End
      Begin VB.TextBox txtProgTrackTime 
         CausesValidation=   0   'False
         Height          =   285
         Left            =   675
         MaxLength       =   2
         TabIndex        =   15
         ToolTipText     =   "Enter the number of minutes (1 to 10) before the Starting Time when the Progressive Tracking process will be run."
         Top             =   810
         Width           =   375
      End
      Begin VB.Label lblCAB 
         Alignment       =   1  'Right Justify
         Caption         =   "Run"
         Height          =   195
         Index           =   4
         Left            =   180
         TabIndex        =   14
         Top             =   855
         Width           =   405
      End
      Begin VB.Label lblCAB 
         Caption         =   "minute(s) before Accounting Period Start Time"
         Height          =   195
         Index           =   3
         Left            =   1125
         TabIndex        =   16
         Top             =   855
         Width           =   3285
      End
   End
   Begin VB.Frame frCabProcess 
      Caption         =   "Clear Account Balances Process"
      Height          =   2085
      Left            =   360
      TabIndex        =   5
      Top             =   2520
      Visible         =   0   'False
      Width           =   4740
      Begin VB.TextBox txtCabAmount 
         CausesValidation=   0   'False
         Height          =   285
         Left            =   2385
         TabIndex        =   8
         ToolTipText     =   "Enter the threshold value for the Clear Account Balances process.  Values at or below this value will be cleared."
         Top             =   900
         Width           =   825
      End
      Begin VB.TextBox txtCabTime 
         CausesValidation=   0   'False
         Height          =   285
         Left            =   675
         MaxLength       =   2
         TabIndex        =   10
         ToolTipText     =   "Enter the number of minutes (1 to 10) before the Starting Time when the Clear Account Balances process will be run."
         Top             =   1305
         Width           =   375
      End
      Begin VB.CheckBox cbCabEnabled 
         Caption         =   "Process Enabled"
         CausesValidation=   0   'False
         Height          =   195
         Left            =   225
         TabIndex        =   6
         Top             =   585
         Width           =   1545
      End
      Begin VB.Label lblCAB 
         Caption         =   "minute(s) before Accounting Period Start Time"
         Height          =   195
         Index           =   2
         Left            =   1125
         TabIndex        =   11
         Top             =   1350
         Width           =   3285
      End
      Begin VB.Label lblCAB 
         Alignment       =   1  'Right Justify
         Caption         =   "Run"
         Height          =   195
         Index           =   1
         Left            =   180
         TabIndex        =   9
         Top             =   1350
         Width           =   405
      End
      Begin VB.Label lblCAB 
         Alignment       =   1  'Right Justify
         Caption         =   "Clear Balances at or below $:"
         Height          =   195
         Index           =   0
         Left            =   240
         TabIndex        =   7
         Top             =   945
         Width           =   2115
      End
   End
   Begin VB.Frame frAccountingPeriod 
      Caption         =   "Accounting Period"
      Height          =   1410
      Left            =   360
      TabIndex        =   0
      Top             =   300
      Width           =   4740
      Begin MSComCtl2.DTPicker DtpStartTime 
         CausesValidation=   0   'False
         Height          =   330
         Left            =   2025
         TabIndex        =   2
         ToolTipText     =   "Enter or select the Accounting Period Starting Time."
         Top             =   360
         Width           =   1545
         _ExtentX        =   2725
         _ExtentY        =   582
         _Version        =   393216
         Format          =   106954754
         CurrentDate     =   37568
      End
      Begin MSComCtl2.DTPicker DtpEndTime 
         CausesValidation=   0   'False
         Height          =   330
         Left            =   2025
         TabIndex        =   4
         ToolTipText     =   "Enter or select the Accounting Period Ending Time."
         Top             =   780
         Width           =   1545
         _ExtentX        =   2725
         _ExtentY        =   582
         _Version        =   393216
         Format          =   106954754
         CurrentDate     =   37568
      End
      Begin VB.Label lblEndTime 
         Alignment       =   1  'Right Justify
         Caption         =   "Ending Time:"
         Height          =   195
         Left            =   720
         TabIndex        =   3
         Top             =   855
         Width           =   1230
      End
      Begin VB.Label lblStartTime 
         Alignment       =   1  'Right Justify
         Caption         =   "Starting Time:"
         Height          =   195
         Left            =   720
         TabIndex        =   1
         Top             =   450
         Width           =   1230
      End
   End
End
Attribute VB_Name = "frm_Scheduler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' [Form level member variables]
Private msInitValue              As String
Private msTimeStartInitialValue  As String
Private msTimeEndInitialValue    As String

Private Sub cmdClose_Click()
'--------------------------------------------------------------------------------
' Click event for the Close button.
'--------------------------------------------------------------------------------

   Unload Me

End Sub

Private Sub cmdSave_Click()
'--------------------------------------------------------------------------------
' Click event for the Save button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsErrText     As String
Dim lsUserMsg     As String
Dim lsValue       As String

Dim ldStartTime   As Date
Dim ldEndTime     As Date

   lsValue = CStr(DtpStartTime.value) & CStr(DtpEndTime.value) & CStr(cbCabEnabled.value) & _
      CStr(Val(txtCabAmount.Text)) & CStr(Val(txtCabTime.Text)) & CStr(Val(txtProgTrackTime.Text))

   If lsValue = msInitValue Then
      MsgBox "No values have changed.", vbExclamation, "Save Status"
      Exit Sub
   End If

   ' Check start and end times.
   ldStartTime = DtpStartTime.value
   ldEndTime = DtpEndTime.value

   ' Check that start and end times are the same and that the CAB process is enabled.
   ' If either is not, have user confirm...
   If ldStartTime <> ldEndTime Then
      lsUserMsg = "The Accounting Period Starting and Ending times are different." & vbCrLf & vbCrLf & _
         "Are you sure that they are valid?"
      If MsgBox(lsUserMsg, vbQuestion Or vbYesNo Or vbDefaultButton2, "Please Confirm") = vbNo Then Exit Sub
   End If
   
   ' The following block was commented for DC Lottery.
'   If cbCabEnabled.Value <> vbChecked Then
'      lsUserMsg = "The Clear Account Balance will be created but will not be Enabled and therefore will not run." & _
'         vbCrLf & vbCrLf & "Are you sure that this is correct?"
'      If MsgBox(lsUserMsg, vbQuestion Or vbYesNo, "Please Confirm") = vbNo Then Exit Sub
'   End If

   ' Has the user properly entered the setup info?
   ' Validation checks Clear Account Balance and Progressive Tracking setup,
   ' removing validation for DC Lottery which does not need this functionality.
   'If IsValidSetup(lsErrText) Then
      ' Valid setup so save the data...
      If SaveSetup(lsErrText) Then
         MsgBox "Successfully saved data and scheduled processes.", vbInformation, "Save Status"
         Unload Me
      Else
         MsgBox lsErrText, vbExclamation, "Save Status"
      End If
   'Else
   '   MsgBox lsErrText, vbExclamation, "Schedule Status"
   'End If

End Sub
Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llLeft        As Long
Dim llTop         As Long

   
   Call GetJobInfo
   msInitValue = CStr(DtpStartTime.value) & CStr(DtpEndTime.value) & CStr(cbCabEnabled.value) & _
      CStr(Val(txtCabAmount.Text)) & CStr(Val(txtCabTime.Text)) & CStr(Val(txtProgTrackTime.Text))

   ' Position and size this form, attempt to center in parent...
   llLeft = (mdi_Main.ScaleWidth - 5580) \ 2
   If llLeft < 0 Then llLeft = 0
   llTop = (mdi_Main.ScaleHeight - 6540) \ 2
   If llTop < 0 Then llTop = 0
   Me.Move llLeft, llTop, 5580, 3000

End Sub

Private Sub txtCabAmount_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the CAB Time textbox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsValue       As String

   If KeyAscii <> vbKeyBack Then
      lsValue = Chr(KeyAscii)
      ' Allow only numeric values.
      If InStr(1, ".,0123456789", lsValue, vbTextCompare) = 0 Then
         Beep
         KeyAscii = 0
      End If
   End If

End Sub

Private Sub txtCabTime_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the CAB Time textbox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsValue       As String

   If KeyAscii <> vbKeyBack Then
      lsValue = Chr(KeyAscii)
      ' Allow only numeric values.
      If InStr(1, "0123456789", lsValue, vbTextCompare) = 0 Then
         Beep
         KeyAscii = 0
      End If
   End If

End Sub

Private Sub txtProgTrackTime_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the Progressive Time textbox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsValue       As String

   If KeyAscii <> vbKeyBack Then
      lsValue = Chr(KeyAscii)
      ' Allow only numeric values.
      If InStr(1, "0123456789", lsValue, vbTextCompare) = 0 Then
         Beep
         KeyAscii = 0
      End If
   End If

End Sub

Private Function DateFromInt(alDate As Long, alTime As Long) As String
'--------------------------------------------------------------------------------
' DateFromInt function returns a date string created from integer date and time.
' Integer (Long) date expected to be in format yyyymmdd.
' Integer (Long) time expected to be in format hhmmss.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsDate        As String
Dim lsTime        As String
Dim lsReturn      As String

   lsReturn = ""

   ' Convert the date...
   If alDate > 0 Then
      lsDate = CStr(alDate)
      lsReturn = Mid(lsDate, 5, 2) & "-" & Right(lsDate, 2) & "-" & Left(lsDate, 4)
   End If
   
   ' Convert the time...
   If alTime > 0 Then
      lsTime = CStr(alTime)
      Do While Len(lsTime) < 6
         lsTime = "0" & lsTime
      Loop
      lsReturn = lsReturn & " " & Left(lsTime, 2) & ":" & Mid(lsTime, 3, 2) & ":" & Right(lsTime, 2)
   End If

   ' Set function return value.
   DateFromInt = Trim(lsReturn)

End Function

Private Sub GetJobInfo()
'--------------------------------------------------------------------------------
' GetJobInfo routine retrieves job information from the database for display.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjCmd       As ADODB.Command
Dim lobjRS        As ADODB.Recordset
Dim lobjField     As ADODB.Field

Dim lbHaveData    As Boolean

Dim llDate        As Long
Dim llIt          As Long
Dim llOffset      As Long
Dim llPos         As Long
Dim llTime        As Long
Dim llToTime      As Long

Dim lsDBName      As String
Dim lsJobName     As String
Dim lsTemp        As String
Dim lsValue       As String

   ' Make sure that we have a connection to the database.
   If gConn.State = adStateOpen Then
      lsDBName = gConn.Properties("Initial Catalog").value
   Else
      MsgBox "Database connection is not open, cannot retrieve Job Information."
      Exit Sub
   End If

   ' Retrieve the current Accounting Period start and end offsets...
   If Len(gFromTime) Then
      msTimeStartInitialValue = gFromTime
      DtpStartTime.value = msTimeStartInitialValue
      llToTime = CLng(Replace(gFromTime, ":", ""))
   End If

   If Len(gToTime) Then
      msTimeEndInitialValue = gToTime
      DtpEndTime.value = msTimeEndInitialValue
   End If

' ---------- CAB Process ----------
   ' Setup info to retrieve CAB job info...
   cbCabEnabled.value = vbUnchecked
   lsJobName = "Clear_Account_Balance_" & lsDBName
   lbHaveData = False

   Set lobjCmd = New ADODB.Command
   With lobjCmd
      Set .ActiveConnection = gConn
      .CommandType = adCmdStoredProc
      .CommandText = "msdb..sp_help_job"
      .Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
      .Parameters.Append .CreateParameter("@job_id", adGUID, adParamInput)
      .Parameters.Append .CreateParameter("@job_name", adVarChar, adParamInput, 100, lsJobName)
      .Parameters.Append .CreateParameter("@job_aspect", adVarChar, adParamInput, 9, "JOB")
      On Error Resume Next
      Set lobjRS = .Execute
      On Error GoTo 0
   End With

   If lobjCmd.Parameters("RETURN_VALUE").value = 1 Then
      lbHaveData = False
   Else
      If Not lobjRS Is Nothing Then
         If lobjRS.State <> adStateClosed Then
            If lobjRS.RecordCount <> 0 Then
               lbHaveData = True
               cbCabEnabled.value = lobjRS.Fields("enabled").value
            End If
         End If
      End If

      ' Did we get job data?
      If lbHaveData Then
         ' Yes, now go get step and schedule information, start with step info...
         If lobjRS.State Then lobjRS.Close
         With lobjCmd
            .Parameters("@job_aspect").value = "STEPS"
            On Error Resume Next
            Set lobjRS = .Execute
            On Error GoTo 0
         End With

         If Not lobjRS Is Nothing Then
            If lobjRS.State = adStateOpen Then
               If lobjRS.RecordCount <> 0 Then
                  With lobjRS
                     ' Populate the threshold amount label and textbox...
                     lsValue = Trim(.Fields("command").value & "")
                     llPos = InStrRev(lsValue, " ")
                     If llPos Then
                        lsValue = FormatCurrency(Mid(lsValue, llPos + 1))
                        If Left(lsValue, 1) = "$" Then lsValue = Mid(lsValue, 2)
                        txtCabAmount.Text = lsValue
                     End If
                  End With
               End If
            End If
         End If

         ' Now get schedule information.
         If lobjRS.State Then lobjRS.Close
         With lobjCmd
            .Parameters("@job_aspect").value = "SCHEDULES"
            On Error Resume Next
            Set lobjRS = .Execute
            On Error GoTo 0
         End With

         If Not lobjRS Is Nothing Then
            With lobjRS
               If .State = adStateOpen Then
                  If .RecordCount <> 0 Then
                     ' Set the CAB Schedule offset...
                     llDate = .Fields("active_start_date").value
                     llTime = .Fields("active_start_time").value
                     llOffset = DateDiff("n", CDate(DateFromInt(llDate, llTime)), _
                                         CDate(DateFromInt(llDate, llToTime)))
                     If llOffset < 0 Then llOffset = (llOffset Mod 60) + 60
                     If llOffset > 60 Then llOffset = llOffset Mod 60
                     txtCabTime.Text = CStr(llOffset)
                  End If
               End If
            End With
         End If
      End If
   End If
   Set lobjCmd = Nothing

' ---------- Progressive Tracking Process ----------
   cbProgTrackEnabled.value = vbUnchecked
   lsJobName = "Progressive_Tracking_Update_" & lsDBName
   lbHaveData = False

   Set lobjCmd = New ADODB.Command
   With lobjCmd
      Set .ActiveConnection = gConn
      .CommandType = adCmdStoredProc
      .CommandText = "msdb..sp_help_job"
      .Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
      .Parameters.Append .CreateParameter("@job_id", adGUID, adParamInput)
      .Parameters.Append .CreateParameter("@job_name", adVarChar, adParamInput, 100, lsJobName)
      .Parameters.Append .CreateParameter("@job_aspect", adVarChar, adParamInput, 9, "JOB")
      On Error Resume Next
      Set lobjRS = .Execute
      On Error GoTo 0
      If Err.Number Then MsgBox Err.Description
   End With

   If lobjCmd.Parameters("RETURN_VALUE").value = 1 Then
      lbHaveData = False
      cbProgTrackEnabled.value = vbUnchecked
   Else
      ' Did we get data?
      If Not lobjRS Is Nothing Then
         If lobjRS.State = adStateOpen Then
            If lobjRS.RecordCount <> 0 Then
               ' Yes, set enabled checkbox for the Progressive Tracking checkbox control.
               lbHaveData = True
               cbProgTrackEnabled.value = lobjRS.Fields("enabled").value
            End If
         End If
      End If

      ' Did we get job data?
      If lbHaveData Then
         ' Now get schedule information.
         If lobjRS.State Then lobjRS.Close
         With lobjCmd
            .Parameters("@job_aspect").value = "SCHEDULES"
            On Error Resume Next
            Set lobjRS = .Execute
            On Error GoTo 0
         End With

         If Not lobjRS Is Nothing Then
            With lobjRS
               If .State = adStateOpen Then
                  If .RecordCount <> 0 Then
                        ' Set the CAB Schedule offset...
                        llDate = .Fields("active_start_date").value
                        llTime = .Fields("active_start_time").value
                        llOffset = DateDiff("n", CDate(DateFromInt(llDate, llTime)), _
                                            CDate(DateFromInt(llDate, llToTime)))
                        If llOffset < 0 Then llOffset = (llOffset Mod 60) + 60
                        If llOffset > 60 Then llOffset = llOffset Mod 60
                        txtProgTrackTime.Text = CStr(llOffset)
                  End If
               End If
            End With
         End If
      End If
   End If

   ' Close and free ado object references...
   If Not lobjRS Is Nothing Then
      If lobjRS.State Then lobjRS.Close
      Set lobjRS = Nothing
   End If
   Set lobjCmd = Nothing

End Sub

Private Function IsValidSetup(asErrText As String) As Boolean
'--------------------------------------------------------------------------------
' Validate user setup and return True or False to indicate if okay to save.
' If returning False, populate asErrText with display message.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbReturn      As Boolean
Dim llValue       As Long
Dim lcValue       As Currency
Dim lsValue       As String

   ' Set error text string to an empty string.
   asErrText = ""

   ' Evaluate the CAB amount...
   lsValue = Trim(txtCabAmount.Text)
   If Not IsNumeric(lsValue) Then
      asErrText = "Invalid Clear Account Balance Threshhold Amount."
   Else
      lcValue = CCur(lsValue)
      If lcValue < 0.01 Then
         asErrText = "The Clear Account Balance Threshhold Amount must be greater than 0.01."
      End If
   End If
   If Len(asErrText) Then txtCabAmount.SetFocus

   ' Evaluate the Clear Account Balance run time value...
   If Len(asErrText) = 0 Then
      lsValue = Trim(txtCabTime.Text)
      If Not IsNumeric(lsValue) Then
         asErrText = "Invalid Clear Account Balance run time value."
      Else
         llValue = CLng(lsValue)
         If llValue < 1 Or llValue > 10 Then
            asErrText = "The Clear Account Balance run time value must be between 1 and 10."
         End If
      End If
      If Len(asErrText) Then txtCabTime.SetFocus
   End If

   ' Evaluate the Progressive Tracking run time value...
   If Len(asErrText) = 0 Then
      lsValue = Trim(txtProgTrackTime.Text)
      If Not IsNumeric(lsValue) Then
         asErrText = "Invalid Progressive Tracking run time value."
      Else
         llValue = CLng(lsValue)
         If llValue < 1 Or llValue > 10 Then
            asErrText = "The Progressive Tracking run time value must be between 1 and 10."
         End If
      End If
      If Len(asErrText) Then txtProgTrackTime.SetFocus
   End If

   ' Set function return value.
   IsValidSetup = Len(asErrText) = 0

End Function

Private Function SaveSetup(asErrText As String) As Boolean
'--------------------------------------------------------------------------------
' SaveSetup routine saves start and end times and sets up CAB and PROG jobs.

' Note that for DC Lottery only the accounting offset values are being saved.

'--------------------------------------------------------------------------------
' Allocate local vars...
'Dim lobjCmd          As ADODB.Command

'Dim llReturn         As Long
'Dim llStartTime      As Long

'Dim lsDBName         As String
Dim lsEndTime        As String
'Dim lsJobDesc        As String
'Dim lsJobName        As String
'Dim lsJobStepCmd     As String
'Dim lsMaxAmount      As String
'Dim lsOwnerLoginName As String
'Dim lsScheduleName   As String
Dim lsSQL            As String
Dim lsStartTime      As String

   ' Initialize error text to an empty string.
   asErrText = ""

   ' Store formatted copies of the user selected or entered start and end times...
   lsStartTime = Format(DtpStartTime.value, "hh:mm:ss")
   lsEndTime = Format(DtpEndTime.value, "hh:mm:ss")

   ' Do we need to update the start and end time values?
   If lsStartTime <> msTimeStartInitialValue Or lsEndTime <> msTimeEndInitialValue Then
      ' Yes, so update the default CASINO record...
      lsSQL = "UPDATE CASINO SET FROM_TIME = '%s', TO_TIME = '%s' WHERE SETASDEFAULT = 1"
      lsSQL = Replace(lsSQL, "%s", lsStartTime, 1, 1)
      lsSQL = Replace(lsSQL, "%s", lsEndTime, 1, 1)

      gConn.Execute lsSQL, , adExecuteNoRecords

      ' Reset global start and end times.
      gFromTime = lsStartTime
      gToTime = lsEndTime
   End If
   
   If Len(asErrText) = 0 Then
    Call gConnection.AppEventLog(gUserId, AppEventType.ConfigurationChange, "Accounting Period changed to Start: " & lsStartTime & " End: " & lsEndTime)
   End If
   
   
            
   ' ---------- Setup the CAB job ----------
'   lsDBName = gConn.Properties("Initial Catalog")
'   lsJobName = "Clear_Account_Balance_" & lsDBName
'   lsMaxAmount = CStr(CCur(txtCabAmount.Text))
'   lsJobDesc = "Clear Electronic Card Balances and Create 'Z' transactions in CASINO_TRANS table to " & _
'               "reflect the balance clearing activity."
'   lsJobStepCmd = "EXEC Clear_Account_Balances " & lsMaxAmount
'   lsScheduleName = "Daily_Clear_Account_Balance"
'   lsOwnerLoginName = gConn.Properties("User ID").Value
'
'   llStartTime = (Format(DateAdd("n", -(CLng(txtCabTime.Text)), DtpStartTime.Value), "hmmss"))
'
'   ' Create, init, and execute command object that calls stored proc Create_CAB_Job.
'   Set lobjCmd = New ADODB.Command
'   With lobjCmd
'      Set .ActiveConnection = gConn
'      .CommandText = "Create_Daily_Job"
'      .CommandType = adCmdStoredProc
'      .CommandTimeout = 60
'      .Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
'      .Parameters.Append .CreateParameter("@DBName", adVarChar, adParamInput, 32, lsDBName)
'      .Parameters.Append .CreateParameter("@JobName", adVarChar, adParamInput, 64, lsJobName)
'      .Parameters.Append .CreateParameter("@JobDescription", adVarChar, adParamInput, 256, lsJobDesc)
'      .Parameters.Append .CreateParameter("@JobStepCommand", adVarChar, adParamInput, 1024, lsJobStepCmd)
'      .Parameters.Append .CreateParameter("@JobScheduleName", adVarChar, adParamInput, 64, lsScheduleName)
'      .Parameters.Append .CreateParameter("@StartTime", adInteger, adParamInput, , llStartTime)
'      .Parameters.Append .CreateParameter("@OwnerLoginName", adVarChar, adParamInput, 32, lsOwnerLoginName)
'      .Parameters.Append .CreateParameter("@EnabledState", adTinyInt, adParamInput, , cbCabEnabled.Value)
'      .Execute
'      llReturn = .Parameters("RETURN_VALUE")
'   End With
'   If llReturn <> 0 Then asErrText = "Failed to create the Clear Account Balance job."

   ' ---------- Setup the Progressive Tracking job ----------
'   lsJobName = "Progressive_Tracking_Update_" & lsDBName
'   lsJobDesc = "Update the Progressive Tracking table."
'   lsJobStepCmd = "EXEC Update_Progressive_Track"
'   lsScheduleName = "Daily_Progressive_Tracking_Update"
'   llStartTime = (Format(DateAdd("n", -(CLng(txtProgTrackTime.Text)), DtpStartTime.Value), "hmmss"))
'
'   ' Create, init, and execute command object that calls stored proc Create_CAB_Job.
'   Set lobjCmd = New ADODB.Command
'   With lobjCmd
'      Set .ActiveConnection = gConn
'      .CommandText = "Create_Daily_Job"
'      .CommandType = adCmdStoredProc
'      .CommandTimeout = 60
'      .Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
'      .Parameters.Append .CreateParameter("@DBName", adVarChar, adParamInput, 32, lsDBName)
'      .Parameters.Append .CreateParameter("@JobName", adVarChar, adParamInput, 64, lsJobName)
'      .Parameters.Append .CreateParameter("@JobDescription", adVarChar, adParamInput, 256, lsJobDesc)
'      .Parameters.Append .CreateParameter("@JobStepCommand", adVarChar, adParamInput, 1024, lsJobStepCmd)
'      .Parameters.Append .CreateParameter("@JobScheduleName", adVarChar, adParamInput, 64, lsScheduleName)
'      .Parameters.Append .CreateParameter("@StartTime", adInteger, adParamInput, , llStartTime)
'      .Parameters.Append .CreateParameter("@OwnerLoginName", adVarChar, adParamInput, 32, lsOwnerLoginName)
'      .Parameters.Append .CreateParameter("@EnabledState", adTinyInt, adParamInput, , 1)
'      .Execute
'      llReturn = .Parameters("RETURN_VALUE")
'   End With
'   If llReturn <> 0 Then asErrText = "Failed to create the Progressive Tracking Update job."

   ' Free the command object.
   'Set lobjCmd = Nothing

   ' Set the function return value.
   SaveSetup = (Len(asErrText) = 0)

End Function

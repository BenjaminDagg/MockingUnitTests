Option Explicit On 
Option Strict On

Imports System
Imports System.Data
Imports System.IO
Imports DataAccess
Imports System.Collections
Imports System.Diagnostics
Imports System.Text
Imports System.Text.RegularExpressions

Public Class Message

   ' [Member Variables]
   Private mMessages As New DataSet
   Private mCrLf As String

   ' [Events]
   Public Event MessageError(ByVal ResponseMessage As String)
   Public Event MessageForClient(ByVal Message As String)

   Sub New()
      '--------------------------------------------------------------------------------
      ' Constructor for this class
      '--------------------------------------------------------------------------------

      ' Assign new line value.
      mCrLf = Environment.NewLine

      Try
         ' Load the Messages.xml file
         mMessages.ReadXml(gApplicationPath & "\Messages.xml")

      Catch ex As Exception
         ' Handle the exception...
         Dim lErrorText As String = "Message::New error: " & ex.Message
         Throw New Exception(lErrorText)

      End Try

   End Sub

   Public Function ParseMessage(ByRef Message As String, ByRef MachineNumber As String) As Hashtable
      '--------------------------------------------------------------------------------
      ' Takes a message string and a machine number and returns a hashtable
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lMessageHash As New Hashtable
      Dim lSB As StringBuilder

      Dim lDB As Database
      Dim lDS As DataSet
      Dim lDR As DataRow

      Dim lDRMessages() As DataRow
      Dim lDRResponses() As DataRow = Nothing
      Dim lDRRequestItem() As DataRow
      Dim lDRRequests() As DataRow
      Dim lMsgFields As String()

      Dim lErrorID As Int32 = 0
      Dim lIt As Int32
      Dim lPosX As Int32
      Dim lPosY As Int32

      Dim lFilter As String
      Dim lMsgID As String = ""
      Dim lRegex As String
      Dim lSort As String

      Try
         ' Parse the message into fields.
         lMsgFields = Message.Split(","c)

         ' Determine the MessageId
         If lMsgFields.Length > 2 Then
            ' First 3 message items are: Sequence Number, Transaction/Message Identifer, TimeStamp
            ' Store the message identifier that came in the message from the machine.
            lMsgID = lMsgFields(1)

            ' Get the <Message> node with cols table# (0 based), "id", "sp"
            lDRMessages = mMessages.Tables("Message").Select("id='" & lMsgID & "'")

            If lDRMessages.Length > 0 Then
               lDR = lDRMessages(0)
               lFilter = "Message_Id = " & CType(lDR.Item("Message_Id"), String)
               lSort = "position ASC"

               ' Get all the <request> nodes with cols "position", "regex", "error", "param", table# 
               lDRRequests = mMessages.Tables("request").Select(lFilter, lSort)

               ' Get all the <response> nodes with cols "position", "param", table#
               lDRResponses = mMessages.Tables("response").Select(lFilter, lSort)

               ' There should be the same number of fields in the xml file as there are in the message.
               If lDRRequests.Length = lMsgFields.Length OrElse lMsgID = "A" Then
                  ' Get the SP
                  lMessageHash.Add("sp", CType(lDR.Item("sp"), String))

                  ' Get the MachineNumber
                  lMessageHash.Add("MachineNumber", MachineNumber)

                  lPosX = 0
                  lPosY = lMsgFields.Length

                  If lMsgID = "A" Then lPosY = 8

                  While lPosX < lPosY
                     lFilter = "position = " & lPosX.ToString & " AND Message_Id = " & CType(lDR.Item("Message_Id"), String)
                     lDRRequestItem = mMessages.Tables("request").Select(lFilter)

                     If lDRRequestItem.Length = 1 Then
                        ' Put the field through the regular expression grinder.
                        lRegex = CType(lDRRequestItem(0).Item("regex"), String)
                        If lRegex.Length > 0 Then
                           If Not (Regex.IsMatch(lMsgFields(lPosX), lRegex)) Then
                              lErrorID = CType(lDRRequestItem(0).Item("error"), Int32)
                              Exit While
                           End If
                        End If

                        ' Add the field to the hashtable.
                        lMessageHash.Add(CType(lDRRequestItem(0).Item("param"), String), lMsgFields(lPosX))

                        ' Increment the position counter.
                        lPosX += 1
                     Else
                        lErrorID = 243
                        Exit While
                     End If
                  End While
               Else
                  ' Messages.xml file request count does not match machine message field count.
                  lErrorID = 287
               End If
            Else
               ' MessageId not found in the Xml file.
               lErrorID = 230
            End If
         Else
            ' Message has too few fields, unable to get the MessageId.
            lErrorID = 228
         End If

       

         If lErrorID <> 0 Then
            ' An error occurred, get the error description.
            lDB = New Database(gConnectionString)
            lDB.AddParameter("@Error_No", lErrorID.ToString)

            lDS = lDB.ExecuteProcedure("tpGetErrorDescription")
            RaiseEvent MessageError(CType(lDS.Tables(0).Rows(0).Item("ErrorDescription"), String))


            If lMsgFields.Length > 2 Then
               lSB = New StringBuilder
               lSB.Append(lMsgFields(0)).Append(",")
               lSB.Append(lMsgID).Append(",")
               lSB.Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")).Append(",")
               lDR = lDS.Tables(0).Rows(0)
               lSB.Append(CType(lDR.Item("ErrorId"), String)).Append(",")
               lSB.Append(CType(lDR.Item("ErrorDescription"), String)).Append(",")
               lSB.Append(CType(lDR.Item("ShutDownFlag"), String))

               If lDRResponses IsNot Nothing Then
                  ' In case the <response> nodes contain items in addition to the 6 standard ones above.
                  For lIt = 6 To lDRResponses.Length - 1
                     ' Append comma character to indicate an empty field.
                     lSB.Append(",")
                  Next

               End If
               
               ' Finally, add an end of line set.
               lSB.Append(mCrLf)

               ' Raise MessageForClient event, sending the error info.
               RaiseEvent MessageForClient(lSB.ToString)
            End If


            ' Set the Return value to null.
            lMessageHash = Nothing
         End If

      Catch ex As Exception
         ' Handle the exception...
         RaiseEvent MessageError(ex.ToString)
         lMessageHash = Nothing

      End Try

      ' Set the function return value.
      Return lMessageHash

   End Function

   Public Function GenerateMessage(ByRef MessageHash As Hashtable) As String
      '--------------------------------------------------------------------------------
      ' Takes a hashtable and returns a message string.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSBReturnMessage As New StringBuilder
      Dim lDRMessages() As DataRow
      Dim lDRResponses() As DataRow

      Dim lIt As Integer
      Dim lFilter As String

      lDRMessages = mMessages.Tables("Message").Select("id='" & CType(MessageHash("TransType"), String) & "'")

      If lDRMessages.Length > 0 Then
         lFilter = "Message_Id = " & CType(lDRMessages(0).Item("Message_Id"), String)
         Dim lsSort As String = "position ASC"
         lDRResponses = mMessages.Tables("response").Select(lFilter, lsSort)

         ' There should be the same number of fields in the 
         ' xml file as there are in the message.
         If lDRResponses.Length = MessageHash.Count Then
            ' Dim loResponse As DataRow
            For Each lDR As DataRow In lDRResponses
               lSBReturnMessage.Append(CType(MessageHash(lDR.Item("param")), String)).Append(",")
            Next

            ' Trim the trailing comma.
            lSBReturnMessage.Length -= 1

            ' Append trailing new line characters.
            lSBReturnMessage.Append(mCrLf)
         Else
            ' ErrorID = 288, Messages.xml file Response count does not match TP message field count.
            ' Build the Response string.
            With lSBReturnMessage
               .Append(CType(MessageHash("MachineSequence"), String)).Append(",")
               .Append(CType(MessageHash("TransType"), String)).Append(",")
               .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")).Append(",")
               .Append("288").Append(",")
               .Append("Messages.xml file Response count does not match TP message field count.").Append(",")
               .Append("0")

               ' In case the <response> nodes contain items in addition to the 6 standard ones above.
               For lIt = 6 To lDRResponses.Length - 1
                  ' Append an empty string as place-holder
                  .Append(",")
               Next

               ' Append trailing new line characters.
               .Append(mCrLf)
            End With
         End If
      Else
         ' MessageId not found in the Xml file.
         Throw New Exception("Invalid TransType")

      End If

      ' Set the function return value.
      Return lSBReturnMessage.ToString

   End Function

End Class

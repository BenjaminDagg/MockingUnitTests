Option Strict On
Option Explicit On 

Imports System
Imports System.Collections
Imports System.Data
Imports System.IO

Public Class Transaction
   Inherits DataSet

   Private mRequest As Hashtable
   Private mResponse As Hashtable

   Public Sub New()
      '--------------------------------------------------------------------------------
      ' Load up the Transactions.xml file.
      '--------------------------------------------------------------------------------

      MyBase.ReadXml(Path.Combine(My.Application.Info.DirectoryPath, "Transactions.xml"))
      BuildTransactionHashTables()

   End Sub

   Private Sub BuildTransactionHashTables()
      '--------------------------------------------------------------------------------
      '
      '--------------------------------------------------------------------------------

      mRequest = New Hashtable
      mResponse = New Hashtable

      For Each lDR As DataRow In MyBase.Tables("transaction").Rows
         BuildRequestArrayList(CType(lDR.Item("id"), String), mRequest)
         BuildResponseArrayList(CType(lDR.Item("id"), String), mResponse)
      Next

   End Sub

   Private Sub BuildRequestArrayList(ByVal TransactionType As String, ByRef RequestHashtable As Hashtable)
      '--------------------------------------------------------------------------------
      '
      '--------------------------------------------------------------------------------

      Dim lTransaction As DataRow() = MyBase.Tables("transaction").Select("id = '" & TransactionType & "'")
      Dim lDataRows() As DataRow = lTransaction(0).GetChildRows("transaction_request")
      Dim lRequest As New ArrayList

      For Each lDR As DataRow In lDataRows
         lRequest.Add(CType(lDR.Item("param"), String))
      Next

      RequestHashtable.Add(TransactionType.ToUpper, lRequest)

   End Sub

   Private Sub BuildResponseArrayList(ByVal TransactionType As String, ByRef ResponseHashtable As Hashtable)
      '--------------------------------------------------------------------------------
      '
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lResponse As New ArrayList

      Dim lTransaction As DataRow() = MyBase.Tables("transaction").Select("id = '" & TransactionType & "'")
      Dim lDataRows() As DataRow = lTransaction(0).GetChildRows("transaction_response")

      For Each lDR As DataRow In lDataRows
         lResponse.Add(CType(lDR.Item("param"), String))
      Next

      ResponseHashtable.Add(TransactionType.ToUpper, lResponse)

   End Sub

   Public Function GetRequest(ByVal TransactionType As String) As ArrayList
      '--------------------------------------------------------------------------------
      '
      '--------------------------------------------------------------------------------

      Return CType(mRequest(TransactionType.ToUpper), ArrayList)

   End Function

   Public Function GetResponse(ByVal TransactionType As String) As ArrayList
      '--------------------------------------------------------------------------------
      '
      '--------------------------------------------------------------------------------

      Return CType(mResponse(TransactionType.ToUpper), ArrayList)

   End Function

   Public Function GetStoredProcedure(ByVal TransactionType As String) As String
      '--------------------------------------------------------------------------------
      '
      '--------------------------------------------------------------------------------

      Dim lTransaction As DataRow() = MyBase.Tables("transaction").Select("id = '" & TransactionType & "'")
      Return CType(lTransaction(0).Item("sp"), String)

   End Function

End Class

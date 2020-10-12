Option Explicit On 
Option Strict On

Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.VisualBasic

Namespace DataAccess

Public Class Database
      Implements IDisposable

      ' [Member Variables]
      Private mCommandTimeout As Integer = 30
      Private mReturnValue As Integer

      Private mSQLDataAdapter As SqlDataAdapter
      Private mSQLCommand As SqlCommand
      Private mSQLConnection As SqlConnection

      Private mConnectionString As String
      Private mSQLDataBaseName As String = ""
      Private mSQLServerName As String = ""
      Private mThisClassName As String

      Private mDisposed As Boolean
      Private mSqlTransaction As SqlTransaction

      ' [Public Properties]
      Public Property ConnectionString() As String
         '--------------------------------------------------------------------------------
         ' ConnectionString property
         '--------------------------------------------------------------------------------

         Get
            ConnectionString = mConnectionString
         End Get

         Set(ByVal Value As String)
            mConnectionString = Value
         End Set

      End Property

      Public ReadOnly Property CommandObject() As SqlCommand
         '--------------------------------------------------------------------------------
         ' ReadOnly property CommandObject
         '--------------------------------------------------------------------------------

         Get
            CommandObject = mSQLCommand
         End Get

      End Property

      ''' <summary>
      ''' Returns the name of the database last connected to.
      ''' </summary>
      ''' <returns>String</returns>
      Public ReadOnly Property SQLDatabaseName() As String
         '--------------------------------------------------------------------------------
         ' Return database name last connected to.
         '--------------------------------------------------------------------------------
         Get
            Return mSQLDataBaseName
         End Get

      End Property

      Public ReadOnly Property SQLServerName() As String
         '--------------------------------------------------------------------------------
         ' Return SQL Server Instance name last connected to.
         '--------------------------------------------------------------------------------
         Get
            Return mSQLServerName
         End Get

      End Property

      Public ReadOnly Property ReturnValue() As Integer
         '--------------------------------------------------------------------------------
         ' Gets the last return value from a stored procedure.
         '--------------------------------------------------------------------------------

         Get
            Return mReturnValue
         End Get

      End Property

      ''' <summary>
      ''' Constructor with Connection String argument.
      ''' </summary>
      ''' <param name="ConnectionString">SQL Database connection string.</param>
      ''' <remarks></remarks>
      Public Sub New(ByRef ConnectionString As String)
         '--------------------------------------------------------------------------------
         ' Constructor
         '--------------------------------------------------------------------------------
         ' Allocate local vars...
         Dim lErrorText As String


         Try
            mDisposed = False

            ' Store the name of this class.
            mThisClassName = Me.GetType.Name

            ' Set connection string text.
            mConnectionString = ConnectionString

            ' Instantiate new SqlConnection and SqlCommand objects...
            mSQLConnection = New SqlConnection(mConnectionString)
            mSQLCommand = New SqlCommand
            mSQLCommand.Connection = mSQLConnection

            ' Store the name of the connected database
            mSQLDataBaseName = mSQLConnection.Database
            mSQLServerName = mSQLConnection.DataSource

         Catch ex As Exception
            ' Handle the error...
            lErrorText = mThisClassName & "::Constructor error: " & ex.Message
            Throw New DataAccessException(lErrorText)

         End Try

      End Sub

      Public Sub AddParameter(ByRef ParamName As String, ByRef Value As String)
         '--------------------------------------------------------------------------------
         ' AddParameter
         '--------------------------------------------------------------------------------

         Try
            If Not mDisposed Then
               If Not (mSQLConnection Is Nothing) Then
                  If Not (mSQLCommand Is Nothing) Then
                     mSQLCommand.Parameters.AddWithValue(ParamName, Value)
                  Else
                     Throw New DataAccessException("Command object is null.")
                  End If
               Else
                  Throw New DataAccessException("Connection object is null.")
               End If
            Else
               Throw New DataAccessException("Database object is already disposed.")
            End If

         Catch ex As Exception
            ' Handle the exception...
            Call CloseSQLConnection("AddParameter - 1")
            Throw New DataAccessException(" (Database.AddParameter) ParamName = " & ParamName & "  Exception = " & ex.ToString)

         End Try

      End Sub

      Public Sub AddParameter(ByRef ParamName As String, ByRef DbType As SqlDbType, ByRef Size As Integer, ByRef ParamDirection As ParameterDirection)
         '--------------------------------------------------------------------------------
         ' AddParameter with Overload for DbType, Size, ParameterDirection ( Input, Output, InputOut, ReturnValue
         '--------------------------------------------------------------------------------

         Try
            If Not mDisposed Then
               If Not (mSQLConnection Is Nothing) Then
                  If Not (mSQLCommand Is Nothing) Then
                     Dim lParameter As New SqlParameter(ParamName, DbType, Size)
                     lParameter.Direction = ParamDirection

                     mSQLCommand.Parameters.Add(lParameter)
                  Else
                     Throw New DataAccessException("Command object is null.")
                  End If
               Else
                  Throw New DataAccessException("Connection object is null.")
               End If
            Else
               Throw New DataAccessException("Database object is already disposed.")
            End If

         Catch ex As Exception
            ' Handle the exception...
            Call CloseSQLConnection("AddParameter - 2")
            Throw New DataAccessException(" (Database.AddParameter) ParamName = " & ParamName & "  Exception = " & ex.ToString)

         End Try

      End Sub

      Public Sub AddParameter(ByRef ParamName As String, ByRef DbType As SqlDbType, ByRef ParamValue As String, Optional ByVal Size As Integer = Nothing)
         '--------------------------------------------------------------------------------
         ' AddParameter - Overloaded with SqlDbType & Size
         '--------------------------------------------------------------------------------

         Try
            If Not mDisposed Then
               If Not (mSQLConnection Is Nothing) Then
                  If Not (mSQLCommand Is Nothing) Then
                     If Size = Nothing Then
                        mSQLCommand.Parameters.Add(ParamName, DbType).Value = ParamValue
                     Else
                        mSQLCommand.Parameters.Add(ParamName, DbType, Size).Value = ParamValue
                     End If
                  Else
                     Throw New DataAccessException("Command object is null.")
                  End If
               Else
                  Throw New DataAccessException("Connection object is null.")
               End If
            Else
               Throw New DataAccessException("Database object is already disposed.")
            End If

         Catch ex As Exception
            ' Handle the exception...
            Call CloseSQLConnection("AddParameter - 3")
            Throw New DataAccessException(" (Database.AddParameter) ParamName = " & ParamName & "  Exception = " & ex.ToString)

         End Try

      End Sub

      Public Sub AddParameter(ByRef ParamName As String, ByRef DbType As SqlDbType, ByRef ParamValue As Object, Optional ByVal Size As Integer = Nothing)
         '--------------------------------------------------------------------------------
         ' AddParameter - Overloaded with ParamValue as Object
         '--------------------------------------------------------------------------------
         Try
            If Not mDisposed Then
               If Not (mSQLConnection Is Nothing) Then
                  If Not (mSQLCommand Is Nothing) Then
                     If Size = Nothing Then
                        mSQLCommand.Parameters.Add(ParamName, DbType).Value = ParamValue
                     Else
                        mSQLCommand.Parameters.Add(ParamName, DbType, Size).Value = ParamValue
                     End If
                  Else
                     Throw New DataAccessException("Command object is null.")
                  End If
               Else
                  Throw New DataAccessException("Connection object is null.")
               End If
            Else
               Throw New DataAccessException("Database object is already disposed.")
            End If

         Catch ex As Exception
            ' Handle the exception...
            Call CloseSQLConnection("AddParameter - 4")
            Throw New DataAccessException(" (Database.AddParameter) ParamName = " & ParamName & "  Exception = " & ex.ToString)

         End Try

      End Sub

      Public Sub BeginTransaction()
         '--------------------------------------------------------------------------------
         ' BeginTransaction
         '--------------------------------------------------------------------------------

         Try
            If Not mDisposed Then
               If Not (mSQLConnection Is Nothing) Then
                  If mSQLConnection.State = ConnectionState.Open Then
                     mSqlTransaction = mSQLConnection.BeginTransaction
                  Else
                     Throw New DataAccessException("Connection object is closed.")
                  End If
               Else
                  Throw New DataAccessException("Connection object is null.")
               End If
            Else
               Throw New DataAccessException("Database object is already disposed.")
            End If

         Catch ex As Exception
            ' Handle the exception...
            Call CloseSQLConnection("BeginTransaction")
            Throw New DataAccessException(" (Database.BeginTransaction) " & ex.ToString)

         End Try

      End Sub

      Public Sub ClearParameters()
         '--------------------------------------------------------------------------------
         ' ClearParameters
         '--------------------------------------------------------------------------------

         Try
            If Not mDisposed Then
               If Not (mSQLConnection Is Nothing) Then
                  If Not (mSQLCommand Is Nothing) Then
                     mSQLCommand.Parameters.Clear()
                  Else
                     Throw New DataAccessException("Command object is null.")
                  End If
               Else
                  Throw New DataAccessException("Connection object is null.")
               End If
            Else
               Throw New DataAccessException("Database object is already disposed.")
            End If

         Catch ex As Exception
            ' Handle the exception...
            Call CloseSQLConnection("ClearParameters")
            Throw New DataAccessException(" (Database.ClearParamters) " & ex.ToString)

         End Try

      End Sub

      Public Sub Close()
         '--------------------------------------------------------------------------------
         ' Close - Attempts to close the database connection.
         '--------------------------------------------------------------------------------

         Try
            If Not mDisposed Then
               If Not (mSQLConnection Is Nothing) Then
                  If (mSQLConnection.State And ConnectionState.Open) <> 0 Then
                     mSQLConnection.Close()
                  Else
                     Throw New DataAccessException("Connection object is already closed.")
                  End If
               Else
                  Throw New DataAccessException("Connection object is null.")
               End If
            Else
               Throw New DataAccessException("Database object is already disposed.")
            End If

         Catch ex As Exception
            ' Handle the exception...
            Call CloseSQLConnection("Close")
            Throw New DataAccessException(" (Database.Close) " & ex.ToString)

         End Try

      End Sub

      Public Sub Commit()
         '--------------------------------------------------------------------------------
         ' Commit
         '--------------------------------------------------------------------------------

         Try
            If Not mDisposed Then
               If Not (mSQLConnection Is Nothing) Then
                  If mSQLConnection.State = ConnectionState.Open Then
                     If Not (mSqlTransaction Is Nothing) Then
                        mSqlTransaction.Commit()
                     Else
                        Throw New DataAccessException("Transaction object is null.")
                     End If
                  Else
                     Throw New DataAccessException("Connection object is closed.")
                  End If
               Else
                  Throw New DataAccessException("Connection object is null.")
               End If
            Else
               Throw New DataAccessException("Database object is already disposed.")
            End If

         Catch ex As Exception
            ' Handle the exception...
            Call CloseSQLConnection("Commit")
            Throw New DataAccessException(" (Database.Commit) " & ex.ToString)

         End Try

      End Sub

      ''' <summary>
      ''' Executes the SQL statement passed in the SQLStatement string argument and returns a DataTable object.
      ''' </summary>
      ''' <param name="SQLStatement">SQL Statement to be executed.</param>
      ''' <param name="TableName">Optionally names the returned DataTable.</param>
      ''' <returns>DataTable containing the resultset.</returns>
      Public Function CreateDataTable(ByVal SQLStatement As String, Optional ByVal TableName As String = "") As DataTable
         '--------------------------------------------------------------------------------
         ' Executes the SQL statement passed in the asSQL string argument.
         ' Returns a DataTable object.
         '--------------------------------------------------------------------------------
         ' Allocate local vars...
         Dim lDS As DataSet
         Dim lDT As DataTable
         Dim lErrorText As String

         If String.IsNullOrEmpty(SQLStatement) Then
            Throw New ArgumentException("Invalid SQLStatement value.")
         Else
            Try
               ' Call ExecuteQuery to return a DataSet object,
               ' then return the last table in the DataSet.
               lDS = ExecuteQuery(SQLStatement)
               If lDS.Tables.Count > 0 Then
                  ' Set a reference to the last table in the DataSet.
                  lDT = lDS.Tables(lDS.Tables.Count - 1)

                  ' If we received a Table Name, assign it.
                  If TableName.Length > 0 Then lDT.TableName = TableName

                  ' Return the table.
                  Return lDT
               Else
                  ' No tables in the dataset, return nothing.
                  Return Nothing
               End If

            Catch ex As Exception
               ' Handle the error...
               lErrorText = mThisClassName & "::CreateDataTable error: " & ex.Message
               Throw New DataAccessException(lErrorText)

            End Try

         End If

      End Function

      ''' <summary>
      ''' Executes a stored procedure and Returns a DataTable object.
      ''' </summary>
      ''' <param name="StoredProcName">Stored procedure to be executed.</param>
      ''' <param name="TableName">Optionally names the returned DataTable.</param>
      ''' <returns>DataTable containing the resultset.</returns>
      ''' <remarks>Assumes that all AddParameter calls have already been done.</remarks>
      Public Function CreateDataTableSP(ByVal StoredProcName As String, Optional ByVal TableName As String = "") As DataTable
         '--------------------------------------------------------------------------------
         ' Executes a stored procedure via mSQLCommand.
         ' Assumes that mSQLCommand has been setup prior to calling this routine.
         ' Returns a DataTable object.
         '--------------------------------------------------------------------------------
         ' Allocate local vars...
         Dim lDS As DataSet
         Dim lDT As DataTable
         Dim lErrorText As String

         If String.IsNullOrEmpty(StoredProcName) Then
            Throw New ArgumentException("Invalid StoredProcName argument value.")
         Else
            Try
               ' Call ExecuteProcedure to return a DataSet object
               ' and return the last table in the DataSet.
               lDS = ExecuteProcedure(StoredProcName)

               If lDS.Tables.Count > 0 Then
                  ' Set a reference to the last table in the DataSet.
                  lDT = lDS.Tables(lDS.Tables.Count - 1)

                  ' If we received a Table Name, assign it.
                  If TableName.Length > 0 Then lDT.TableName = TableName

                  ' Return the table.
                  Return lDT
               Else
                  ' No tables in the DataSet, return nothing.
                  Return Nothing
               End If

            Catch ex As Exception
               ' Handle the error...
               lErrorText = mThisClassName & "::CreateDataTableSP error: " & ex.Message
               Throw New DataAccessException(lErrorText)

            End Try
         End If

      End Function

      Public Sub Dispose() Implements IDisposable.Dispose
         '--------------------------------------------------------------------------------
         ' Dispose
         '--------------------------------------------------------------------------------

         Dispose(True)
         GC.SuppressFinalize(Me)

      End Sub

      Protected Sub Dispose(ByVal Disposing As Boolean)
         '--------------------------------------------------------------------------------
         ' Dispose - Overloaded
         '--------------------------------------------------------------------------------

         Try
            ' Has this object already been disposed?
            If Not mDisposed Then
               ' Is this being called by the finalizer or by dispose?
               If Disposing Then

                  ' Test if the command obj exists and dispose of it if it does.
                  If Not (mSQLCommand Is Nothing) Then
                     mSQLCommand.Dispose()
                  End If

                  ' Test if the SQL data adapter object exists and dispose of it if it does.
                  If Not (mSQLDataAdapter Is Nothing) Then
                     mSQLDataAdapter.Dispose()
                  End If

                  ' Test if the transaction object exists and dispose of it if it does.
                  If Not (mSqlTransaction Is Nothing) Then
                     mSqlTransaction.Dispose()
                  End If

                  ' Test if the connection object exists and close/dispose of it if it does.
                  If Not (mSQLConnection Is Nothing) Then

                     ' Test if the connection is open.
                     If (mSQLConnection.State And ConnectionState.Open) <> 0 Then
                        ' Close the connection.
                        mSQLConnection.Close()
                     End If

                     mSQLConnection.Dispose()
                  End If

               End If
            End If

         Catch ex As Exception
            ' Handle the exception...

         Finally
            mDisposed = True

         End Try

      End Sub

      Public Function ExecuteProcedure(ByVal StoredProcName As String, Optional ByVal KeepAlive As Boolean = False) As DataSet
         '--------------------------------------------------------------------------------
         ' ExecuteProcedure
         '--------------------------------------------------------------------------------
         ' Allocate local vars...
         Dim lDataSet As New DataSet

         Try
            If Not mDisposed Then
               If Not (mSQLConnection Is Nothing) Then
                  If Not (mSQLCommand Is Nothing) Then
                     ' Add a return value parameter so we can capture any values RETURNed by sp.
                     Dim lReturnParam As SqlParameter = mSQLCommand.Parameters.Add("RETURN_VALUE", SqlDbType.Int)
                     lReturnParam.Direction = ParameterDirection.ReturnValue

                     With mSQLCommand
                        ' Mark this command object to use a stored procedure.
                        .CommandType = CommandType.StoredProcedure
                        ' Set the name of the stored procedure.
                        .CommandText = StoredProcName
                        If Not (mSqlTransaction Is Nothing) Then .Transaction = mSqlTransaction
                     End With

                     ' Apply the command to the adapter.
                     mSQLDataAdapter = New SqlDataAdapter(mSQLCommand)

                     ' Open the connection if it is not already open.
                     If mSQLConnection.State <> ConnectionState.Open Then
                        mSQLConnection.Open()
                     End If

                     ' Retrieve the data.
                     mSQLDataAdapter.Fill(lDataSet)

                     ' Get the return value and set the module variable 
                     ' so that it can be exposed via the accessor property.
                     mReturnValue = CType(lReturnParam.Value, Integer)

                     ' Close the connection if it is not already closed.
                     If (mSQLConnection.State And ConnectionState.Open) <> 0 Then
                        If KeepAlive = False Then
                           mSQLConnection.Close()
                        End If
                     End If

                     ' Set the function return value.
                     Return lDataSet

                  Else
                     Throw New DataAccessException("Command object is null.")
                  End If
               Else
                  Throw New DataAccessException("Connection object is null.")
               End If
            Else
               Throw New DataAccessException("Database object is already disposed.")
            End If

         Catch ex As Exception
            ' Handle the exception...
            Call CloseSQLConnection("ExecuteProcedure")
            Throw New DataAccessException(" (Database.ExecuteProcedure) StoredProcName = " & StoredProcName & "  Exception = " & ex.ToString)

         End Try

      End Function

      ''' <summary>
      ''' Executes a stored procedure that does not return a resultset.
      ''' </summary>
      ''' <param name="StoredProcName">Name of the stored procedure to execute.</param>
      ''' <param name="KeepAlive">Optional flag (default False) indicating if the SQLConnection should remain open.</param>
      ''' <returns>Returns the number of rows affected.</returns>
      ''' <remarks>Assumes that AddParameter has been called as necessary prior to calling this method. If the procedure RETURNs a value, retrieve the value using the ReturnValue property.</remarks>
      Public Function ExecuteProcedureNoResult(ByVal StoredProcName As String, Optional ByVal KeepAlive As Boolean = False) As Integer
         '--------------------------------------------------------------------------------
         ' Executes the specified Stored Procedure without returning a resultset.
         ' Assumes that it has been setup prior to calling this routine.
         ' Returns the number of rows affected.
         ' Store any value that the stored procedure RETURNs in mReturnValue which can by
         ' accessed via ReadOnly Property ReturnValue of this class.
         '--------------------------------------------------------------------------------
         ' Allocate local vars...
         Dim lReturnParam As SqlParameter
         Dim lReturnValue As Integer
         Dim lErrorText As String

         If String.IsNullOrEmpty(StoredProcName) Then
            Throw New ArgumentException("Invalid StoredProcName argument value.")
         Else
            Try
               If Not mDisposed Then
                  ' Do we have a connection object instantiated?
                  If mSQLConnection IsNot Nothing Then
                     ' Yes, how about a SQLCommand object?
                     If mSQLCommand IsNot Nothing Then
                        ' Is the connection object open?
                        If (mSQLConnection.State And ConnectionState.Open) = 0 Then
                           ' No, so open it.
                           mSQLConnection.Open()
                        End If

                        ' Add a RETURN_VALUE parameter.
                        lReturnParam = mSQLCommand.Parameters.Add("RETURN_VALUE", SqlDbType.Int)
                        lReturnParam.Direction = ParameterDirection.ReturnValue

                        With mSQLCommand
                           ' Assign the procedure name.
                           .CommandText = StoredProcName

                           ' Assign the command type.
                           .CommandType = CommandType.StoredProcedure

                           ' Set the command timeout.
                           .CommandTimeout = mCommandTimeout

                           ' Execute the command object.
                           lReturnValue = mSQLCommand.ExecuteNonQuery()
                        End With

                        ' Get the return value and set the module variable 
                        ' so that it can be exposed via the accessor property.
                        ' mReturnValue = mSQLCommand.Parameters("RETURN_VALUE").Value
                        mReturnValue = CType(lReturnParam.Value, Integer)

                        ' Clear the parameters associated with the command object.
                        mSQLCommand.Parameters.Clear()

                        ' Close the connection if it is not already closed.
                        If (mSQLConnection.State And ConnectionState.Open) <> 0 Then
                           If KeepAlive = False Then
                              mSQLConnection.Close()
                           End If
                        End If

                     Else
                        Throw New DataAccessException("Command object is null.")
                     End If
                  Else
                     Throw New DataAccessException("Connection object is null.")
                  End If
               Else
                  Throw New DataAccessException("Database object is already disposed.")
               End If

               ' Set the function return value.
               Return lReturnValue

            Catch ex As Exception
               ' Handle the error...
               lErrorText = mThisClassName & "::ExecuteProcedureNoResult error: " & ex.Message
               Throw New Exception(lErrorText, ex)
            End Try
         End If

      End Function

      Public Function ExecuteQuery(ByVal SqlSelectStmt As String, Optional ByVal KeepAlive As Boolean = False) As DataSet
         '--------------------------------------------------------------------------------
         ' ExecuteQuery
         '--------------------------------------------------------------------------------
         ' Allocate local vars...
         Dim lDataSet As New DataSet

         Try
            If Not mDisposed Then
               If Not (mSQLConnection Is Nothing) Then
                  If Not (mSQLCommand Is Nothing) Then
                     ' Mark this command object to execute a SELECT stmt.
                     With mSQLCommand
                        .CommandType = CommandType.Text
                        .CommandText = SqlSelectStmt
                        If Not (mSqlTransaction Is Nothing) Then
                           .Transaction = mSqlTransaction
                        End If
                     End With

                     ' Apply the command to the adapter.
                     mSQLDataAdapter = New SqlDataAdapter(mSQLCommand)

                     ' Open the connection if it is not already open.
                     If mSQLConnection.State <> ConnectionState.Open Then
                        mSQLConnection.Open()
                     End If

                     ' Retrieve the data.
                     mSQLDataAdapter.Fill(lDataSet)

                     ' Close the connection if it is not already closed.
                     If (mSQLConnection.State And ConnectionState.Open) <> 0 Then
                        If KeepAlive = False Then
                           mSQLConnection.Close()
                        End If
                     End If

                     ' Set the function return value.
                     Return lDataSet

                  Else
                     Throw New DataAccessException("Command object is null.")
                  End If
               Else
                  Throw New DataAccessException("Connection object is null.")
               End If
            Else
               Throw New DataAccessException("Database object is already disposed.")
            End If

         Catch ex As Exception
            ' Handle the exception...
            Call CloseSQLConnection("ExecuteQuery")
            Throw New DataAccessException(" (Database.ExecuteQuery) SqlSelectStmt = " & SqlSelectStmt & "  Exception = " & ex.ToString)

         End Try

      End Function

      Public Function ExecuteNonQuery(ByVal SqlSelectStmt As String, Optional ByVal KeepAlive As Boolean = False) As Integer
         '--------------------------------------------------------------------------------
         ' ExecuteNonQuery
         '
         ' Purpose:
         '   Executes an SQL INSERT/UPDATE/DELETE statement (that does not
         '   return a resultset) and returns the number of rows affected.
         '--------------------------------------------------------------------------------
         ' Allocate local vars...
         Dim lReturn As Integer = 0

         Try
            If Not mDisposed Then
               If Not (mSQLConnection Is Nothing) Then
                  If Not (mSQLCommand Is Nothing) Then
                     ' Mark this command object to execute a INSERT/UPDATE/DELETE stmt.
                     With mSQLCommand
                        .CommandType = CommandType.Text
                        .CommandText = SqlSelectStmt

                        If Not (mSqlTransaction Is Nothing) Then
                           .Transaction = mSqlTransaction
                        End If
                     End With

                     ' Open the connection if it is not already open.
                     If mSQLConnection.State <> ConnectionState.Open Then
                        mSQLConnection.Open()
                     End If

                     ' Execute the command.
                     lReturn = mSQLCommand.ExecuteNonQuery

                     ' Close the connection if it is not already closed.
                     If (mSQLConnection.State And ConnectionState.Open) <> 0 Then
                        If KeepAlive = False Then
                           mSQLConnection.Close()
                        End If
                     End If

                     ' Set the function return value.
                     Return lReturn

                  Else
                     Throw New DataAccessException("Command object is null.")
                  End If
               Else
                  Throw New DataAccessException("Connection object is null.")
               End If
            Else
               Throw New DataAccessException("Database object is already disposed.")
            End If

         Catch ex As Exception
            ' Handle the exception...
            Call CloseSQLConnection("ExecuteNonQuery")
            Throw New DataAccessException(" (Database.ExecuteNonQuery) SqlSelectStmt = " & SqlSelectStmt & "  Exception = " & ex.ToString)

         End Try

      End Function

      Protected Overrides Sub Finalize()
         '--------------------------------------------------------------------------------
         ' Finalize
         '--------------------------------------------------------------------------------

         Dispose(False)

      End Sub

      Public Sub Open()
         '--------------------------------------------------------------------------------
         ' Open
         '--------------------------------------------------------------------------------

         Try
            If Not mDisposed Then
               If Not (mSQLConnection Is Nothing) Then
                  If mSQLConnection.State <> ConnectionState.Open Then
                     mSQLConnection.Open()
                  Else
                     Throw New DataAccessException("Connection object is already open.")
                  End If
               Else
                  Throw New DataAccessException("Connection object is null.")
               End If
            Else
               Throw New DataAccessException("Database object is already disposed.")
            End If

         Catch ex As Exception
            ' Handle the exception...
            Throw New DataAccessException(" (Database.Open) " & ex.ToString)

         End Try

      End Sub

      Public Sub Rollback()
         '--------------------------------------------------------------------------------
         ' Rollback
         '--------------------------------------------------------------------------------

         Try
            If Not mDisposed Then
               If Not (mSQLConnection Is Nothing) Then
                  If mSQLConnection.State = ConnectionState.Open Then
                     If Not (mSqlTransaction Is Nothing) Then
                        mSqlTransaction.Rollback()
                     Else
                        Throw New DataAccessException("Transaction object is null.")
                     End If
                  Else
                     Throw New DataAccessException("Connection object is closed.")
                  End If
               Else
                  Throw New DataAccessException("Connection object is null.")
               End If
            Else
               Throw New DataAccessException("Database object is already disposed.")
            End If

         Catch ex As Exception
            ' Handle the exception...
            Call CloseSQLConnection("Rollback")
            Throw New DataAccessException(" (Database.Rollback) " & ex.ToString)

         End Try

      End Sub

      Public Sub CloseSQLConnection(ByVal aCaller As String)
         '--------------------------------------------------------------------------------
         ' CloseSQLConnection
         '
         ' Purpose:   To explicitly check for and close "mSQLConnection" to avoid Connection leaks.
         ' Called by: "Catch" blocks of all the routines above.
         '--------------------------------------------------------------------------------

         Try
            If mSQLConnection IsNot Nothing Then
               If (mSQLConnection.State And ConnectionState.Open) <> 0 Then
                  mSQLConnection.Close()
               End If
            End If

         Catch ex As Exception
            ' Handle the exception...
            Throw New DataAccessException(" (Database.CloseSQLConnection) failed for : " & aCaller & "  Error = " & ex.ToString)

         End Try

      End Sub

   End Class

End Namespace

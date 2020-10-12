
Public Class ReportItem

    Private mReportName As String
    Private mReportPath As String


    Private mIsReportFolder As String
    Public Property IsReportFolder() As String
        Get
            Return mIsReportFolder
        End Get
        Set(ByVal value As String)
            mIsReportFolder = value
        End Set
    End Property


    Public Property ReportName() As String
        Get
            Return mReportName
        End Get
        Set(ByVal value As String)
            mReportName = value
        End Set
    End Property

    Public Property ReportPath() As String
        Get
            Return mReportPath
        End Get
        Set(ByVal value As String)
            mReportPath = value
        End Set
    End Property


End Class
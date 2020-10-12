Imports System.IO
Imports System.Text
Imports System.Management

Public Class DriveInfo

   ' [Private member variables]
   Private mDeviceID As String
   Private mDriveIdentifier As String
   Private mDriveDescription As String
   Private mFileSystem As String
   Private mSystemName As String
   Private mVolumeName As String
   Private mVolumeSerialNumber As String

   Private mDriveType As UInteger
   Private mMediaType As UInteger

   Private mDriveSize As Long
   Private mFreeSpace As Long

   Sub New(ByVal DriveIdentifier As String)
      '--------------------------------------------------------------------------------
      ' Contructor with Connection String argument.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      'Dim lDrive As ManagementObject

      'Dim lRC As Long
      'Dim lPath As String

      ' Make sure the drive letter is not null or an empty string
      If DriveIdentifier Is Nothing OrElse DriveIdentifier.Length < 2 Then
         Throw New ArgumentException("Invalid Drive Identifier argument.")
      Else
         ' Assign incoming drive letter to member var.
         mDriveIdentifier = DriveIdentifier.Substring(0, 2).ToUpper

         ' Refresh drive information
         Try
            ' Call RefreshDriveInfo()
            Call RefreshDriveInfoOld()

         Catch ex As Exception
            ' Rethrow the exception
            Throw New Exception(ex.Message)

         End Try

      End If

   End Sub

   Private Sub RefreshDriveInfo()
      '--------------------------------------------------------------------------------
      ' Refresh drive free space info.
      ' This method began failing with an Access Denied error.
      ' Changed from Public to Private so this routine won't be called from outside
      ' of this Class.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDrive As ManagementObject = Nothing

      Dim lErrorMessage As String
      Dim lPath As String

      ' Build the path argument that will be passed to the ManagementObject constructor...
      lPath = String.Format("Win32_LogicalDisk.DeviceID=""{0}""", mDriveIdentifier)

      Try
         ' Create a new Drive Management Object.
         lDrive = New ManagementObject(lPath)
         lDrive.Get()

         ' Assign member var values...
         With lDrive
            mDriveSize = Long.Parse(CType(.GetPropertyValue("Size"), UInt64).ToString)
            mFreeSpace = Long.Parse(CType(.GetPropertyValue("FreeSpace"), UInt64).ToString)
            mDriveDescription = .GetPropertyValue("Description")
            mDeviceID = .GetPropertyValue("DeviceID")
            mDriveType = .GetPropertyValue("DriveType")
            mFileSystem = .GetPropertyValue("FileSystem")
            mVolumeName = .GetPropertyValue("VolumeName")
            mVolumeSerialNumber = .GetPropertyValue("VolumeSerialNumber")
            mMediaType = .GetPropertyValue("MediaType")
            mSystemName = .GetPropertyValue("SystemName")
         End With

      Catch ex As Exception
         ' Handle the error...
         mDriveSize = 0
         mFreeSpace = 0
         mDriveDescription = ""
         mDeviceID = ""
         mDriveType = Nothing
         mFileSystem = ""
         mVolumeName = ""
         mVolumeSerialNumber = ""
         mMediaType = Nothing

         ' Build error message...
         lErrorMessage = "DriveInfo::RefreshDriveInfo - Drive " & mDriveIdentifier & " - Error: " & ex.Message
         If Not ex.InnerException Is Nothing Then
            lErrorMessage &= "  Inner Exception: " & ex.InnerException.Message
         End If

         ' Rethrow the error.
         Throw New Exception(lErrorMessage)
      Finally
         If Not lDrive Is Nothing Then
            lDrive.Dispose()
            lDrive = Nothing
         End If
      End Try

   End Sub

   Public Sub RefreshDriveInfoOld()
      '--------------------------------------------------------------------------------
      ' Refresh drive free space info.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lRC As Integer

      Dim lClusterBytes As Long

      Dim lClusterSectors As Integer
      Dim lSectorBytes As Integer
      Dim lFreeClusters As Integer
      Dim lTotalClusters As Integer

      Try
         ' Get drive space information.
         lRC = GetDiskFreeSpace(mDriveIdentifier, lClusterSectors, lSectorBytes, lFreeClusters, lTotalClusters)

         ' Non-zero return value indicates success.
         If lRC <> 0 Then
            lClusterBytes = lClusterSectors * lSectorBytes
            mDriveSize = lClusterBytes * lTotalClusters
            mFreeSpace = lClusterBytes * lFreeClusters

            ' Get the volume name.
            mVolumeName = Dir(mDriveIdentifier, FileAttribute.Volume)
         Else
            ' GetDiskFreeSpace failed.
            mDriveSize = 0
            mFreeSpace = 0
            mVolumeName = ""
         End If

      Catch ex As Exception
         ' Handle the error.
         mDriveSize = 0
         mFreeSpace = 0
         mVolumeName = ""

      End Try

   End Sub

   Public ReadOnly Property DeviceID() As String
      '--------------------------------------------------------------------------------
      ' Return Device ID value.
      '--------------------------------------------------------------------------------

      Get
         Return mDeviceID
      End Get

   End Property

   Public ReadOnly Property DriveDescription() As String
      '--------------------------------------------------------------------------------
      ' Return drive description.
      '--------------------------------------------------------------------------------

      Get
         Return mDriveDescription
      End Get

   End Property

   Public ReadOnly Property DriveIdentifier() As String
      '--------------------------------------------------------------------------------
      ' Return drive Identifier.
      '--------------------------------------------------------------------------------

      Get
         Return mDriveIdentifier
      End Get

   End Property

   Public ReadOnly Property DriveSize() As Long
      '--------------------------------------------------------------------------------
      ' Return total drive size in bytes.
      '--------------------------------------------------------------------------------

      Get
         Return mDriveSize
      End Get

   End Property

   Public ReadOnly Property DriveType() As UInteger
      '--------------------------------------------------------------------------------
      ' Return total drive size in bytes.
      '--------------------------------------------------------------------------------

      Get
         Return mDriveType
      End Get

   End Property

   Public ReadOnly Property FileSystem() As String
      '--------------------------------------------------------------------------------
      ' Return File System description.
      '--------------------------------------------------------------------------------

      Get
         Return mFileSystem
      End Get

   End Property

   Public ReadOnly Property FreeSpace() As Long
      '--------------------------------------------------------------------------------
      ' Return total free bytes.
      '--------------------------------------------------------------------------------

      Get
         Return mFreeSpace
      End Get

   End Property

   Public ReadOnly Property MediaType() As UInteger
      '--------------------------------------------------------------------------------
      ' Return the Media Type value.
      '--------------------------------------------------------------------------------

      Get
         Return mMediaType
      End Get

   End Property

   Public ReadOnly Property SystemName() As String
      '--------------------------------------------------------------------------------
      ' Return the system name that owns the drive.
      '--------------------------------------------------------------------------------

      Get
         Return mSystemName
      End Get

   End Property

   Public ReadOnly Property VolumeName() As String
      '--------------------------------------------------------------------------------
      ' Return the drive volume name
      '--------------------------------------------------------------------------------

      Get
         Return mVolumeName
      End Get

   End Property

   Public ReadOnly Property VolumeSerialNumber() As String
      '--------------------------------------------------------------------------------
      ' Return the drive serial number.
      '--------------------------------------------------------------------------------

      Get
         Return mVolumeSerialNumber
      End Get

   End Property

End Class

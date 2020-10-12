'Imports System.Collections
'Imports System.Xml

'Public Class ConfigFile

'   Private Shared mConfigFilename As String

'   Public Shared Function GetKeyValue(ByRef Key As String) As String
'      '--------------------------------------------------------------------------------
'      ' Returns a value from the application configuration file for the key value arg.
'      ' If Key is not found, returns an empty string.
'      '--------------------------------------------------------------------------------
'      ' Allocate local vars...
'      Dim lReturn As String = ""

'      Dim lXmlDocument As New System.Xml.XmlDocument
'      Dim lNode As System.Xml.XmlNode

'      ' Load the config file as an XML document.
'      lXmlDocument.Load(mConfigFilename)

'      ' Walk nodes...
'      For Each lNode In lXmlDocument.Item("configuration").Item("appSettings")
'         If lNode.Name = "add" Then
'            If lNode.Attributes.GetNamedItem("key").Value = Key Then
'               lReturn = lNode.Attributes.GetNamedItem("value").Value
'               Exit For
'            End If
'         End If
'      Next

'      ' Set the function return value.
'      Return lReturn

'   End Function

'   Public Shared Function GetKeyValue(ByVal Key As String, ByVal DefaultReturn As String) As String
'      '--------------------------------------------------------------------------------
'      ' Returns a value from the application configuration file for the specified Key
'      ' value.  If the Key is not found, the value passed in DefaultReturn is returned.
'      '--------------------------------------------------------------------------------
'      ' Allocate local vars...
'      Dim lReturn As String = ""
'      Dim lUseDefault As Boolean = True

'      Dim lXmlDocument As New System.Xml.XmlDocument
'      Dim lNode As System.Xml.XmlNode

'      ' Load the config file as an XML document.
'      lXmlDocument.Load(mConfigFilename)

'      ' Walk nodes...
'      For Each lNode In lXmlDocument.Item("configuration").Item("appSettings")
'         If lNode.Name = "add" Then
'            If lNode.Attributes.GetNamedItem("key").Value = Key Then
'               lReturn = lNode.Attributes.GetNamedItem("value").Value
'               lUseDefault = False
'               Exit For
'            End If
'         End If
'      Next

'      ' If the key was not found, use the default value.
'      If lUseDefault Then lReturn = DefaultReturn

'      ' Set the function return value.
'      Return lReturn

'   End Function

'   Public Shared Sub GetMultipleKeyValues(ByRef KeyValueHash As Hashtable)
'      '--------------------------------------------------------------------------------
'      ' Populates incoming Hash table with config file key/value pairs.
'      '--------------------------------------------------------------------------------
'      ' Allocate local vars...
'      Dim lXmlDocument As New System.Xml.XmlDocument
'      Dim lNode As System.Xml.XmlNode

'      ' Load the config file.
'      lXmlDocument.Load(mConfigFilename)

'      ' Walk the nodes searching for keys that match the keys in the incoming Hashtable...
'      For Each lNode In lXmlDocument.Item("configuration").Item("appSettings")
'         If lNode.Name = "add" Then
'            If KeyValueHash.ContainsKey(lNode.Attributes.GetNamedItem("key").Value) Then
'               KeyValueHash(lNode.Attributes.GetNamedItem("key").Value) = lNode.Attributes.GetNamedItem("value").Value
'            End If
'         End If
'      Next

'   End Sub

'   Public Shared Sub SetKeyValue(ByRef Key As String, ByRef Value As String)
'      '--------------------------------------------------------------------------------
'      ' Set a Value for the specified Key in the application config file.
'      '--------------------------------------------------------------------------------
'      ' Allocate local vars...
'      Dim lUpdated As Boolean = False

'      Dim lXmlChildElement As XmlElement
'      Dim lXmlParentElement As XmlElement
'      Dim lXmlDocument As New System.Xml.XmlDocument
'      Dim lNode As System.Xml.XmlNode

'      ' Load the config file.
'      lXmlDocument.Load(mConfigFilename)

'      ' Walk the nodes searching for key to update...
'      For Each lNode In lXmlDocument.Item("configuration").Item("appSettings")
'         If lNode.Name = "add" Then
'            If lNode.Attributes.GetNamedItem("key").Value = Key Then
'               ' Found the key, so update the value, then exit the loop.
'               lNode.Attributes.GetNamedItem("value").Value = Value
'               lUpdated = True
'               Exit For
'            End If
'         End If
'      Next

'      ' Did we update an element?
'      If Not lUpdated Then
'         ' No, so we need to add it...
'         lXmlParentElement = lXmlDocument.Item("configuration").Item("appSettings")
'         lXmlChildElement = lXmlDocument.CreateElement("add")
'         lXmlChildElement.SetAttribute("key", Key)
'         lXmlChildElement.SetAttribute("value", Value)
'         lXmlParentElement.AppendChild(lXmlChildElement)
'      End If

'      ' Save the config file.
'      lXmlDocument.Save(mConfigFilename)

'   End Sub

'   Public Shared Sub SetMultipleKeyValues(ByRef KeyValueHash As Hashtable)
'      '--------------------------------------------------------------------------------
'      ' Sets multiple key/value pairs in the application configuration file.
'      '--------------------------------------------------------------------------------
'      ' Allocate local vars...
'      Dim lXmlDocument As New System.Xml.XmlDocument
'      Dim lNode As System.Xml.XmlNode

'      ' Load the config file.
'      lXmlDocument.Load(mConfigFilename)

'      For Each lNode In lXmlDocument.Item("configuration").Item("appSettings")
'         If lNode.Name = "add" Then
'            If KeyValueHash.ContainsKey(lNode.Attributes.GetNamedItem("key").Value) Then
'               lNode.Attributes.GetNamedItem("value").Value = KeyValueHash(lNode.Attributes.GetNamedItem("key").Value)
'            End If
'         End If
'      Next

'      ' Save the config file.
'      lXmlDocument.Save(mConfigFilename)

'   End Sub

'   Public Shared Sub GetWindowState(ByRef FormReference As Form)
'      '--------------------------------------------------------------------------------
'      ' Gets Saved form state info. If found, updates the form size and position.
'      '--------------------------------------------------------------------------------
'      ' Allocate local vars...
'      Dim lXmlDocument As New System.Xml.XmlDocument
'      Dim lNode As System.Xml.XmlNode
'      Dim lSubNode As System.Xml.XmlNode

'      Dim lFinished As Boolean = False

'      Dim lHeight As Integer
'      Dim lLeft As Integer
'      Dim lScreenHeight As Integer = Screen.PrimaryScreen.WorkingArea.Height
'      Dim lScreenWidth As Integer = Screen.PrimaryScreen.WorkingArea.Width
'      Dim lTop As Integer
'      Dim lWidth As Integer
'      Dim lWindowState As Integer

'      ' Load the config file.
'      lXmlDocument.Load(mConfigFilename)

'      For Each lNode In lXmlDocument.Item("configuration").Item("appSettings")
'         If lNode.Name = "add" Then
'            If lNode.Attributes.GetNamedItem("key").Value = "WindowState" Then
'               ' Determine whether the "add" element has child nodes and if so, walk the child nodes.
'               If lNode.HasChildNodes Then
'                  For Each lSubNode In lNode.ChildNodes
'                     If lSubNode.Name = "window" Then
'                        If lSubNode.Attributes.GetNamedItem("name").Value = FormReference.Name Then
'                           lHeight = CType(lSubNode.Attributes.GetNamedItem("height").Value, Integer)
'                           lWidth = CType(lSubNode.Attributes.GetNamedItem("width").Value, Integer)
'                           lTop = CType(lSubNode.Attributes.GetNamedItem("top").Value, Integer)
'                           lLeft = CType(lSubNode.Attributes.GetNamedItem("left").Value, Integer)
'                           lWindowState = CType(lSubNode.Attributes.GetNamedItem("state").Value, Integer)

'                           ' Constrain location values to be within reasonable limits...
'                           If lLeft < 0 OrElse lLeft > lScreenWidth Then lLeft = 10
'                           If lTop < 0 OrElse lTop > lScreenHeight Then lTop = 10

'                           ' Do we have non-zero values?
'                           If lHeight + lWidth + lTop + lLeft + lWindowState <> 0 Then
'                              ' Yes, so set the location, size and windowstate...
'                              With FormReference
'                                 .Location = New Point(lLeft, lTop)
'                                 .Size = New Size(lWidth, lHeight)
'                                 .WindowState = lWindowState
'                              End With
'                           End If

'                           ' Exit the inner loop.
'                           lFinished = True
'                           Exit For
'                        End If
'                     End If
'                  Next

'                  ' If we are done, exit the outer loop.
'                  If lFinished Then Exit For
'               End If
'            End If
'         End If
'      Next

'   End Sub

'   Public Shared Sub SetWindowState(ByRef FormReference As Form)
'      '--------------------------------------------------------------------------------
'      ' Saves form state info (size, position, windowstate).
'      '--------------------------------------------------------------------------------
'      ' Allocate local vars...
'      Dim lXmlDocument As New System.Xml.XmlDocument
'      Dim lNode As System.Xml.XmlNode
'      Dim lSubNode As System.Xml.XmlNode

'      Dim lExists As Boolean = False
'      Dim lFinished As Boolean = False

'      Dim lLeft As Integer = FormReference.Left
'      Dim lTop As Integer = FormReference.Top

'      Dim lFormName As String = FormReference.Name

'      ' Load the config file.
'      lXmlDocument.Load(mConfigFilename)

'      ' Make sure the top and left values are within a reasonable range.
'      If lLeft < 0 OrElse lLeft > Screen.PrimaryScreen.WorkingArea.Width Then lLeft = 10
'      If lTop < 0 OrElse lTop > Screen.PrimaryScreen.WorkingArea.Height Then lTop = 10

'      ' Begin the search...
'      For Each lNode In lXmlDocument.Item("configuration").Item("appSettings")
'         If lNode.Name = "add" Then
'            If lNode.Attributes.GetNamedItem("key").Value = "WindowState" Then
'               ' Determine whether the "add" element has child nodes and if so, walk the child nodes.
'               If lNode.HasChildNodes Then
'                  For Each lSubNode In lNode.ChildNodes
'                     If lSubNode.Name = "window" AndAlso lSubNode.Attributes.GetNamedItem("name").Value = lFormName Then
'                        lExists = True

'                        With lSubNode.Attributes
'                           .GetNamedItem("height").Value = FormReference.Height.ToString
'                           .GetNamedItem("width").Value = FormReference.Width.ToString
'                           .GetNamedItem("top").Value = lTop.ToString
'                           .GetNamedItem("left").Value = lLeft.ToString
'                           .GetNamedItem("state").Value = FormReference.WindowState
'                        End With

'                        ' We are done...
'                        lFinished = True

'                        ' Exit the inner loop.
'                        Exit For
'                     End If
'                  Next
'               End If

'               If lExists = False Then
'                  'Create the element and add the attributes.
'                  lSubNode = lXmlDocument.CreateElement("window")

'                  Dim lAttribute As XmlAttribute

'                  ' Form Name
'                  lAttribute = lXmlDocument.CreateAttribute("name")
'                  lAttribute.Value = FormReference.Name
'                  lSubNode.Attributes.SetNamedItem(lAttribute)

'                  ' Form Height
'                  lAttribute = lXmlDocument.CreateAttribute("height")
'                  lAttribute.Value = FormReference.Height
'                  lSubNode.Attributes.SetNamedItem(lAttribute)

'                  ' Form Width
'                  lAttribute = lXmlDocument.CreateAttribute("width")
'                  lAttribute.Value = FormReference.Width
'                  lSubNode.Attributes.SetNamedItem(lAttribute)

'                  ' Form Top
'                  lAttribute = lXmlDocument.CreateAttribute("top")
'                  lAttribute.Value = lTop.ToString
'                  lSubNode.Attributes.SetNamedItem(lAttribute)

'                  ' Form Left
'                  lAttribute = lXmlDocument.CreateAttribute("left")
'                  lAttribute.Value = lLeft.ToString
'                  lSubNode.Attributes.SetNamedItem(lAttribute)

'                  ' Form WindowState
'                  lAttribute = lXmlDocument.CreateAttribute("state")
'                  lAttribute.Value = FormReference.WindowState
'                  lSubNode.Attributes.SetNamedItem(lAttribute)

'                  lNode.AppendChild(lSubNode)

'                  lFinished = True
'               End If
'            End If
'         End If

'         ' If finished, exit the outer loop.
'         If lFinished Then Exit For
'      Next

'      ' Save the config file.
'      lXmlDocument.Save(mConfigFilename)

'   End Sub

'   Public Shared Property ConfigFilename() As String
'      '--------------------------------------------------------------------------------
'      ' Gets or sets the configuration filename.
'      '--------------------------------------------------------------------------------
'      Get
'         Return mConfigFilename
'      End Get

'      Set(ByVal Value As String)
'         mConfigFilename = Value
'      End Set

'   End Property

'End Class

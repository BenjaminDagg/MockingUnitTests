Public Class CasinoSystemParameters

    Public Sub New()

    ' Set default values if no DB entry is found
    mVoucherDisplayCasinoNameInAddressField = False

    End Sub

    Private mVoucherDisplayCasinoNameInAddressField As Boolean

Public Property VoucherDisplayCasinoNameInAddressField() As Boolean
    Get
        Return mVoucherDisplayCasinoNameInAddressField
    End Get
    Set(ByVal value As Boolean)
        mVoucherDisplayCasinoNameInAddressField = value
    End Set

End Property

End Class

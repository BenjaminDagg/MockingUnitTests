SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[uvwVoucherInfo]
AS
SELECT
   v.VOUCHER_ID,
   v.LOCATION_ID,
   v.VOUCHER_TYPE,
   v.BARCODE,
   v.VOUCHER_AMOUNT,
   v.CREATE_DATE,
   v.CREATED_LOC,
   v.REDEEMED_LOC,
   v.REDEEMED_STATE,
   v.REDEEMED_DATE,
   v.CHECK_VALUE,
   v.CT_TRANS_NO_VC,
   v.CT_TRANS_NO_VR,
   v.CT_TRANS_NO_JP,
   v.IS_VALID,
   v.SESSION_PLAY_AMOUNT,
   v.UCV_TRANSFERRED,
   v.UCV_TRANSFER_DATE,
   v.GAME_TITLE_ID,
   ISNULL(cas.CAS_NAME, '')        AS LOCATION_NAME,
   ISNULL(cas.RETAILER_NUMBER, '') AS RETAILER_NUMBER,
   au.FirstName + ' ' + au.LastName          AS CASHIER_NAME,
   dbo.ufnIsVoucherExpired(v.LOCATION_ID, v.VOUCHER_ID) AS IsExpired,
   dbo.ufnVoucherExpirationDate(v.LOCATION_ID, v.VOUCHER_ID) AS ExpirationDate
FROM dbo.VOUCHER v
   LEFT OUTER JOIN dbo.VoucherPayout AS vp ON v.VOUCHER_ID = vp.VoucherID
   LEFT OUTER JOIN dbo.CASINO        AS cas ON v.LOCATION_ID = cas.LOCATION_ID
   LEFT OUTER JOIN dbo.AppUser       AS au ON vp.AppUserID = au.AppUserID


GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[66] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2) )"
      End
      ActivePaneConfig = 14
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "v"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 273
               Right = 241
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cas"
            Begin Extent = 
               Top = 9
               Left = 311
               Bottom = 251
               Right = 542
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vp"
            Begin Extent = 
               Top = 3
               Left = 579
               Bottom = 189
               Right = 744
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AppUser"
            Begin Extent = 
               Top = 6
               Left = 783
               Bottom = 121
               Right = 935
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 23
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
 ', 'SCHEMA', N'dbo', 'VIEW', N'uvwVoucherInfo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'     PaneHidden = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'uvwVoucherInfo', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'uvwVoucherInfo', NULL, NULL
GO

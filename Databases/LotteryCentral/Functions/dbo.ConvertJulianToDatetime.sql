SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ConvertJulianToDatetime](@JulianDate char(5)) RETURNS datetime AS
 BEGIN
 RETURN (SELECT DATEADD(day, CONVERT(int,RIGHT(@JulianDate,3)) - 1, CONVERT(datetime, LEFT(@JulianDate,2) + '0101', 112)))
 END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
--------------------------------------------------------------------------------
Procedure Name: ProcessGLInfo

 Created By:   Aldo Zamora
 
 Create Date:  08-03-2011
 
 Description:  Updates all rows used to create the GL FIle by setting them as
               processed, adding a processed date and the file path.
 
 Return Value:   

Parameters:
   @GLFilePath       Path where the GL File was created
   @ICRFilePath      Path where the ICR File was created   
   @DateProcessed    Date GL File was created
  

Change Log:

Changed By    Date           Database Version
  Change Description
--------------------------------------------------------------------------------
Aldo Zamora   08-03-2011     v2.0.5
  Inital coding
--------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[ProcessGLInfo]
   @GLFilePath    VARCHAR(256),
   @ICRFilePath   VARCHAR(256),
   @DateProcessed DATETIME

AS

UPDATE GLInfo
   SET IsProcessed = 1,
   GLFilename      = @GLFilePath,
   ICRFilename     = @ICRFilePath,   
   ProcessedDate   = @DateProcessed
WHERE
   IsProcessed = 0
GO

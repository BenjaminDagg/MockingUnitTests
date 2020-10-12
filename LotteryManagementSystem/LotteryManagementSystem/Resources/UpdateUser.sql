--DECLARE @AppUserID  Int,
--   @UserName     VarChar(16),
--   @FirstName   VarChar(64),
--   @LastName   VarChar(64),
--   @IsActive   Bit
   

-- Update data into AppUser table...
UPDATE [AppUser] SET
   UserName     = @UserName,
   FirstName   = @FirstName,
   LastName   = @LastName,
   IsActive   = @IsActive
WHERE AppUserID = @AppUserID

-- Return the error value.
SELECT @@ERROR

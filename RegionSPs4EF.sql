ALTER PROCEDURE [dbo].[InsertRegion]
    @RegionID          INT,
    @RegionDescription NCHAR(50)
AS
BEGIN
    INSERT INTO [dbo].[Region] ([RegionID], [RegionDescription])
    VALUES (@RegionID, @RegionDescription)
    
    SELECT scope_identity() AS [RegionId]
END
GO
CREATE PROCEDURE [dbo].[UpdateRegion]
	@RegionID	INT,
	@RegionDescription	NChar(50)
AS
	UPDATE [dbo].[Region] SET [RegionDescription] = @RegionDescription
	WHERE [RegionID] = @RegionID
GO
CREATE PROCEDURE [dbo].[DeleteRegion]
	@RegionID	INT
AS
	DELETE FROM [dbo].[Region] 	WHERE [RegionID] = @RegionID
GO

exec InsertRegion 420, 'test region'
EXEC UPDATEREGION 420, 'TEST123 REGION'
EXEC DELETEREGION 420
select * from Region where regionid=420
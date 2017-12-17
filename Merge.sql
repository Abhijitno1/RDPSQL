--SELECT * INTO Regions FROM REGION WHERE 1=2

MERGE Regions RS
USING (SELECT * FROM Region) R (RegionID, RegionDescription)
ON (R.RegionID = RS.RegionID)
WHEN MATCHED THEN
	UPDATE SET RegionDescription = R.RegionDescription
WHEN Not MATCHED THEN
	INSERT VALUES (R.RegionID, R.RegionDescription);
	--OUTPUT $action, inserted, deleted;

GO
bulk insert sales.orderstatus
from 'c:\OrderStatus.csv'
with (
  fieldterminator = ',',
  rowterminator = '\n'
)

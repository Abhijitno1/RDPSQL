select top 20 EmployeeID, FirstName + ' ' + LastName as EmployeeName, Title, BirthDate, HireDate, City, Country, Cast(60000.00 as money) as Salary into EmployeeWithSal from dbo.Employees 
update EmployeeWithSal set Salary=60000
Select * from EmployeeWithSal
GO

-- Simple SP with transaction and error handling
ALTER PROCEDURE UpdateEmployeeSalary (
	@EmployeeID int
)
AS
BEGIN
	DECLARE @Title NVarchar(30), @Hike Numeric(7,5), @Country Nvarchar(15), @Allowance Numeric(7, 5)

	SELECT @Title = Title, @Country = Country FROM EmployeeWithSal WHERE EmployeeID=@EmployeeID
	SELECT @Hike =  CASE @Title WHEN 'Sales Representative' THEN 0.05
					WHEN 'Sales Manager' THEN 0.07
					WHEN 'Inside Sales Coordinator' THEN 0.08
					WHEN 'Vice President, Sales' THEN 0.10
					ELSE 0.05 END
	IF (@Country <> 'USA')
		SET @Allowance = 50
	ELSE
		SET @Allowance = 0

	BEGIN TRY
		BEGIN TRAN

		UPDATE EmployeeWithSal SET Salary = Salary + Salary * @Hike + @Allowance
		WHERE EmployeeID = @EmployeeID

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() ErrNum, ERROR_MESSAGE() Message, ERROR_SEVERITY() Severity

		ROLLBACK TRAN
	END CATCH
END
GO
exec UpdateEmployeeSalary 5
GO

-- SP with for update Cursor
CREATE PROCEDURE UpdateEmployeeSalaryV2 
AS
BEGIN
	DECLARE @EmployeeID int, @Title NVarchar(30), @Country Nvarchar(15), 
		@Hike Numeric(7,5), @Salary money, @Allowance Numeric(7, 5)

	BEGIN TRY
		BEGIN TRAN
		-----------
		DECLARE EmpCur CURSOR FOR
			SELECT EmployeeID, Title, Country FROM EmployeeWithSal
			FOR UPDATE OF Salary
		OPEN EmpCur
		FETCH NEXT FROM EmpCur INTO @EmployeeID, @Title, @Country
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			SELECT @Hike =  CASE @Title WHEN 'Sales Representative' THEN 0.05
							WHEN 'Sales Manager' THEN 0.07
							WHEN 'Inside Sales Coordinator' THEN 0.08
							WHEN 'Vice President, Sales' THEN 0.10
							ELSE 0.05 END
			IF (@Country <> 'USA')
				SET @Allowance = 50
			ELSE
				SET @Allowance = 0

			UPDATE EmployeeWithSal SET Salary = Salary + Salary * @Hike + @Allowance
			WHERE CURRENT OF EmpCur

			FETCH NEXT FROM EmpCur INTO @EmployeeID, @Title, @Country
		END
		CLOSE EmpCur
		DEALLOCATE EmpCur
		-----------
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() ErrNum, ERROR_MESSAGE() Message, ERROR_SEVERITY() Severity

		ROLLBACK TRAN
	END CATCH
END
GO

exec UpdateEmployeeSalaryV2
--1. Declare scalar variable for storing FirstName values
--Assign value ‘Antonio’ to the FirstName variable
--Find all Students  having FirstName  same as the variable
DECLARE 
@FirstName NVARCHAR(100)
SET @FirstName='Antonio'
SELECT * FROM Student
WHERE FirstName=@FirstName
GO
--2. Declare table variable that will contain StudentId, StudentName and DateOfBirth 
--Fill the  table variable with all Female  students
DECLARE @FemaleStudents TABLE
(StudentId INT NOT NULL,FirstName NVARCHAR(100) NULL ,DateOfBirth Date)
INSERT INTO @FemaleStudents(StudentId,FirstName,DateOfBirth)
SELECT Id,FirstName,DateOfBirth
FROM Student
WHERE Gender='F'
SELECT * FROM @FemaleStudents
GO
--3. Declare temp table that will contain LastName and EnrolledDate columns
--Fill the temp table with all Male students having First Name starting with ‘A’
--Retrieve  the students  from the  table which last name  is with 7 characters
CREATE TABLE #MaleStudents
(LastName NVARCHAR(100) NOT NULL,EnrolledDate DATE)
INSERT INTO #MaleStudents(LastName, EnrolledDate)
SELECT LastName,EnrolledDate
FROM Student
WHERE Gender='M' AND FirstName LIKE 'A%'
SELECT * FROM #MaleStudents
WHERE LEN(LastName)=7
GO
DROP TABLE #MaleStudents
GO
--4. Find all teachers whose FirstName length is less than 5 and
--the first 3 characters of their FirstName  and LastName are the same
SELECT FirstName,
LEN(FirstName) AS FirstNameLength,
LEFT(FirstName,3) AS FirstNameFirstThreeCharacters,
LEFT(LastName,3) AS LastNameFirstThreeCharacters
FROM Teacher 
WHERE LEN(FirstName)>5 AND LEFT(FirstName,3) =LEFT(LastName,3) 
GO
--5. Declare scalar function (fn_FormatStudentName) for retrieving the Student description for specific StudentId in the following format:
--StudentCardNumber without “sc-”
-- “ –“
--First character  of student  FirstName
--“.”
--Student LastName
CREATE FUNCTION dbo.fn_FormatStudentName(@StudentId INT)
RETURNS NVARCHAR(100)
AS 
BEGIN
DECLARE @Output NVARCHAR(100)
SELECT @Output=SUBSTRING(StudentCardNumber,4,8)+ '-'+ LEFT(FirstName,1)+'.'+Student.LastName
FROM [dbo].[Student]
WHERE ID= @StudentId
RETURN @Output
END
GO
ALTER FUNCTION dbo.fn_FormatStudentName(@StudentId INT)
RETURNS NVARCHAR(100)
AS 
BEGIN
DECLARE @Output NVARCHAR(100)
SELECT @Output=SUBSTRING(StudentCardNumber,4,8)+ ' -'+ LEFT(FirstName,1)+'.'+Student.LastName
FROM [dbo].[Student]
WHERE ID= @StudentId
RETURN @Output
END
GO
SELECT *,[dbo].[fn_FormatStudentName](ID) AS FunctionOutput
FROM [dbo].[Student]
GO

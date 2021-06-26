--Create multi-statement table value function that for specific Teacher and Course will return list of students (FirstName, LastName)
--who passed the exam, together with Grade and CreatedDate
ALTER FUNCTION dbo.fn_GradesPerStudent(@TeacherId INT ,@CourseId INT)
RETURNS @Output TABLE(StudentFirstName NVARCHAR(100),StudentLastName NVARCHAR(100),Grade TINYINT, CreatedDate DATETIME)
AS 
BEGIN
INSERT INTO @Output
SELECT S.FirstName,S.LastName,G.Grade,G.CreatedDate
FROM [Grade] AS G
INNER JOIN [Student] AS S ON S.ID=G.StudentID
INNER JOIN [GradeDetails] AS GD ON GD.GradeID=G.ID
INNER JOIN [AchievementType] AS A ON A.ID=GD.AchievementTypeID
WHERE GD.AchievementPoints>A.ParticipationRate AND  A.Name='ispit'
AND G.TeacherID=@TeacherId AND G.CourseID=@CourseId
RETURN 
END 
GO

DECLARE @TeacherId INT = 5
DECLARE @CourseId INT = 1

SELECT * FROM dbo.fn_GradesPerStudent(@TeacherId,@CourseId)
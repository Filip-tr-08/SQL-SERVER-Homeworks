-- Homework requirement 1a/2
--Create new procedure called CreateGrade
--Procedure should create only Grade header info (not Grade Details)
--Procedure should return the total number of grades in the system for the Student on input (from the CreateGrade)
--Procedure should return second resultset with the MAX Grade of all grades for the Student and Teacher on input (regardless the Course)
ALTER PROCEDURE dbo.CreateGrade(@CreatedDate DATE, @StudentID INT, @CourseID INT,@TeacherID INT,@Grade INT)
AS 
BEGIN 
INSERT INTO dbo.Grade(CreatedDate,StudentID,CourseID,TeacherID, Grade)
VALUES (@CreatedDate,@StudentID,@CourseID,@TeacherID,@Grade)
SELECT COUNT(*) AS TotalGradesForStudent
FROM dbo.Grade AS G
WHERE StudentID=@StudentID

SELECT MAX(G.Grade) AS MaxGrade
FROM dbo.Grade AS G
WHERE StudentID=@StudentID
AND TeacherID=@TeacherID
END
GO
EXEC dbo.CreateGrade @CreatedDate='1999.03.19',@StudentID=111,@CourseID=1,@TeacherID=9,@Grade =9
SELECT TOP 10*
FROM dbo.Grade
ORDER BY 1 DESC
GO
--Homework requirement 1b/2
--Create new procedure called CreateGradeDetail
--Procedure should add details for specific Grade (new record for new AchievementTypeID, Points, MaxPoints, Date for specific Grade)
--Output from this procedure should be resultset with SUM of GradePoints calculated with formula AchievementPoints/AchievementMaxPoints*ParticipationRate for specific Grade
CREATE OR ALTER PROCEDURE dbo.CreateGradeDetail(@GradeId INT,@AchievementTypeID INT ,@AchievementPoints INT, @AchievementMaxPoints INT,@AchievementDate DATETIME)
AS 
BEGIN
INSERT INTO dbo.GradeDetails([GradeID],[AchievementTypeID],[AchievementPoints],[AchievementMaxPoints],[AchievementDate])
VALUES(@GradeId ,@AchievementTypeID  ,@AchievementPoints , @AchievementMaxPoints ,@AchievementDate )
SELECT G.Grade,SUM(GD.AchievementPoints/GD.AchievementMaxPoints*A.ParticipationRate) AS SumOfGradePoints
FROM GradeDetails AS GD
INNER JOIN Grade AS G ON G.ID=GD.GradeID
INNER JOIN AchievementType AS A ON A.ID=GD.AchievementTypeID
WHERE GD.GradeID=@GradeId
GROUP BY G.Grade
END
GO
EXEC dbo.CreateGradeDetail @GradeID=2, @AchievementTypeID=3,@AchievementPoints=93,@AchievementMaxPoints=100,@AchievementDate='1998-06-20 00:00:00.000'
SELECT * FROM Grade
WHERE ID=2
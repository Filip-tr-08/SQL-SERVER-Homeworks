--1. Find all Students with FirstName= Antonio
SELECT*
FROM [dbo].[Student]
WHERE FirstName='Antonio'
GO
--2. Find all Students with DateOfBirth greater than ‘01.01.1999’
SELECT*
FROM [dbo].[Student]
WHERE DateOfBirth>'1999.01.01'
GO
--3. Find all Male students
SELECT*
FROM [dbo].[Student]
WHERE Gender='M'
GO
--4. Find all Students with LastName starting With ‘T’
SELECT*
FROM [dbo].[Student]
WHERE LastName LIKE 'T%'
GO
--5. Find all Students Enrolled in January/1998
SELECT*
FROM [dbo].[Student]
WHERE EnrolledDate>='1998-01-01' AND EnrolledDate<='1998-01-31'
GO
--6. Find all Students with LastName starting With ‘J’ enrolled in January/1998
SELECT*
FROM [dbo].[Student]
WHERE EnrolledDate>='1998-01-01' AND EnrolledDate<='1998-01-31' AND LastName LIKE 'J%'
GO
--7. Find all Students with FirstName= Antonio ordered by Last Name
SELECT*
FROM [dbo].[Student]
WHERE FirstName='Antonio'
ORDER BY LastName ASC
GO
--8. List all Students ordered by FirstName
SELECT*
FROM [dbo].[Student]
ORDER BY FirstName ASC
GO
--9. Find all Male students ordered by EnrolledDate, starting from the last enrolled
SELECT*
FROM [dbo].[Student]
ORDER BY EnrolledDate DESC
GO
--10. List all Teacher First Names and Student First Names in single result set with duplicates
SELECT FirstName
FROM [dbo].[Student]
UNION ALL
SELECT FirstName
FROM [dbo].[Teacher]
GO
--11. List all Teacher Last Names and Student Last Names in single result set. Remove duplicates
SELECT LastName
FROM [dbo].[Student]
UNION
SELECT LastName
FROM [dbo].[Teacher]
GO
--12. List all common First Names for Teachers and Students
SELECT FirstName
FROM [dbo].[Student]
INTERSECT
SELECT FirstName
FROM [dbo].[Teacher]
GO
--13. Change GradeDetails table always to insert value 100 in AchievementMaxPoints column if no value is provided on insert
ALTER TABLE [dbo].[GradeDetails]
ADD CONSTRAINT DF_Achievement_Max_Points
DEFAULT 100 FOR [AchievementMaxPoints]
GO
SELECT*
FROM [dbo].[GradeDetails]
GO
--14. Change GradeDetails table to prevent inserting AchievementPoints that will more than AchievementMaxPoints
ALTER TABLE [dbo].[GradeDetails] WITH CHECK
ADD CONSTRAINT CHK_Achievement_Points
CHECK (AchievementPoints<=AchievementMaxPoints);
GO
SELECT*
FROM [dbo].[GradeDetails]
GO
--15. Change AchievementType table to guarantee unique names across the Achievement types
ALTER TABLE[dbo].[AchievementType] WITH CHECK
ADD CONSTRAINT UC_Name UNIQUE ([Name])
GO
SELECT*
FROM [dbo].[AchievementType]
GO
--16. Create Foreign key constraints from diagram or with script
ALTER TABLE [dbo].[Grade] ADD CONSTRAINT [FK_Grade_Student] FOREIGN KEY ([StudentID]) REFERENCES [dbo].[Student]([ID]);
ALTER TABLE [dbo].[Grade] ADD CONSTRAINT [FK_Grade_Course] FOREIGN KEY ([CourseID]) REFERENCES [dbo].[Course]([ID]);
ALTER TABLE [dbo].[Grade] ADD CONSTRAINT [FK_Grade_Teacher] FOREIGN KEY ([TeacherID]) REFERENCES [dbo].[Teacher]([ID]);
ALTER TABLE [dbo].[GradeDetails] ADD CONSTRAINT [FK_GradeDetails_Grade] FOREIGN KEY ([GradeID]) REFERENCES [dbo].[Grade]([ID]);
ALTER TABLE [dbo].[GradeDetails] ADD CONSTRAINT [FK_GradeDetails_AchievementType] FOREIGN KEY ([AchievementTypeID]) REFERENCES [dbo].[AchievementType]([ID]);
--17. List all possible combinations of Courses names and AchievementType names that can be passed by student
SELECT A.Name AS Course, B.Name AS Achievement
FROM [dbo].[Course] AS A
CROSS JOIN [dbo].[AchievementType] AS B
GO
--18. List all Teachers that has any exam Grade
SELECT DISTINCT T.FirstName, T.LastName
FROM [dbo].[Grade] AS G 
INNER JOIN [dbo].[Teacher] AS T
ON T.ID = G.TeacherID
GO
--19. List all Teachers without exam Grade
SELECT DISTINCT C.FirstName,C.LastName
FROM [dbo].[Teacher] AS C
LEFT JOIN [dbo].[Grade] AS D 
ON D.TeacherID = C.ID
WHERE D.TeacherID IS NULL
GO
--20. List all Students without exam Grade (using Right Join)
SELECT E.*
FROM [dbo].[Grade] F
RIGHT JOIN [dbo].[Student] E ON F.StudentID = E.Id
WHERE F.StudentID IS NULL
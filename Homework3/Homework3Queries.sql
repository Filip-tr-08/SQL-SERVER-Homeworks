USE [SEDCHome]
GO

--1. Calculate the count of all grades in the system
SELECT COUNT(G.Grade) AS [Total Grades]
FROM [Grade] AS G
GO
--2. Calculate the count of all grades per Teacher in the system
SELECT T.ID,T.FirstName, COUNT(G.Grade) AS [Total Grades Per Teacher]
FROM [Grade] AS G
INNER JOIN [Teacher] AS T ON T.Id=G.TeacherID
GROUP BY T.ID,T.FirstName
ORDER BY COUNT(G.Grade) ASC
GO
--3. Calculate the count of all grades per Teacher in the system for first 100 Students (ID < 100)
SELECT T.ID, T.FirstName, COUNT(G.Grade) AS [Total Grades Per Teacher For First 100 students]
FROM [Grade] AS G
INNER JOIN [Teacher] AS T ON T.Id=G.TeacherID
WHERE G.StudentID<100
GROUP BY T.ID,T.FirstName
ORDER BY COUNT(G.Grade) ASC
GO
--4. Find the Maximal Grade, and the Average Grade per Student on all grades in the system
SELECT S.ID ,S.FirstName, MAX(G.Grade) AS [Max grade per student], AVG(G.Grade) AS [Average grade per student]  
FROM [GRADE] AS G
INNER JOIN [Student] AS S ON S.ID=G.StudentID
GROUP BY S.ID,S.FirstName
ORDER BY AVG(G.Grade) DESC
GO
--5. Calculate the count of all grades per Teacher in the system and filter only grade count greater then 200
SELECT T.ID,T.FirstName, COUNT(G.Grade) AS [Total Grades Per Teacher]
FROM [Grade] AS G
INNER JOIN [Teacher] AS T ON T.Id=G.TeacherID
GROUP BY T.ID,T.FirstName
HAVING COUNT(G.Grade) > 200
ORDER BY COUNT(G.Grade) ASC
GO
--6. Calculate the count of all grades per Teacher in the system for first 100 Students (ID < 100) and filter teachers with more than 50 Grade count
SELECT T.FirstName, COUNT(G.Grade) AS [Total Grades Per Teacher For First 100 students]
FROM [Grade] AS G
INNER JOIN [Teacher] AS T ON T.Id=G.TeacherID
WHERE G.StudentID<100
GROUP BY T.FirstName
HAVING COUNT(G.Grade)>50
ORDER BY COUNT(G.Grade) ASC
GO
--7. Find the Grade Count, Maximal Grade, and the Average Grade per Student on all grades in the system. Filter only records where Maximal Grade is equal to Average Grade
SELECT S.ID,S.FirstName,COUNT(G.Grade) AS [Num of grades] ,MAX(G.Grade) AS [Max grade per student], AVG(G.Grade) AS [Average grade per student]  
FROM [GRADE] AS G
INNER JOIN [Student] AS S ON S.ID=G.StudentID
GROUP BY S.ID,S.FirstName
HAVING MAX(G.Grade)=AVG(G.Grade) -- site maksimalni ocenki se 10 a najgolemata prosecna ocenka e 9 i zatoa ne naogja ni eden student
GO
--8. List Student First Name and Last Name next to the other details from previous query
SELECT S.ID,CONCAT(S.FirstName,' ',S.LastName) AS [Name],COUNT(G.Grade) AS [Num of grades] ,MAX(G.Grade) AS [Max grade per student], AVG(G.Grade) AS [Average grade per student]  
FROM [GRADE] AS G
INNER JOIN [Student] AS S ON S.ID=G.StudentID
GROUP BY S.ID ,S.FirstName, S.LastName
HAVING MAX(G.Grade)=AVG(G.Grade) 
ORDER BY MAX(G.Grade) DESC
GO
--9. Create new view (vv_StudentGrades) that will List all StudentIdsand count of Grades per student
CREATE VIEW vv_StudentGrades
AS
SELECT S.ID , COUNT(G.Grade) AS [Num of Grades]
FROM [Grade] AS G
INNER JOIN [Student] AS S ON S.ID=G.StudentID
GROUP BY S.ID
GO
SELECT * FROM vv_StudentGrades
GO
--10. Change the view to show Student First and Last Names instead of StudentID
ALTER VIEW  vv_StudentGrades
AS
SELECT CONCAT (S.FirstName,' ', S.LastName) AS [Name] , COUNT(G.Grade) AS [Num of Grades]
FROM [Grade] AS G
INNER JOIN [Student] AS S ON S.ID=G.StudentID
GROUP BY S.FirstName,S.LastName
GO
SELECT * FROM vv_StudentGrades
--11. List all rows from view ordered by biggest Grade Count
SELECT * FROM vv_StudentGrades
ORDER BY [Num of Grades] DESC
GO
--12. Create new view (vv_StudentGradeDetails) that will List all Students (FirstName and LastName) and Count the courses he passed through the exam(Ispit)
CREATE VIEW vv_StudentGradeDetails
AS 
SELECT CONCAT(S.FirstName,' ',S.LastName) AS [Name], COUNT(G.Grade) AS [Num of passed courses], A.Name AS [How it is passed]
FROM Grade AS G
INNER JOIN Student AS S ON S.ID=G.StudentID
INNER JOIN GradeDetails AS GD ON GD.GradeID=G.ID
INNER JOIN AchievementType AS A ON A.ID=GD.AchievementTypeID
WHERE GD.AchievementPoints>A.ParticipationRate
AND A.Name='ispit'
GROUP BY S.FirstName,S.LastName, A.Name
GO
SELECT * FROM vv_StudentGradeDetails
ORDER BY [Num of passed courses] DESC
GO
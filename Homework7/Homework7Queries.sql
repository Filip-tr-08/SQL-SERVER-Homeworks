CREATE OR ALTER PROCEDURE dbo.CreateGradeDetail(@GradeId INT,@AchievementTypeID INT ,@AchievementPoints INT, @AchievementMaxPoints INT,@AchievementDate DATETIME)
AS 
BEGIN
BEGIN TRY
INSERT INTO dbo.GradeDetails([GradeID],[AchievementTypeID],[AchievementPoints],[AchievementMaxPoints],[AchievementDate])
VALUES(@GradeId ,@AchievementTypeID  ,@AchievementPoints , @AchievementMaxPoints ,@AchievementDate )
END TRY
BEGIN CATCH
SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH;
SELECT G.Grade,SUM(GD.AchievementPoints/GD.AchievementMaxPoints*A.ParticipationRate) AS SumOfGradePoints
FROM GradeDetails AS GD
INNER JOIN Grade AS G ON G.ID=GD.GradeID
INNER JOIN AchievementType AS A ON A.ID=GD.AchievementTypeID
WHERE GD.GradeID=@GradeId
GROUP BY G.Grade
END
GO

EXEC dbo.CreateGradeDetail @GradeID=2, @AchievementTypeID=9080,@AchievementPoints=93,@AchievementMaxPoints=100,@AchievementDate='1998-06-20 00:00:00.000'
GO
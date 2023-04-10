CREATE DATABASE EventDB

USE EventDB


CREATE TABLE Cities
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(30)
)

CREATE PROCEDURE USP_InsertCity
@CityName NVARCHAR(30)
AS
INSERT INTO Cities
VALUES
(@CityName)

EXEC USP_InsertCity 'Baku'
EXEC USP_InsertCity 'Dubai'
EXEC USP_InsertCity 'London'
EXEC USP_InsertCity 'Moscow'
EXEC USP_InsertCity 'Istanbul'
EXEC USP_InsertCity 'New York'
EXEC USP_InsertCity 'Pekin'
EXEC USP_InsertCity 'Salyan <3'



CREATE TABLE Events
(
	Id INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(30),
	Description NVARCHAR (30),
	StartDate DATETIME2,
	EndDate DATETIME2,
	CityId INT FOREIGN KEY REFERENCES Cities(Id)
)
ALTER TABLE Events
ALTER COLUMN Description  NVARCHAR(200);

INSERT INTO Events (Title,Description,StartDate,EndDate,CityId)
VALUES
('Rio Carnival‎','Rio Carnival is the world s biggest and most famous carnival, held annually in Rio de Janeiro, Brazil','2023-04-04 14:00','2023-04-10 17:00',2),
('Rio Carnival‎','Rio Carnival is the world s biggest and most famous carnival, held annually in Rio de Janeiro, Brazil','2023-04-04 14:00','2023-04-10 17:00',2),
('Rio Carnival‎','Rio Carnival is the world s biggest and most famous carnival, held annually in Rio de Janeiro, Brazil','2023-04-04 14:00','2023-04-10 17:00',2),
('Burning Man','Glastonbury Festival is one of the world s largest and most iconic music festivals, held annually in Somerset, England. ','2023-01-04 12:00','2023-01-22 22:00',3),
('Wimbledon‎','The Wimbledon tournament is one of the most prestigious and oldest tennis championships in the world','2022-09-16 17:00','2022-10-23 22:00',5),
('Super Bowl ‎','he Super Bowl is the annual championship game of the National Football League (NFL)','2021-11-12 11:00','2021-12-14 12:00',4),
('Day of the Dead‎','Day of the Dead, or Dia de los Muertos, is a vibrant and colorful celebration in Mexico honoring deceased loved ones.','2022-06-17 13:00','2022-06-21 13:00',6),
('Bonnaroo‎','Bonnaroo festival is a four-day annual music and arts festival held in Manchester, Tennessee.','2023-02-23 11:00','2023-03-15 12:00',7),
('Baliq Bayrami‎','Bele sey yoxdu ozumden atdim','2022-02-13 16:00','2023-02-14 17:00',8)



CREATE TABLE Speakers
(
	Id INT PRIMARY KEY IDENTITY,
	FullName NVARCHAR (30),
	Position NVARCHAR (30),
	ImageSrc NVARCHAR (100)
)

INSERT INTO Speakers
VALUES 
('Maqsud Muslumov','Speaker','Axot yoxdu tapmaga'),
('Amin Israfilzade','CEO','Axot yoxdu tapmaga'),
('Resad Abbasov','PEO','Axot yoxdu tapmaga'),
('Tural Qoca Isbatov','Hesbisey','Axot yoxdu tapmaga'),
('Elvin Kele','Artiq bezirem','Axot yoxdu tapmaga'),
('Huseyn Mazqi','Bezdim','Axot yoxdu tapmaga'),
('Ramil Bigli','Sagol','Axot yoxdu tapmaga')

CREATE TABLE SpeakersAndEvents
(
	SpeakerId INT FOREIGN KEY REFERENCES Speakers (Id),
	EventId INT FOREIGN KEY REFERENCES Events (Id)
)

INSERT INTO SpeakersAndEvents
VALUES
(2,3),
(2,5),
(1,6),
(4,7),
(7,3),
(6,5),
(3,5),
(4,3),
(6,4),
(2,7),
(1,7),
(2,4),
(5,2),
(1,3),
(3,1),
(3,6)


SELECT Events.Title,Cities.Name, COUNT(SpeakersAndEvents.SpeakerId) AS SpeakerCount,DATEDIFF(minute,Events.StartDate,Events.EndDate) AS TotalMinutes
FROM Events
INNER JOIN Cities ON Events.CityId=Cities.Id
LEFT JOIN SpeakersAndEvents ON Events.Id=SpeakersAndEvents.EventId
GROUP BY Events.Title,Cities.Name,Events.StartDate,Events.EndDate



ALTER PROCEDURE USP_SelectEventsByDate
@Year INT,
@Month INT,
@Day INT
AS
SELECT Events.Title, Cities.Name AS City
FROM Events
INNER JOIN Cities ON Events.CityId = Cities.Id
WHERE YEAR(Events.StartDate) = @Year AND MONTH(Events.StartDate) = @Month AND DAY(Events.StartDate) = @Day

EXEC USP_SelectEventsByDate 2022, 02, 13



CREATE VIEW SpeakerAllAbout
AS
SELECT Speakers.FullName AS SpeakerName, COUNT(SpeakersAndEvents.EventId) AS EventsCount,
SUM(DATEDIFF(MINUTE, Events.StartDate, Events.EndDate)) AS TotalMinutes
FROM Speakers
LEFT JOIN SpeakersAndEvents ON Speakers.Id = SpeakersAndEvents.SpeakerId
LEFT JOIN Events ON SpeakersAndEvents.EventId = Events.Id
GROUP BY Speakers.FullName

SELECT * FROM SpeakerAllAbout


SELECT Events.CityId, Cities.Name AS CityName, COUNT(*) AS EventsCount
FROM Events
INNER JOIN Cities ON Events.CityId = Cities.Id
GROUP BY Events.CityId, Cities.Name
HAVING COUNT(*) > 2



CREATE VIEW LastYearEvents AS
SELECT Events.Title, Cities.Name AS City, COUNT(SpeakersAndEvents.SpeakerId) AS SpeakersCount
FROM Events
INNER JOIN Cities ON Events.CityId = Cities.Id
LEFT JOIN SpeakersAndEvents  ON Events.Id = SpeakersAndEvents.EventId
WHERE Events.StartDate >= DATEADD(year, -1, GETDATE())
GROUP BY Events.Title, Cities.Name

SELECT * FROM LastYearEvents


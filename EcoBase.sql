-- Создаём новую базу данных (по желанию)
USE master;
Go
DROP DATABASE IF EXISTS EcoGraph;
Go
CREATE DATABASE EcoGraph;
Go 
USE EcoGraph;
Go

-- Насекомые
CREATE TABLE Insects (
    Id INT PRIMARY KEY,
    Name NVARCHAR(100),
    Type NVARCHAR(50)
) AS NODE;
GO

-- Растения
CREATE TABLE Plants (
    Id INT PRIMARY KEY,
    Name NVARCHAR(100),
    Family NVARCHAR(50)
) AS NODE;
GO

-- Места обитания
CREATE TABLE Habitats (
    Id INT PRIMARY KEY,
    Name NVARCHAR(100),
    Humidity_Level NVARCHAR(50)
) AS NODE;
GO

-- Опыление
CREATE TABLE Pollinates AS EDGE;
GO

-- Место обитания
CREATE TABLE LivesIn (
    EntityType NVARCHAR(10) -- 'insect' или 'plant'
) AS EDGE;
GO

-- Хищничество
CREATE TABLE Predates AS EDGE;
GO

-- Insects
INSERT INTO Insects (Id, Name, Type) VALUES
(1, 'Пчела медоносная', 'опылитель'),
(2, 'Шмель', 'опылитель'),
(3, 'Жук-оленёк', 'древоед'),
(4, 'Златка', 'травоядный'),
(5, 'Бабочка адмирал', 'опылитель'),
(6, 'Сарана', 'травоядный'),
(7, 'Муравей', 'всеядный'),
(8, 'Стрекоза', 'хищник'),
(9, 'Оса', 'всеядный'),
(10, 'Богомол', 'хищник');

-- Plants
INSERT INTO Plants (Id, Name, Family) VALUES
(1, 'Ромашка', 'Астровые'),
(2, 'Лютик', 'Лютиковые'),
(3, 'Клевер', 'Бобовые'),
(4, 'Мак', 'Маковые'),
(5, 'Одуванчик', 'Астровые'),
(6, 'Тысячелистник', 'Астровые'),
(7, 'Зверобой', 'Зверобойные'),
(8, 'Крапива', 'Крапивные'),
(9, 'Мята', 'Яснотковые'),
(10, 'Иван-чай', 'Кипрейные');

-- Habitats
INSERT INTO Habitats (Id, Name, Humidity_Level) VALUES
(1, 'Лес', 'влажный'),
(2, 'Луг', 'умеренный'),
(3, 'Болото', 'влажный'),
(4, 'Песчаная дюна', 'сухой'),
(5, 'Поляна', 'умеренный'),
(6, 'Горная зона', 'прохладный'),
(7, 'Овраг', 'влажный'),
(8, 'Сад', 'искусственный'),
(9, 'Опушка леса', 'переходный'),
(10, 'Речная пойма', 'влажный');

-- Опыление (Pollinates)
INSERT INTO Pollinates ($from_id, $to_id) VALUES
((SELECT $node_id FROM Insects WHERE Name = 'Пчела медоносная'),
 (SELECT $node_id FROM Plants WHERE Name = 'Ромашка')),
((SELECT $node_id FROM Insects WHERE Name = 'Пчела медоносная'),
 (SELECT $node_id FROM Plants WHERE Name = 'Клевер')),
((SELECT $node_id FROM Insects WHERE Name = 'Шмель'),
 (SELECT $node_id FROM Plants WHERE Name = 'Мак')),
((SELECT $node_id FROM Insects WHERE Name = 'Бабочка адмирал'),
 (SELECT $node_id FROM Plants WHERE Name = 'Тысячелистник')),
((SELECT $node_id FROM Insects WHERE Name = 'Бабочка адмирал'),
 (SELECT $node_id FROM Plants WHERE Name = 'Мята')),
((SELECT $node_id FROM Insects WHERE Name = 'Шмель'),
 (SELECT $node_id FROM Plants WHERE Name = 'Одуванчик')),
((SELECT $node_id FROM Insects WHERE Name = 'Оса'),
 (SELECT $node_id FROM Plants WHERE Name = 'Крапива')),
((SELECT $node_id FROM Insects WHERE Name = 'Муравей'),
 (SELECT $node_id FROM Plants WHERE Name = 'Иван-чай')),
((SELECT $node_id FROM Insects WHERE Name = 'Пчела медоносная'),
 (SELECT $node_id FROM Plants WHERE Name = 'Лютик')),
((SELECT $node_id FROM Insects WHERE Name = 'Пчела медоносная'),
 (SELECT $node_id FROM Plants WHERE Name = 'Тысячелистник'));

-- Место обитания (LivesIn) для насекомых
INSERT INTO LivesIn ($from_id, $to_id, EntityType) VALUES
((SELECT $node_id FROM Insects WHERE Name = 'Пчела медоносная'), (SELECT $node_id FROM Habitats WHERE Name = 'Луг'), 'insect'),
((SELECT $node_id FROM Insects WHERE Name = 'Шмель'), (SELECT $node_id FROM Habitats WHERE Name = 'Луг'), 'insect'),
((SELECT $node_id FROM Insects WHERE Name = 'Жук-оленёк'), (SELECT $node_id FROM Habitats WHERE Name = 'Лес'), 'insect'),
((SELECT $node_id FROM Insects WHERE Name = 'Богомол'), (SELECT $node_id FROM Habitats WHERE Name = 'Опушка леса'), 'insect'),
((SELECT $node_id FROM Insects WHERE Name = 'Сарана'), (SELECT $node_id FROM Habitats WHERE Name = 'Поляна'), 'insect'),
((SELECT $node_id FROM Insects WHERE Name = 'Оса'), (SELECT $node_id FROM Habitats WHERE Name = 'Сад'), 'insect');

-- Место обитания (LivesIn) для растений
INSERT INTO LivesIn ($from_id, $to_id, EntityType) VALUES
((SELECT $node_id FROM Plants WHERE Name = 'Ромашка'), (SELECT $node_id FROM Habitats WHERE Name = 'Луг'), 'plant'),
((SELECT $node_id FROM Plants WHERE Name = 'Клевер'), (SELECT $node_id FROM Habitats WHERE Name = 'Луг'), 'plant'),
((SELECT $node_id FROM Plants WHERE Name = 'Мак'), (SELECT $node_id FROM Habitats WHERE Name = 'Поляна'), 'plant'),
((SELECT $node_id FROM Plants WHERE Name = 'Крапива'), (SELECT $node_id FROM Habitats WHERE Name = 'Лес'), 'plant');

-- Хищничество (Predates)
INSERT INTO Predates ($from_id, $to_id) VALUES
((SELECT $node_id FROM Insects WHERE Name = 'Богомол'),
 (SELECT $node_id FROM Insects WHERE Name = 'Сарана')),
((SELECT $node_id FROM Insects WHERE Name = 'Богомол'),
 (SELECT $node_id FROM Insects WHERE Name = 'Муравей')),
((SELECT $node_id FROM Insects WHERE Name = 'Стрекоза'),
 (SELECT $node_id FROM Insects WHERE Name = 'Оса')),
((SELECT $node_id FROM Insects WHERE Name = 'Стрекоза'),
 (SELECT $node_id FROM Insects WHERE Name = 'Шмель'));

SELECT i.Name AS Insect
FROM Insects i, Pollinates p, Plants pl
WHERE MATCH(i-(p)->pl)
  AND pl.Name = 'Ромашка';

SELECT pl.Name AS Plant
FROM Insects i, Pollinates p, Plants pl
WHERE MATCH(i-(p)->pl)
  AND i.Name = 'Пчела медоносная';

SELECT i.Name AS Insect
FROM Insects i, LivesIn l, Habitats h
WHERE MATCH(i-(l)->h)
  AND h.Name = 'Луг'
  AND l.EntityType = 'insect';

SELECT DISTINCT i.Name AS Insect
FROM Insects i, LivesIn li, Habitats h1,
     Plants p, LivesIn lp, Habitats h2
WHERE MATCH(i-(li)->h1 and p-(lp)->h2)
  AND h1.Id = h2.Id
  AND p.Name = 'Ромашка'
  AND li.EntityType = 'insect'
  AND lp.EntityType = 'plant';

SELECT predator.Name AS Predator
FROM Insects predator, Predates pr, Insects prey
WHERE MATCH(predator-(pr)->prey)
  AND prey.Name = 'Муравей';


SELECT
    I.Name AS StartInsect,
    STRING_AGG(P.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS PathToPlants
FROM
    Insects AS I,
    Pollinates FOR PATH AS poll,
    Plants FOR PATH AS P
WHERE
    MATCH(SHORTEST_PATH(I(-(poll)->P)+))
    AND I.Name = 'Пчела медоносная';

SELECT
    Predator.Name AS Predator,
    STRING_AGG(Prey.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS PathToPrey
FROM
    Insects AS Predator,
    Predates FOR PATH AS pred,
    Insects FOR PATH AS Prey
WHERE
    MATCH(SHORTEST_PATH(Predator(-(pred)->Prey)+))
    AND Predator.Name = 'Богомол';

SELECT
    P.Name AS Plant,
    STRING_AGG(H.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS PathToHabitats
FROM
    Plants AS P,
    LivesIn FOR PATH AS li,
    Habitats FOR PATH AS H
WHERE
    MATCH(SHORTEST_PATH(P(-(li)->H)+))
    AND P.Name = 'Ромашка';



--------------------------------------Для PowerBI--------------------------------------------------
--------------------------------------Поедание----------------------------------------------------

SELECT 
    I1.Id AS IdFirst,
    I1.Name AS First,
    CONCAT(N'Insect', I1.Id) AS [First image name],
    I2.Id AS IdSecond,
    I2.Name AS Second,
    CONCAT(N'Insect', I2.Id) AS [Second image name],
    'Predates' AS RelationshipType
FROM Insects AS I1,
     Predates AS Pred,
     Insects AS I2
WHERE MATCH(I1-(Pred)->I2);

-------------------------------------Произрастание----------------------------------

SELECT 
    P.Id AS IdFirst,
    P.Name AS First,
    CONCAT(N'Plant', P.Id) AS [First image name],
    H.Id AS IdSecond,
    H.Name AS Second,
    CONCAT(N'Habitat', H.Id) AS [Second image name],
    'LivesIn (Plant)' AS RelationshipType
FROM Plants AS P,
     LivesIn AS LI,
     Habitats AS H
WHERE MATCH(P-(LI)->H) AND LI.EntityType = 'plant';

--------------------------------------Проживание----------------------------------------

SELECT 
    I.Id AS IdFirst,
    I.Name AS First,
    CONCAT(N'Insect', I.Id) AS [First image name],
    H.Id AS IdSecond,
    H.Name AS Second,
    CONCAT(N'Habitat', H.Id) AS [Second image name],
    'LivesIn (Insect)' AS RelationshipType
FROM Insects AS I,
     LivesIn AS LI,
     Habitats AS H
WHERE MATCH(I-(LI)->H) AND LI.EntityType = 'insect';

---------------------------------------Опыление-----------------------------------------

SELECT 
    I.Id AS IdFirst,
    I.Name AS First,
    CONCAT(N'Insect', I.Id) AS [First image name],
    P.Id AS IdSecond,
    P.Name AS Second,
    CONCAT(N'Plant', P.Id) AS [Second image name],
    'Pollinates' AS RelationshipType
FROM Insects AS I,
     Pollinates AS Pol,
     Plants AS P
WHERE MATCH(I-(Pol)->P);

---------------------------------------Общие взаимоотношения-------------------------
--SELECT @@servername

--https://raw.githubusercontent.com/D0-OS/EcoBase/refs/heads/main/images/

-- Все связи опыления
SELECT 
    I.Id AS IdFirst,
    I.Name AS First,
    CONCAT(N'Insect', I.Id) AS [First image name],
    P.Id AS IdSecond,
    P.Name AS Second,
    CONCAT(N'Plant', P.Id) AS [Second image name],
    'Pollinates' AS RelationshipType
FROM Insects AS I, Pollinates AS Pol, Plants AS P
WHERE MATCH(I-(Pol)->P)

UNION ALL

-- Все связи места обитания для насекомых
SELECT 
    I.Id AS IdFirst,
    I.Name AS First,
    CONCAT(N'Insect', I.Id) AS [First image name],
    H.Id AS IdSecond,
    H.Name AS Second,
    CONCAT(N'Habitat', H.Id) AS [Second image name],
    'LivesIn (Insect)' AS RelationshipType
FROM Insects AS I, LivesIn AS LI, Habitats AS H
WHERE MATCH(I-(LI)->H) AND LI.EntityType = 'insect'

UNION ALL

-- Все связи места обитания для растений
SELECT 
    P.Id AS IdFirst,
    P.Name AS First,
    CONCAT(N'Plant', P.Id) AS [First image name],
    H.Id AS IdSecond,
    H.Name AS Second,
    CONCAT(N'Habitat', H.Id) AS [Second image name],
    'LivesIn (Plant)' AS RelationshipType
FROM Plants AS P, LivesIn AS LI, Habitats AS H
WHERE MATCH(P-(LI)->H) AND LI.EntityType = 'plant'

UNION ALL

-- Все связи хищничества
SELECT 
    I1.Id AS IdFirst,
    I1.Name AS First,
    CONCAT(N'Insect', I1.Id) AS [First image name],
    I2.Id AS IdSecond,
    I2.Name AS Second,
    CONCAT(N'Insect', I2.Id) AS [Second image name],
    'Predates' AS RelationshipType
FROM Insects AS I1, Predates AS Pred, Insects AS I2
WHERE MATCH(I1-(Pred)->I2);
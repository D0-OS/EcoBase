-- ������ ����� ���� ������ (�� �������)
USE master;
Go
DROP DATABASE IF EXISTS EcoGraph;
Go
CREATE DATABASE EcoGraph;
Go 
USE EcoGraph;
Go

-- ���������
CREATE TABLE Insects (
    Id INT PRIMARY KEY,
    Name NVARCHAR(100),
    Type NVARCHAR(50)
) AS NODE;
GO

-- ��������
CREATE TABLE Plants (
    Id INT PRIMARY KEY,
    Name NVARCHAR(100),
    Family NVARCHAR(50)
) AS NODE;
GO

-- ����� ��������
CREATE TABLE Habitats (
    Id INT PRIMARY KEY,
    Name NVARCHAR(100),
    Humidity_Level NVARCHAR(50)
) AS NODE;
GO

-- ��������
CREATE TABLE Pollinates AS EDGE;
GO

-- ����� ��������
CREATE TABLE LivesIn (
    EntityType NVARCHAR(10) -- 'insect' ��� 'plant'
) AS EDGE;
GO

-- �����������
CREATE TABLE Predates AS EDGE;
GO

-- Insects
INSERT INTO Insects (Id, Name, Type) VALUES
(1, '����� ����������', '���������'),
(2, '�����', '���������'),
(3, '���-�����', '�������'),
(4, '������', '����������'),
(5, '������� �������', '���������'),
(6, '������', '����������'),
(7, '�������', '��������'),
(8, '��������', '������'),
(9, '���', '��������'),
(10, '�������', '������');

-- Plants
INSERT INTO Plants (Id, Name, Family) VALUES
(1, '�������', '��������'),
(2, '�����', '���������'),
(3, '������', '�������'),
(4, '���', '�������'),
(5, '���������', '��������'),
(6, '�������������', '��������'),
(7, '��������', '�����������'),
(8, '�������', '���������'),
(9, '����', '����������'),
(10, '����-���', '���������');

-- Habitats
INSERT INTO Habitats (Id, Name, Humidity_Level) VALUES
(1, '���', '�������'),
(2, '���', '���������'),
(3, '������', '�������'),
(4, '�������� ����', '�����'),
(5, '������', '���������'),
(6, '������ ����', '����������'),
(7, '�����', '�������'),
(8, '���', '�������������'),
(9, '������ ����', '����������'),
(10, '������ �����', '�������');

-- �������� (Pollinates)
INSERT INTO Pollinates ($from_id, $to_id) VALUES
((SELECT $node_id FROM Insects WHERE Name = '����� ����������'),
 (SELECT $node_id FROM Plants WHERE Name = '�������')),
((SELECT $node_id FROM Insects WHERE Name = '����� ����������'),
 (SELECT $node_id FROM Plants WHERE Name = '������')),
((SELECT $node_id FROM Insects WHERE Name = '�����'),
 (SELECT $node_id FROM Plants WHERE Name = '���')),
((SELECT $node_id FROM Insects WHERE Name = '������� �������'),
 (SELECT $node_id FROM Plants WHERE Name = '�������������')),
((SELECT $node_id FROM Insects WHERE Name = '������� �������'),
 (SELECT $node_id FROM Plants WHERE Name = '����')),
((SELECT $node_id FROM Insects WHERE Name = '�����'),
 (SELECT $node_id FROM Plants WHERE Name = '���������')),
((SELECT $node_id FROM Insects WHERE Name = '���'),
 (SELECT $node_id FROM Plants WHERE Name = '�������')),
((SELECT $node_id FROM Insects WHERE Name = '�������'),
 (SELECT $node_id FROM Plants WHERE Name = '����-���')),
((SELECT $node_id FROM Insects WHERE Name = '����� ����������'),
 (SELECT $node_id FROM Plants WHERE Name = '�����')),
((SELECT $node_id FROM Insects WHERE Name = '����� ����������'),
 (SELECT $node_id FROM Plants WHERE Name = '�������������'));

-- ����� �������� (LivesIn) ��� ���������
INSERT INTO LivesIn ($from_id, $to_id, EntityType) VALUES
((SELECT $node_id FROM Insects WHERE Name = '����� ����������'), (SELECT $node_id FROM Habitats WHERE Name = '���'), 'insect'),
((SELECT $node_id FROM Insects WHERE Name = '�����'), (SELECT $node_id FROM Habitats WHERE Name = '���'), 'insect'),
((SELECT $node_id FROM Insects WHERE Name = '���-�����'), (SELECT $node_id FROM Habitats WHERE Name = '���'), 'insect'),
((SELECT $node_id FROM Insects WHERE Name = '�������'), (SELECT $node_id FROM Habitats WHERE Name = '������ ����'), 'insect'),
((SELECT $node_id FROM Insects WHERE Name = '������'), (SELECT $node_id FROM Habitats WHERE Name = '������'), 'insect'),
((SELECT $node_id FROM Insects WHERE Name = '���'), (SELECT $node_id FROM Habitats WHERE Name = '���'), 'insect');

-- ����� �������� (LivesIn) ��� ��������
INSERT INTO LivesIn ($from_id, $to_id, EntityType) VALUES
((SELECT $node_id FROM Plants WHERE Name = '�������'), (SELECT $node_id FROM Habitats WHERE Name = '���'), 'plant'),
((SELECT $node_id FROM Plants WHERE Name = '������'), (SELECT $node_id FROM Habitats WHERE Name = '���'), 'plant'),
((SELECT $node_id FROM Plants WHERE Name = '���'), (SELECT $node_id FROM Habitats WHERE Name = '������'), 'plant'),
((SELECT $node_id FROM Plants WHERE Name = '�������'), (SELECT $node_id FROM Habitats WHERE Name = '���'), 'plant');

-- ����������� (Predates)
INSERT INTO Predates ($from_id, $to_id) VALUES
((SELECT $node_id FROM Insects WHERE Name = '�������'),
 (SELECT $node_id FROM Insects WHERE Name = '������')),
((SELECT $node_id FROM Insects WHERE Name = '�������'),
 (SELECT $node_id FROM Insects WHERE Name = '�������')),
((SELECT $node_id FROM Insects WHERE Name = '��������'),
 (SELECT $node_id FROM Insects WHERE Name = '���')),
((SELECT $node_id FROM Insects WHERE Name = '��������'),
 (SELECT $node_id FROM Insects WHERE Name = '�����'));

SELECT i.Name AS Insect
FROM Insects i, Pollinates p, Plants pl
WHERE MATCH(i-(p)->pl)
  AND pl.Name = '�������';

SELECT pl.Name AS Plant
FROM Insects i, Pollinates p, Plants pl
WHERE MATCH(i-(p)->pl)
  AND i.Name = '����� ����������';

SELECT i.Name AS Insect
FROM Insects i, LivesIn l, Habitats h
WHERE MATCH(i-(l)->h)
  AND h.Name = '���'
  AND l.EntityType = 'insect';

SELECT DISTINCT i.Name AS Insect
FROM Insects i, LivesIn li, Habitats h1,
     Plants p, LivesIn lp, Habitats h2
WHERE MATCH(i-(li)->h1 and p-(lp)->h2)
  AND h1.Id = h2.Id
  AND p.Name = '�������'
  AND li.EntityType = 'insect'
  AND lp.EntityType = 'plant';

SELECT predator.Name AS Predator
FROM Insects predator, Predates pr, Insects prey
WHERE MATCH(predator-(pr)->prey)
  AND prey.Name = '�������';


SELECT
    I.Name AS StartInsect,
    STRING_AGG(P.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS PathToPlants
FROM
    Insects AS I,
    Pollinates FOR PATH AS poll,
    Plants FOR PATH AS P
WHERE
    MATCH(SHORTEST_PATH(I(-(poll)->P)+))
    AND I.Name = '����� ����������';

SELECT
    Predator.Name AS Predator,
    STRING_AGG(Prey.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS PathToPrey
FROM
    Insects AS Predator,
    Predates FOR PATH AS pred,
    Insects FOR PATH AS Prey
WHERE
    MATCH(SHORTEST_PATH(Predator(-(pred)->Prey)+))
    AND Predator.Name = '�������';

SELECT
    P.Name AS Plant,
    STRING_AGG(H.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS PathToHabitats
FROM
    Plants AS P,
    LivesIn FOR PATH AS li,
    Habitats FOR PATH AS H
WHERE
    MATCH(SHORTEST_PATH(P(-(li)->H)+))
    AND P.Name = '�������';



--------------------------------------��� PowerBI--------------------------------------------------
--------------------------------------��������----------------------------------------------------

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

-------------------------------------�������������----------------------------------

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

--------------------------------------����������----------------------------------------

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

---------------------------------------��������-----------------------------------------

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

---------------------------------------����� ���������������-------------------------
--SELECT @@servername

--https://raw.githubusercontent.com/D0-OS/EcoBase/refs/heads/main/images/

-- ��� ����� ��������
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

-- ��� ����� ����� �������� ��� ���������
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

-- ��� ����� ����� �������� ��� ��������
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

-- ��� ����� �����������
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
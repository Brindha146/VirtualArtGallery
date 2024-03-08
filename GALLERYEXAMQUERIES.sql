--Coding Challenge SQL 
--Virtual Art Gallery Shema DDL and DML

--Create Database
CREATE DATABASE VisualArtGallery;

-- Create the Artists table 
CREATE TABLE Artists ( 
ArtistID INT PRIMARY KEY, 
Name VARCHAR(255) NOT NULL, 
Biography TEXT, 
Nationality VARCHAR(100));

-- Create the Categories table 
CREATE TABLE Categories ( 
CategoryID INT PRIMARY KEY, 
Name VARCHAR(100) NOT NULL); 

-- Create the Artworks table 
CREATE TABLE Artworks ( 
ArtworkID INT PRIMARY KEY, 
Title VARCHAR(255) NOT NULL, 
ArtistID INT, 
CategoryID INT, 
Year INT, 
Description TEXT, 
ImageURL VARCHAR(255), 
FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID), 
FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)); 

-- Create the Exhibitions table 
CREATE TABLE Exhibitions ( 
ExhibitionID INT PRIMARY KEY, 
Title VARCHAR(255) NOT NULL, 
StartDate DATE, 
EndDate DATE, 
Description VARCHAR(255)); 

-- Create a table to associate artworks with exhibitions 
CREATE TABLE ExhibitionArtworks ( 
ExhibitionID INT, 
ArtworkID INT, 
PRIMARY KEY (ExhibitionID, ArtworkID), 
FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID), 
FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));


--DML(Insert sample data to tables) 

-- Insert sample data into the Artists table 
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES 
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'), 
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'), 
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian'); 

-- Insert sample data into the Categories table 
INSERT INTO Categories (CategoryID, Name) VALUES 
(1, 'Painting'), 
(2, 'Sculpture'), 
(3, 'Photography'); 

-- Insert sample data into the Artworks table 
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES 
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'), 
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'), 
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso powerful anti-war mural.', 'guernica.jpg'); 

--Inserting new value
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES 
(4, 'The Man', 1, 2, 1749, 'A famous Sculpture by Pablo Picasso.', 'The_man.jpg');

INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES 
(5, 'Picturistique', 1, 3, 1949, 'A famous Picture by Pablo Picasso.', 'The_Pic.jpg');

INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES 
(6, 'Assignment', 3, 3, 2024, 'A famous Picture.', 'The_Assignment.jpg');

-- Insert sample data into the Exhibitions table 
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES 
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'), 
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.'); 

-- Insert artworks into exhibitions 
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES 
(1, 1), 
(1, 2), 
(1, 3), 
(2, 2); 

--Inserting new value
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES (1, 5),(1,4);

--Solve the below queries: 

--1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and 
--list them in descending order of the number of artworks. 
SELECT a.Name, COUNT(aw.ArtworkID) as ArtworksCount
FROM Artists a
LEFT JOIN Artworks aw ON a.ArtistID=aw.ArtistID
GROUP BY a.Name
ORDER BY ArtworksCount DESC;

--2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order 
--them by the year in ascending order. 
SELECT a.Title
FROM Artworks a
LEFT JOIN Artists at ON at.ArtistID=a.ArtistID
WHERE at.Nationality='Spanish' or at.Nationality='Dutch'
ORDER BY a.Year;

--3. Find the names of all artists who have artworks in the 'Painting' category, and the number of 
--artworks they have in this category.
SELECT a.Name, COUNT(aw.ArtworkID) as ArtworksCount
FROM Artists a
JOIN Artworks aw ON a.ArtistID=aw.ArtistID
JOIN Categories c ON c.CategoryID=aw.CategoryID
WHERE c.Name='Painting'
GROUP BY a.Name;

--4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their 
--artists and categories. 
SELECT a.Name, aw.Title, c.Name AS CategoryName
FROM Artists a
JOIN Artworks aw ON a.ArtistID=aw.ArtistID
JOIN Categories c ON c.CategoryID=aw.CategoryID
JOIN ExhibitionArtworks ea ON ea.ArtworkID=aw.ArtworkID
JOIN Exhibitions e ON e.ExhibitionID=ea.ExhibitionID
WHERE e.Title='Modern Art Masterpieces';

--5. Find the artists who have more than two artworks in the gallery. 
SELECT a.Name, COUNT(aw.ArtworkID) as ArtworksCount
FROM Artists a
LEFT JOIN Artworks aw ON a.ArtistID=aw.ArtistID
GROUP BY a.Name
HAVING COUNT(aw.ArtworkID)>2;

--6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions
SELECT DISTINCT aw.Title
FROM Artworks aw 
JOIN ExhibitionArtworks ea ON ea.ArtworkID=aw.ArtworkID
JOIN Exhibitions e ON e.ExhibitionID=ea.ExhibitionID
WHERE e.Title IN('Modern Art Masterpieces', 'Renaissance Art')
GROUP BY aw.Title
HAVING COUNT(e.Title)=2;

--7. Find the total number of artworks in each category 
SELECT c.Name, COUNT(a.ArtworkID) AS ArtworkCount
FROM Categories c
LEFT JOIN Artworks a ON c.CategoryID = a.CategoryID
GROUP BY c.Name;

--8. List artists who have more than 3 artworks in the gallery. 
SELECT a.Name
FROM Artists a
LEFT JOIN Artworks aw ON a.ArtistID=aw.ArtistID
GROUP BY a.Name
HAVING COUNT(aw.ArtworkID)>3;

--9. Find the artworks created by artists from a specific nationality (e.g., Spanish). 
SELECT at.Name,a.Title, at.Nationality
FROM Artworks a
LEFT JOIN Artists at ON at.ArtistID=a.ArtistID
WHERE at.Nationality='Spanish';

--10.  List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci. 
SELECT e.Title
FROM Artists a
JOIN Artworks aw ON a.ArtistID=aw.ArtistID
JOIN ExhibitionArtworks ea ON ea.ArtworkID=aw.ArtworkID
JOIN Exhibitions e ON e.ExhibitionID=ea.ExhibitionID
WHERE a.Name IN ('Vincent van Gogh', 'Leonardo da Vinci')
GROUP BY e.Title
HAVING COUNT(a.Name)=2;

--11. Find all the artworks that have not been included in any exhibition. 
SELECT a.Title, e.ArtworkID
FROM Artworks a
LEFT JOIN ExhibitionArtworks e ON e.ArtworkID=a.ArtworkID
WHERE e.ArtworkID IS NULL;

--12.  List artists who have created artworks in all available categories. 
SELECT a.Name
FROM Artists a
JOIN Artworks aw ON a.ArtistID=aw.ArtistID
JOIN Categories c ON c.CategoryID=aw.CategoryID
GROUP BY a.Name
HAVING COUNT(aw.CategoryID) = (SELECT COUNT(CategoryID) FROM Categories);

--13.  List the total number of artworks in each category. 
SELECT c.Name as CategoryName, COUNT(a.ArtworkID) AS ArtworkCount
FROM Categories c
LEFT JOIN Artworks a ON c.CategoryID = a.CategoryID
GROUP BY c.Name;

--14. Find the artists who have more than 2 artworks in the gallery. 
SELECT a.Name
FROM Artists a
LEFT JOIN Artworks aw ON a.ArtistID=aw.ArtistID
GROUP BY a.Name
HAVING COUNT(aw.ArtworkID)>2;

--15.  List the categories with the average year of artworks they contain, only for categories with more than 1 artwork. 
SELECT c.Name, AVG(a.Year) as AverageYear
FROM Categories c
JOIN Artworks a ON a.CategoryID=c.CategoryID
GROUP BY c.Name
HAVING COUNT(a.CategoryID)>1;

--16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition. 
SELECT aw.Title
FROM Artworks aw 
JOIN ExhibitionArtworks ea ON ea.ArtworkID=aw.ArtworkID
JOIN Exhibitions e ON e.ExhibitionID=ea.ExhibitionID
WHERE e.Title='Modern Art Masterpieces';

--17. Find the categories where the average year of artworks is greater than the average year of all artworks. 
SELECT c.Name
FROM Categories c
JOIN Artworks a ON c.CategoryID=a.CategoryID
GROUP BY c.Name
HAVING AVG(a.Year) > (SELECT AVG(YEAR) FROM Artworks);

--18. List the artworks that were not exhibited in any exhibition. 
SELECT a.Title
FROM Artworks a
LEFT JOIN ExhibitionArtworks e ON e.ArtworkID=a.ArtworkID
WHERE e.ArtworkID IS NULL;

--19. Show artists who have artworks in the same category as "Mona Lisa." 
SELECT a.Name, aw.Title
FROM Artists a
LEFT JOIN Artworks aw ON a.ArtistID=aw.ArtistID
LEft JOIN Categories c ON aw.CategoryID=c. CategoryID
WHERE c.CategoryID IN (SELECT c.CategoryID 
FROM Categories c
JOIN Artworks a ON a.CategoryID=c.CategoryID
WHERE a.Title='Mona Lisa');

--20.  List the names of artists and the number of artworks they have in the gallery.
SELECT a.Name, COUNT(aw.ArtworkID) as ArtworkCount
FROM Artists a
JOIN Artworks aw ON aw.ArtistID=a.ArtistID
GROUP BY a.Name;

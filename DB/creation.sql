CREATE DATABASE TODO

CREATE TABLE Users(
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	Logn VARCHAR(20),
	Pass VARCHAR(20) 
)

CREATE TABLE Channels(
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	U_ID INT FOREIGN KEY REFERENCES Users(ID) ON DELETE CASCADE,
	CName VARCHAR(20)
)

CREATE TABLE Tasks(
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	C_ID INT FOREIGN KEY REFERENCES Channels(ID) ON DELETE CASCADE,
	Task VARCHAR(20)
)
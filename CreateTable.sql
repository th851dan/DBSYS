/*-----------------Zug----------------------------*/
CREATE TABLE Zug
( zug_Nr             INT PRIMARY KEY,
  zug_Name           VARCHAR2(30) NOT NULL
);

/*-----------------Wagen----------------------------*/
CREATE TABLE Wagen
( wag_Id             INT PRIMARY KEY,
  wag_Nr             INT NOT NULL,
  wag_Restaurant     NUMBER(1) NOT NULL,
  wag_Sitze          INT NOT NULL CHECK(wag_Sitze > 0),
  wag_Klasse         VARCHAR2(1) NOT NULL,
  zug_Nr             INT NOT NULL,
  CONSTRAINT fk_zugNr FOREIGN KEY (zug_Nr) REFERENCES Zug(zug_Nr) ON DELETE CASCADE
);
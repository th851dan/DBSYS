/*-----------------Land----------------------------*/
CREATE TABLE Land
( land_Name             VARCHAR2(15) NOT NULL PRIMARY KEY
);

/*-----------------Ausstattung----------------------------*/
CREATE TABLE Ausstattung
( aus_Name              VARCHAR2(20) NOT NULL PRIMARY KEY
);

/*-----------------Tat(Touristenattraktion)----------------------------*/
CREATE TABLE Tat
( tat_Name              VARCHAR2(30) NOT NULL PRIMARY KEY,
  tat_Beschreibung      VARCHAR2(300) NOT NULL
);

/*-----------------Kunde----------------------------*/
CREATE TABLE Kunde
( kun_Ma                VARCHAR2(30) NOT NULL PRIMARY KEY,
  kun_Name              VARCHAR2(15) NOT NULL,
  kun_Vorname           VARCHAR2(15) NOT NULL,
  kun_Iban              CHAR(22) NOT NULL,
  kun_Plz               CHAR(5) NOT NULL,
  kun_Stadt             VARCHAR2(20) NOT NULL,
  kun_Strasse           VARCHAR2(29) NOT NULL,
  land_Name             VARCHAR2(15) NOT NULL,
  CONSTRAINT fk_landName FOREIGN KEY (land_Name) REFERENCES Land(land_Name) ON DELETE CASCADE
);


/*-----------------Fw(Ferienwohung)----------------------------*/
CREATE TABLE Fw
( fw_Name               VARCHAR2(20) NOT NULL PRIMARY KEY,
  fw_Anz                INT NOT NULL CHECK (fw_Anz > 0),
  fw_Gr                 INT NOT NULL CHECK (fw_Gr > 0),
  fw_Preis              FLOAT NOT NULL CHECK (fw_Preis > 0),
  im_Land               VARCHAR2(15) NOT NULL,
  fw_Plz               CHAR(5) NOT NULL,
  fw_Stadt             VARCHAR2(20) NOT NULL,
  fw_Strasse           VARCHAR2(29) NOT NULL,
  CONSTRAINT fk_imLand FOREIGN KEY (im_Land) REFERENCES Land(land_Name) ON DELETE CASCADE
);

/*-----------------Buchung----------------------------*/
CREATE TABLE Buchung
( buc_Bnr               INT NOT NULL PRIMARY KEY CHECK (buc_Bnr > 0),
  buc_Bdt               DATE NOT NULL,
  buc_von               DATE NOT NULL,
  buc_bis               DATE NOT NULL,
  kun_Ma                VARCHAR2(30) NOT NULL,
  fw_Fwn                VARCHAR2(20) NOT NULL,
  buc_Bwnr              INT CHECK (buc_Bwnr > 0),
  buc_Datum             DATE,      /*------Datum der Bewertung------*/
  buc_Sterne            INT CHECK (buc_Sterne > 0 AND buc_Sterne < 6),
  buc_Kommentar         VARCHAR2(100),
  CONSTRAINT fk_kunMa FOREIGN KEY (kun_Ma) REFERENCES Kunde(kun_Ma) ON DELETE CASCADE,
  CONSTRAINT fk_fwFwn FOREIGN KEY (fw_Fwn) REFERENCES Fw(fw_Name) ON DELETE CASCADE
);


/*-----------------Bild----------------------------*/
CREATE TABLE Bild
( bil_Bnr               INT NOT NULL PRIMARY KEY CHECK (bil_Bnr > 0),
  fw_Name               VARCHAR2(20) NOT NULL,
  CONSTRAINT fk_fwName FOREIGN KEY (fw_Name) REFERENCES Fw(fw_Name) ON DELETE CASCADE
);





/*-----------------idN(in der Nähe)----------------------------*/
CREATE TABLE idN
( fw_Fwn                VARCHAR2(20) NOT NULL,
  tat_Name              VARCHAR2(30) NOT NULL,
  CONSTRAINT pk_idN PRIMARY KEY (fw_Fwn, tat_Name),
  CONSTRAINT fk_idN_fwFwn FOREIGN KEY (fw_Fwn) REFERENCES Fw(fw_Name) ON DELETE CASCADE,
  CONSTRAINT fk_idN_tatName FOREIGN KEY (tat_Name) REFERENCES Tat(tat_Name) ON DELETE CASCADE
);
/*-----------------wa(wird ausgestattet)----------------------------*/
CREATE TABLE wa
( fw_Fwn                VARCHAR2(20) NOT NULL,
  aus_Name              VARCHAR2(20) NOT NULL,
  CONSTRAINT pk_wa PRIMARY KEY (fw_Fwn, aus_Name),
  CONSTRAINT fk_wa_fwFwn FOREIGN KEY (fw_Fwn) REFERENCES Fw(fw_Name) ON DELETE CASCADE,
  CONSTRAINT fk_wa_ausName FOREIGN KEY (aus_Name) REFERENCES Ausstattung(aus_Name) ON DELETE CASCADE
);

/*-----------------Rechnung----------------------------*/
CREATE TABLE Rechnung
( rec_Rnr               INT NOT NULL PRIMARY KEY CHECK (rec_Rnr > 0),
  buc_Bnr               INT NOT NULL,
  rec_Betrag            FLOAT NOT NULL CHECK (rec_Betrag >= 0),
  rec_Datum             DATE NOT NULL,
  CONSTRAINT fk_rec_bucBnr FOREIGN KEY (buc_Bnr) REFERENCES Buchung(buc_Bnr) ON DELETE CASCADE
);

/*-----------------Anzahlung----------------------------*/
CREATE TABLE Anzahlung
( anz_Nr                INT NOT NULL PRIMARY KEY CHECK (anz_Nr > 0),
  rec_Rnr               INT NOT NULL,
  rec_Betrag            FLOAT NOT NULL CHECK (rec_Betrag >= 0),
  rec_Datum             DATE NOT NULL,
  CONSTRAINT fk_anz_recRnr FOREIGN KEY (rec_Rnr) REFERENCES Rechnung(rec_Rnr) ON DELETE CASCADE
);


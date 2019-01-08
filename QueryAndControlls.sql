/*-----------------Controlls----------------------------*/

commit;
rollback;

GRANT SELECT ON Fw TO dbsys70;
GRANT SELECT ON Buchung TO dbsys70;
GRANT SELECT ON Fw_4Stern TO dbsys70;
GRANT SELECT ON Spa4 TO dbsys70;
GRANT SELECT ON Fw_Anzaus TO dbsys70;
GRANT SELECT ON Land_Fw TO dbsys70;
GRANT SELECT ON Land TO dbsys70;
GRANT SELECT ON Land_Anz TO dbsys70;
GRANT SELECT ON wa TO dbsys70;



/*------------Fw---------------------*/
SELECT fw_Stadt,COUNT(*) as Anzahl_Fw FROM dbsys13.Fw
GROUP BY fw_Stadt;
/*------------Buchung-----------------*/
CREATE OR REPLACE VIEW Fw_4Stern AS
SELECT fw_Fwn, AVG(buc_Sterne) AS Sterne  FROM Buchung
GROUP BY fw_Fwn
HAVING AVG(buc_Sterne) > 4;

SELECT * FROM dbsys13.Fw_4Stern;

SELECT fw_Name from Fw;
CREATE OR REPLACE VIEW Spa4 AS
SELECT f.fw_Name, s.Sterne FROM Fw f, Fw_4Stern s
WHERE f.fw_Name = s.fw_Fwn AND f.im_Land = 'Spanien';

SELECT * FROM dbsys13.Spa4;
/*------------Fw hat die meinsten Ausstattung-----------------*/
CREATE OR REPLACE VIEW Fw_Anzaus AS
SELECT fw_Fwn , COUNT(aus_Name) as Anz
FROM wa
GROUP BY fw_Fwn;

SELECT fw_Fwn FROM dbsys13.Fw_Anzaus
WHERE Anz = (SELECT MAX(Anz) FROM dbsys13.Fw_Anzaus);

/*------------Reservierung pro einzelnes Land -----------------*/
CREATE OR REPLACE VIEW Land_Fw(Land,Fw) AS
SELECT l.land_Name , COUNT(f.fw_Name)
FROM Land l LEFT OUTER JOIN Fw f ON l.land_Name = f.im_Land LEFT OUTER JOIN Buchung b ON b.fw_Fwn = f.fw_Name
WHERE SYSDATE < b.buc_von
GROUP BY l.land_Name;

SELECT land_Name,NVL(Anz,0) AS Anzahl
FROM dbsys13.Land LEFT OUTER JOIN dbsys13.Land_Anz ON land_Name = Land
ORDER BY Anzahl DESC;

CREATE OR REPLACE VIEW Land_Anz(Land,Anz) AS
SELECT f.im_Land,COUNT(*)
FROM Fw f , Buchung b
WHERE f.fw_Name = b.fw_Fwn
AND SYSDATE < b.buc_von
GROUP BY f.im_Land;


/*------------Fw noch frei-----------------*/
SELECT f.fw_Name , AVG(b.buc_Sterne) as Bewertung
FROM dbsys13.Fw f LEFT OUTER JOIN dbsys13.Buchung b ON f.fw_Name = b.fw_Fwn INNER JOIN dbsys13.wa ON f.fw_Name = wa.fw_Fwn
WHERE f.fw_Name != ANY(SELECT fw_Fwn FROM dbsys13.Buchung b
                        WHERE (b.buc_von BETWEEN '2018-11-01' AND '2018-11-21') OR (b.buc_bis BETWEEN '2018-11-01' AND '2018-11-21') OR (b.buc_von < '2018-11-01' AND b.buc_bis > '2018-11-21'))
AND wa.aus_Name = 'Sauna' AND f.im_land = 'Spanien' 
GROUP BY f.fw_Name
ORDER BY Bewertung DESC;



SELECT f.fw_Name, NVL(AVG(b.buc_Sterne),0) as Bewertung
FROM Fw f LEFT OUTER JOIN Buchung b ON f.fw_Name = b.fw_Fwn
WHERE ((b.buc_von NOT BETWEEN '2018-11-01' AND '2018-11-21') AND (b.buc_bis NOT BETWEEN '2018-11-01' AND '2018-11-21')) OR (b.buc_von = NULL)
GROUP BY f.fw_Name
ORDER BY Bewertung DESC;



/*----------------stonierte Buchung----------*/

DELETE FROM Buchung WHERE Buchung.buc_Bnr = 7 OR Buchung.buc_Bnr = 8;

SELECT * FROM Storno;

/*-----------Kundenstatistik--------*/

CREATE OR REPLACE VIEW KundID(KundenID, Email) AS
SELECT rownum, kun_Ma
FROM Kunde;

CREATE OR REPLACE VIEW KundenBuchung(KundenId, AnzBuchung) AS
SELECT k.KundenID, COUNT(*)
FROM  KunID k , Buchung b 
WHERE k.Email = b.kun_Ma
GROUP BY k.KundenID;

CREATE OR REPLACE VIEW KundenStorno(KundenId, AnzStorno) AS
SELECT k.KundenID, COUNT(*)
FROM  KunID k , Storno s 
WHERE k.Email = s.kun_Ma
GROUP BY k.KundenID;

SELECT k.KundenID, COUNT(*)
FROM  KunID k , Storno s 
WHERE k.Email = s.kun_Ma
GROUP BY k.KundenID;


--CREATE OR REPLACE VIEW GezahltPerRec(RecNr, Summe) AS
--SELECT r.rec_Rnr, SUM(a.anz_Betrag)
--FROM Rechnung r, Anzahlung a
--WHERE r.rec_Rnr = a.rec_Rnr
--GROUP BY r.rec_Rnr;

CREATE OR REPLACE VIEW GezahltProBuc(BucNr, Summe) AS
SELECT b.buc_Bnr, SUM(a.anz_Betrag)
FROM Buchung b, Anzahlung a
WHERE a.rec_Rnr = (SELECT r.rec_Rnr FROM Rechnung r
                    WHERE r.buc_Bnr = b.buc_Bnr)
GROUP BY b.buc_Bnr;

--CREATE OR REPLACE VIEW GezahltProMail(Email, Summe) AS
--SELECT b.kun_Ma, Sum(g.Summe)
--FROM Buchung b, GezahltProBuc g
--WHERE g.BucNr = b.buc_Bnr
--GROUP BY b.kun_Ma;

CREATE OR REPLACE VIEW GezahltProId(KundenId, Summe) AS
SELECT k.KundenId, Sum(g.Summe)
FROM KundId k, GezahltProBuc g
WHERE g.BucNr = ANY(SELECT b.buc_Bnr
                  FROM Buchung b
                  WHERE b.kun_Ma = k.Email)
GROUP BY k.KundenId;

SELECT k.KundenId, COUNT(DISTINCT b.buc_Bnr), SUM(a.anz_Betrag)
FROM KundId k,  Buchung b, Anzahlung a
WHERE k.Email = b.kun_Ma AND b.buc_Bnr = ANY(SELECT r.buc_Bnr
                                             FROM Rechnung r
                                             WHERE r.rec_Rnr = a.rec_Rnr)
GROUP BY k.KundenId;

CREATE OR REPLACE VIEW KundenStatistik(KundenId, AnzBuchung, AnzStorno, Summe) AS
SELECT k.KundenID, NVL(b.AnzBuchung, 0), NVL(s.AnzStorno,0), NVL(g.Summe,0)
FROM KundID k LEFT OUTER JOIN KundenBuchung b ON k.KundenID = b.KundenID 
               LEFT OUTER JOIN KundenStorno s ON k.KundenID = s.KundenID
               LEFT OUTER JOIN GezahltProId g ON k.KundenID = g.KundenID
ORDER BY k.kundenID ASC;

SELECT * FROM KundenStatistik;

SELECT * FROM KundID;
SELECT k.KundenID, NVL(b.AnzBuchung, 0) AS AnzBuchung, NVL(s.AnzStorno,0) AS AnzStorno, NVL(g.Summe,0) AS Summe
FROM KundID k LEFT OUTER JOIN KundenBuchung b ON k.KundenID = b.KundenID 
               LEFT OUTER JOIN KundenStorno s ON k.KundenID = s.KundenID
               LEFT OUTER JOIN GezahltProId g ON k.KundenID = g.KundenID
ORDER BY k.kundenID ASC;
SELECT * FROM KundenBuchung;
SELECT * FROM KundenStorno;
SELECT * FROM KundenStatistik;

SELECT * FROM Rechnung;
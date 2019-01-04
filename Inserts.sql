/*-----------------Land-----------------*/
INSERT INTO Land VALUES ('Spanien');
INSERT INTO LAND VALUES ('Deutschland');
INSERT INTO LAND VALUES ('Italien');

/*-----------------Fw-----------------*/
INSERT INTO Fw VALUES ('Fw1',4,121,300.0,'Spanien','02620','Minaya','Calle Grande');
INSERT INTO Fw VALUES ('Fw2',6,200,500.0,'Spanien','02630','Minaya','Calle Estudio');
INSERT INTO Fw VALUES ('Fw3',5,225,600.0,'Deutschland','78464','Konstanz','Seestrasse');
INSERT INTO Fw VALUES ('Fw4',5,225,600.0,'Deutschland','78464','Konstanz','Rheingutstrasse');
INSERT INTO Fw VALUES ('Fw5',5,225,600.0,'Spanien','78464','Konstanz','Rheingutstrasse');
/*-----------------Kunde------------*/
INSERT INTO Kunde VALUES('kun1@gmail.com','Müller','Thomas','DE32451254784521458745','78462','Konstanz','Rheingutstraße','Deutschland');
INSERT INTO Kunde VALUES('kun2@gmail.com','Han','Jungs','DE25415456987452145742','78467','Konstanz','Cherisy-Straße','Deutschland');
INSERT INTO Kunde VALUES('kun3@gmail.com','Müller','Jan','DE25145784562545125487','78315','Radolfzell','Alemannenstraße','Deutschland');
/*-----------------Buchung------------*/
alter session set NLS_DATE_FORMAT='YYYY-MM-DD';
INSERT INTO Buchung VALUES(1,'2017-10-11','2017-12-01','2017-12-10','kun1@gmail.com','Fw1',1,'2017-12-15',4,'gut');
INSERT INTO Buchung VALUES(2,'2018-02-05','2018-02-15','2018-02-28','kun2@gmail.com','Fw2',2,'2018-03-25',5,'sehr gut');
INSERT INTO Buchung VALUES(3,'2018-05-05','2018-05-15','2018-05-20','kun3@gmail.com','Fw1',3,'2018-06-20',5,'prima');
INSERT INTO Buchung VALUES(4,'2018-04-02','2018-11-15','2018-11-20','kun2@gmail.com','Fw2',4,'2018-05-25',5,'perfekt');
INSERT INTO Buchung VALUES(5,'2019-01-11','2019-01-20','2019-02-10','kun1@gmail.com','Fw1',NULL,NULL,NULL,NULL);
INSERT INTO Buchung VALUES(6,'2019-05-10','2019-05-20','2019-05-12','kun2@gmail.com','Fw2',NULL,NULL,NULL,NULL);
INSERT INTO Buchung VALUES(7,'2019-11-10','2019-11-11','2019-11-15','kun3@gmail.com','Fw1',NULL,NULL,NULL,NULL);
INSERT INTO Buchung VALUES(8,'2019-12-10','2019-12-11','2019-12-15','kun3@gmail.com','Fw3',NULL,NULL,NULL,NULL);

INSERT INTO Ausstattung VALUES('Sauna');
INSERT INTO Ausstattung VALUES('Balkon');
INSERT INTO Ausstattung VALUES('Schwimmbad');

INSERT INTO wa VALUES('Fw1','Sauna');
INSERT INTO wa VALUES('Fw1','Balkon');
INSERT INTO wa VALUES('Fw2','Sauna');
INSERT INTO wa VALUES('Fw2','Schwimmbad');
INSERT INTO wa VALUES('Fw3','Sauna');
INSERT INTO wa VALUES('Fw5','Sauna');



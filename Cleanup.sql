
drop table Kunde cascade constraints;
drop table Land cascade constraints;
drop table Buchung cascade constraints;
drop table Fw cascade constraints;
drop table Bild cascade constraints;
drop table Ausstattung cascade constraints;
drop table Tat cascade constraints;
drop table idN cascade constraints;
drop table wa cascade constraints;
drop table Rechnung cascade constraints;
drop table Anzahlung cascade constraints;


/* Quasi "Papierkorb leehren" */
purge recyclebin;
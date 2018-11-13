/*-----------------Controlls----------------------------*/

commit;
rollback;

/*-----------------Zug-------------------------------------*/

SELECT * FROM Zug;
SELECT * FROM Zug WHERE zug_Name = 'Thomas';

/* simple join */
SELECT * FROM Zug z, Wagen w
WHERE z.zug_Nr = w.zug_Nr;



/*-----------------On Delete Cascade-----------------------*/

SELECT * FROM Zug;
SELECT * FROM Wagen;
delete from Zug WHERE zug_Nr = 1;
SELECT * FROM Zug;
SELECT * FROM Wagen;
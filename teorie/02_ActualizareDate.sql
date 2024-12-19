-- ----------------------------------------
-- ---------- ACTUALIZARE TABELE
-- ----------------------------------------
-- 
--    INSERT - adauga o noua inregistrare in tabela
--    UPDATE - modificarea valorilor unor inregistrari din tabela
--    DELETE - stergere inregistrari
--    MERGE - actualizare inregistrari in functie de anumite conditii
--    SELECT - gaseste inregistrari
-- ## Sa creeze tabela salariati pe baza tabelei angajati fara a prelua si inregistrarile (doar structura) si sa se adauge un nou angajat
CREATE TABLE salariati AS
SELECT *
FROM angajati
WHERE 2 = 3;
INSERT INTO salariati (id_angajat, nume, salariul)
VALUES (207, 'Ionescu', 4000);
INSERT INTO salariati (id_angajat, nume, salariul)
VALUES (207, 'Poppescu', 4200);
SELECT *
FROM salariati;
-- ## Sa se adauge in tabela salariati toti angajatii din tabela angajati care lucreaza in departamentele 20, 30 si 50. Si sa se finalizeze tranzactia (salvarea modificarii).
INSERT INTO salariati
SELECT *
FROM angajati
WHERE id_departament IN (20, 30, 50);
SELECT *
FROM salariati;
COMMIT;
-- ## Sa se adauge in tabela salariati un angajat ale carui date sunt introduse de utilizator de la tastatura
INSERT INTO salariati (id_angajat, nume, data_angajare, salariul)
VALUES (
    '&id_angajat',
    '&nume',
    TO_DATE ('&data_angajare', 'mon dd, yyyy'),
    '&salariul'
  );
-- Atentie! Pentru data_angajare  se va utiliza functia de conversie TO_DATE.
-- Ex: TO_DATE('jan 20, 2005','mon dd, yyyy')
-- ## Sa se creasca cu 100 salariul angajatilor din tabela salariati care au salariul mai mic decat 3000: 
UPDATE salariati
SET salariul = salariul + 100
WHERE salariul < 3000
  AND comision IS NULL;
SELECT *
FROM salariati;
-- ## Sa se actualizeze salariul angajatilor al caror manager are id = 122 cu salariul angajatului cu id = 125
UPDATE salariati
SET salariul = (
    SELECT salariul
    FROM salariati
    WHERE id_angajat = 125
  )
WHERE id_manager = 122;
-- ## Sa se actualizeze salariul si comisionul angajatilor din tabela salariati cu salariul si comisionul anagajatului cu id_angajat = 167 din tabela angajati, doar pentru angajatii care au salariul mai mic decat salariul angajatului cu id = 173 din tabela angajati si care lucreaza in departamentul 50
UPDATE salariati
SET (salariul, comision) = (
    SELECT salariul,
      comision
    FROM angajati
    WHERE id_angajat = 167
  )
WHERE salariul < (
    SELECT salariul
    from angajati
    WHERE id_angajat = 173
  )
  AND id_departament = 50;
-- ## Sa se stearga angajatii din tabela salariati care au id_manager egal cu 122 sau 123
DELETE FROM salariati
WHERE id_manager IN (122, 123);
-- ## Sa se sterga angajatii din tabela salariati angajati inainte de anul 1999
DELETE FROM salariati
WHERE data_angajare < TO_DATE ('01-01-1999', 'DD-MM-YYYY');
-- ## Sa se sterga toti angajatii din tabela salariati. Sa se anuleze tranzactia
DELETE FROM salariati;
SELECT *
FROM salariati;
ROLLBACK;
SELECT *
FROM salariati;
-- ## Sa se actualizeze tabela salariati astfel incat toti salariatii din tabela salariati sa aiba salariile egale cu cei din tabela angajati, iar pentru cei care nu sunt in tabela salariati sa se adauge valorile coloanelor (id_angajat, nume, salariul) din tabela sursa agajati. Sa se numere inregistrarile din cele doua tabele si sa se explice diferenta. Sa se finalizeze tranzactia.
MERGE INTO salariati USING angajati ON (salariati.id_angajat = angajati.id_angajat)
WHEN MATCHED THEN
UPDATE
SET salariati.salariul = angajati.salariul
  WHEN NOT MATCHED THEN
INSERT (id_angajat, nume, salariul)
VALUES (
    angajati.id_angajat,
    angajati.nume,
    angajati.salariul
  );
SELECT COUNT(*)
FROM salariati;
SELECT COUNT(*)
FROM angajati;
COMMIT;
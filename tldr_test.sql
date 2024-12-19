-- afisare structura tabela
DESCRIBE nume_tabela;
-- modificare nume tabela
RENAME old_name TO new_name;
-- definire tabela si constraints
CREATE TABLE nume_tabela(
  nume_camp NUMBER(2) CONSTRAINT nume_constraint PRIMARY KEY
);
-- fk
CONSTRAINT FK_agenti FOREIGN KEY (codfirma) REFERENCES firme (codfirma);
-- definire in raport cu alta tabela
CREATE TABLE nume_tabela AS
SELECT nume_coloane
FROM tabela_provenienta;
-- adaugare coloane din alta tabela
INSERT INTO Dep (ID, Denumire)
SELECT id_departament,
  denumire_departament
FROM Departamente;
-- adaugare valori
INSERT INTO tabela
VALUES ();
-- adauga coloana
ALTER TABLE personal
ADD (email VARCHAR2 (10), varsta NUMBER (2));
-- modifica coloana
ALTER TABLE personal
MODIFY (email VARCHAR2 (30));
-- stergere coloana
ALTER TABLE personal DROP COLUMN email;
-- adaugare restrictie
ALTER TABLE personal
ADD CONSTRAINT check_varsta CHECK (
    varsta > 18
    AND varsta < 60
  );
-- ## dezactivare restrictie
ALTER TABLE personal DISABLE CONSTRAINT check_varsta;
-- ## stergere restrictie
ALTER TABLE personal DROP CONSTRAINT check_varsta;
-- modificare valoare tabela
UPDATE salariati
SET Prenume = 'John'
WHERE id_angajat = 3;
-- stergere valori din tabela
DELETE FROM salariati
WHERE id_angajat = 1;
-- SUBSTR
WHERE SUBSTR(camp, de unde, cat) = 'valoare';
-- CASE
(
  CASE
    WHEN ceva THEN valoare
    ELSE fallback_value
  END
) as discount;
-- DATE MANIPULATION
EXTRACT (
  YEAR
  FROM date
) = 1999;
-- comparatie
AND ist.data_sfarsit <= TO_DATE('1999-12-31', 'YYYY-MM-DD');
-- arbore
-- daca are subordonati
SELECT LEVEL;
CONNECT BY PRIOR a.id_angajat = a.id_manager START WITH a.id_angajat = 100;
-- leaf
SELECT CONNECT_BY_ISLEAF,
  LEVEL;
CONNECT BY PRIOR a.id_angajat = a.id_manager START WITH a.id_angajat = 100;
--    stergere definitiva
DROP TABLE nume_tabela PURGE;
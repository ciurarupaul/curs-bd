-- ---------------------------------------------
-- exercitii - sem 4 - LDD + LMD
-- ---------------------------------------------
-- creare tabela
CREATE TABLE Dep (
  ID NUMBER (7) CONSTRAINT PKey_Dep PRIMARY KEY,
  Denumire VARCHAR2 (25)
);
-- afisare pe ecran structura tabelei Departamente
DESCRIBE Departamente;
-- introducere in Dep inregistrari din Departamente, incluzand campurile id_departament si denumire_departament
INSERT INTO Dep (ID, Denumire)
SELECT id_departament,
  denumire_departament
FROM Departamente;
-- creare tabela Ang
CREATE TABLE Ang (
  ID NUMBER (7) CONSTRAINT PKey_Ang PRIMARY KEY,
  Prenume VARCHAR2 (25),
  Nume VARCHAR2 (25),
  Dep_ID NUMBER (7),
  CONSTRAINT FKey_Ang FOREIGN KEY (Dep_ID) REFERENCES Dep (ID)
);
--  adaugare coloana 'Varsta' in Ang
ALTER TABLE Ang
ADD (varsta NUMBER (2));
-- restrictie 'Verifica_varsta' in Ang >=18 && <=65
ALTER TABLE Ang
ADD CONSTRAINT Verifica_varsta CHECK (
    varsta >= 18
    AND varsta <= 65
  );
-- dezactivare Verificare_varsta
ALTER TABLE Ang DISABLE CONSTRAINT Verifica_varsta;
-- modificare camp Nume
ALTER TABLE Ang
MODIFY (Nume VARCHAR2 (30));
-- modificare nume tabela
RENAME Ang TO Ang2;
-- creare tabela Salariati, preluand toate inregistrarile din Angajati
CREATE TABLE Salariati AS
SELECT *
FROM Angajati;
DESCRIBE Salariati;
-- adaugare inregistrari in salariati
INSERT INTO Salariati (
    id_angajat,
    prenume,
    nume,
    email,
    telefon,
    data_angajare,
    id_functie,
    salariul,
    comision,
    id_manager,
    id_departament
  )
VALUES (
    1,
    'Steven',
    'Kong',
    'SKONG',
    '5151234567',
    TO_DATE ('1987-06-17', 'YYYY-MM-DD'),
    'AD_PRES',
    24000,
    0.1,
    NULL,
    90
  );
INSERT INTO Salariati (
    id_angajat,
    prenume,
    nume,
    email,
    telefon,
    data_angajare,
    id_functie,
    salariul,
    comision,
    id_manager,
    id_departament
  )
VALUES (
    2,
    'Neena',
    'Koch',
    'NKOCH',
    '5151234568',
    TO_DATE ('1989-09-21', 'YYYY-MM-DD'),
    'AD_VP',
    17000,
    0.1,
    100,
    90
  );
-- modificare nume angajat cu id 3
UPDATE salariati
SET Prenume = 'John'
WHERE id_angajat = 3;
-- modificare mail
UPDATE salariati
SET email = 'JHAAN'
WHERE id_angajat = 3;
-- crestere cu 10% salariul angajatilor cu salariul curent < 20.000
UPDATE salariati
SET salariul = 1.1 * salariul
WHERE salariul < 20000;
-- modificare cod functie
UPDATE salariati
SET id_functie = 'AD_PRES'
WHERE id_angajat = 2;
-- modificare camp in valoarea altui camp din aceeasi tabela si alta inregistrare
UPDATE salariati
SET comision = (
    SELECT comision
    FROM salariati
    WHERE id_angajat = 3
  )
WHERE id_angajat = 2;
-- sterge angajat cu id = 1
DELETE FROM salariati
WHERE id_angajat = 1;
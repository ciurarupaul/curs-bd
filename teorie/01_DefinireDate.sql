-- *********************************
-- Manipulare TABELE -- LDD 
-- *********************************
-- 
-- ----------------------------------------
-- ---------- CREARE TABELE
-- ----------------------------------------
-- 
-- ## Sa se creeze tabela firme si tabela agenti in care sa fie precizate restrictiile de integritate.
CREATE TABLE firme (
  codfirma NUMBER (2) CONSTRAINT PKey_firme PRIMARY KEY,
  denfirma VARCHAR2 (20) NOT NULL,
  loc VARCHAR2 (20),
  zona VARCHAR2 (15) CONSTRAINT FZONA_CK check (
    zona IN (
      'Moldova',
      'Ardeal',
      'Banat',
      'Muntenia',
      'Dobrogea',
      'Transilvania'
    )
  )
);
CREATE TABLE agenti (
  codagent VARCHAR2 (3) CONSTRAINT pk_agent PRIMARY KEY,
  numeagent VARCHAR2 (25) NOT NULL,
  dataang DATE DEFAULT SYSDATE,
  datanast DATE,
  functia VARCHAR2 (20),
  codfirma NUMBER (2),
  CONSTRAINT FK_agenti FOREIGN KEY (codfirma) REFERENCES firme (codfirma)
);
-- ## Sa se creeze tabela fosti_agenti pe baza tabelei agenti si care va contine doar o parte din coloanele tabelei initiale (codagent, numeagent, functia, codfirma)
CREATE TABLE fosti_agenti AS
SELECT codagent,
  numeagent,
  functia,
  codfirma
FROM agenti;
-- ----------------------------------------
-- ---------- MODIFICARE TABELE
-- ----------------------------------------
-- 
--    modificare structura tabela;
--        ADD nume_coloana;
--        MODIFY nume_coloana tip_data;
--        DROP COLUMN nume_coloana;
--        SET UNUSED - inactivare coloana;
-- 
--    modificare restrictii tabela
--        ADD CONSTRAINT nume_restrictie tip_restrictie;
--        MODIFY CONSTRAINT nume_restrictie tip_nou_restrictie;
--        DROP CONSTRAINT nume_restrictie;
--        DISABLE/ENABLE CONSTRAINT nume_restrictie;
-- 
--    redenumire tabela
--        ALTER TABLE nume_tabela RENAME TO nume_nou_tabela;
--        RENAME nume_tabela TO nume_nou_tabela;
-- ## Sa se redenumeasca tabela agenti cu personal 
ALTER TABLE agenti
  RENAME TO personal;
-- sau
RENAME agenti TO personal;
-- ## Sa se adauge coloanele email si varsta in tabela personal 
ALTER TABLE personal
ADD (email VARCHAR2 (10), varsta NUMBER (2));
-- ## Sa se modifice tipul de date al coloanei email 
ALTER TABLE personal
MODIFY (email VARCHAR2 (30));
-- ## Sa se stearga coloana email 
ALTER TABLE personal DROP COLUMN email;
-- ## Sa se inactiveze coloana functia
ALTER TABLE personal
SET UNUSED COLUMN functia;
-- ## Sa se stearga coloanele inactive
ALTER TABLE personal DROP UNUSED COLUMNS;
-- ## Sa se adauge o restrictie pe coloana varsta
ALTER TABLE personal
ADD CONSTRAINT check_varsta CHECK (
    varsta > 18
    AND varsta < 60
  );
-- ## Sa se dezactiveze restrictia anterioara
ALTER TABLE personal DISABLE CONSTRAINT check_varsta;
-- ## Sa se stearga restrictia anterioara
ALTER TABLE personal DROP CONSTRAINT check_varsta;
-- ----------------------------------------
-- ---------- STERGERE TABELE
-- ----------------------------------------
-- 
--    permite stergerea tabelei, inclusiv restrictiile acesteia -- cu posibilitate de recuperare
--        DROP TABLE nume_tabela [CASCADE CONSTRAINTS];
--        FLASHBACK TABLE nume_tabela TO BEFORE DROP;
-- 
--    stergere definitiva
--        DROP TABLE nume_tabela PURGE;
-- 
--    sterge inregistrarile unei tabele si elibereaza spatiul alocat acestora
--        TRUNCATE TABLE
-- ## Sa se stearga tabela fosti_agenti
DROP TABLE fosti_agenti;
-- ## Sa se recupereze tabela fosti_agenti
FLASHBACK TABLE fosti_agenti TO BEFORE DROP;
-- ## Sa se stearga inregistrarile tabelei personal
TRUNCATE TABLE personal;
-- ## Sa se vizualizeze toate tabelele utilizatorului curent
SELECT *
FROM USER_TABLES;
-- ## Sa se vizualizeze denumirea tabelelor, restrictiile si tipul acestora pentru utilizatorul curent
SELECT TABLE_NAME,
  CONSTRAINT_TYPE,
  CONSTRAINT_NAME
FROM USER_CONSTRAINTS;
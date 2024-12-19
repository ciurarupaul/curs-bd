-- --------- TIPS----------
--    snake_case
--    comenzile NU sunt case sensitive, dar se scriu cu litere mari pentru a se citi mai usor
--    cuvintele cheie nu se pot prescurta sau scrie pe mai multe linii
-- 
-- --------- TIPURI DE DATE ----------
-- 
--    CHAR - sir de date de lungime fixa
--    VARCHAR2 || VARCHAR - site de caractere de lungime variabila
--    NUMBER (precision, scale)
--    DATE
--    ROWID - adresa fiecarui rand din tabela
--    BLOB - binary large object - se stocheaza date nestructurate de dimnesiune foarte mare (max 4GB) (text, img, video, date spatiale)
--    CLOB - character large object - text mult
--    NCLOB - include caractere natioanele
--    BFILE - pointer catre un fisier binar stocat in afara bd
-- 
-- ---------- OPERATORI ----------
-- 
--    < > = >= <= NOT - operatori de comparatie
--    BETWEEN .. AND .. - intre doua valori,  []
--    IN (lista) - egal cu orice valoare din lista
--    LIKE - similar cu un exemplu/sablon
--    IS NULL - are valoarea NULL
-- 
-- ---------- COMENZI ----------
-- 
--    LDD - Limbaj de Definire a Datelor
--        CREATE - creaza un obiect nou - tablea, utilizator, rol, ..
--        ALTER - modifica o parte din proprietatile unui obiect
--        DROP - elimina un obiect din bd
-- 
--    LMD - Limbaj de Manipulare a Datelor
--        SELECT - gaseste inregistrari in tabela
--        DELETE - sterge inregistrari din tabela
--        INSERT - adauga inregistrare in tabela
--        UPDATE - modifica valorile unor inregistrari
-- 
--    LPT - Limbaj pentru Procesarea Tranzactiilor
--        COMMIT - finalizeaza o tranzactie
--        ROLLBACK - anuleaza o tranzactie
--        SAVEPOINT - face un checkpoint
-- 
--    LCD - Limbaj de Control al Datelor
--        GRANT - acorda utilizatorilor drepturi pentru manipularea si accesarea obiectelor
--        REVOKE - anuleaza anumite drepturi ale utilizatorilor
-- 
-- ---------- RESTRICTII DE INTEGRITATE ----------
--    NOT NULL
--    UNIQUE
--    PRIMARY KEY
--    FOREIGN KEY
--    CHECK
--    se pot face ori inline la definirea coloanei sau separat, fie la finalul CREATE TABLE, fie prin ALTER TABLE
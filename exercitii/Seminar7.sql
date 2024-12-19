-- ## Sa se selecteze din tabela angajaţi numai angajatii care au salariul cuprins intre 8000 si 10000
SELECT *
FROM angajati
WHERE salariul BETWEEN 8000 AND 10000;
-- ##	Sa se selecteze din tabela angajati numai angajatii care au functia SA_REP
SELECT *
FROM angajati
WHERE UPPER (id_functie) = 'SA_REP';
-- WHERE UPPER (id_functie) LIKE 'SA_REP';
-- ## Sa se selecteze angajatii care sunt in acelasi departament cu angajatul Smith
SELECT *
FROM angajati
WHERE id_departament = (
    SELECT id_departament
    FROM angajati
    WHERE nume = 'Smith'
  );
-- ## Modificati conditia de la punctul 2 astfel incat sa fie selectati si cei care au in denumirea functiei atributul ACCOUNT
SELECT *
FROM angajati
WHERE UPPER (id_functie) = 'SA_REP'
  OR UPPER (id_functie) LIKE '%ACCOUNT%';
-- ## Sa se selecteze toti angajatii pentru care a doua litera din e-mail este A, B sau C
SELECT *
FROM angajati
WHERE SUBSTR(email, 2, 1) IN ('A', 'B', 'C');
-- ## Sa se selecteze toti angajatii care au numarul de telefon format din al doilea grup de cifre din 123 (de exemplu: 515.123.4569)
SELECT *
FROM angajati
WHERE SUBSTR(telefon, 5, 3) = '123';
-- ## Sa se selecteze toti angajatii angajati inainte de 1 ianuarie 2009 (data_angajare)
SELECT *
FROM angajati
WHERE data_angajare < TO_DATE('January 1, 2009', 'MM-DD-YYYY');
-- ##  Sa se selecteze numele, salariul, denumirea functiei angajatilor şi denumirea departamentului pentru cei care lucreaza în departamentul IT
SELECT nume,
  salariu,
  id_functie
FROM angajati
WHERE UPPER(id_functie) LIKE '%IT%';
-- ## Modificati conditia de mai sus astfel incat sa fie selectati toti angajatii din departamentele care au in denumire specificatia IT, indiferent daca acestea au sau nu angajati
SELECT a.nume,
  a.salariul,
  a.id_functie
FROM angajati a
  JOIN departamente d ON UPPER(d.denumire_departament) LIKE '%IT%'
WHERE UPPER(a.id_functie) LIKE '%IT%';
-- ## Sa se afiseze id departament, denumire departament, salariul minim si numărul de angajati pentru fiecare departament, cu mai mult de 5 angajați
SELECT d.id_departament,
  d.denumire_departament,
  MIN(a.salariu) AS salariul_minim,
  COUNT(a.id_angajat) AS numar_angajati
FROM departamente d
  JOIN angajati a ON d.id_departament = a.id_departament
GROUP BY d.id_departament,
  d.denumire_departament
HAVING COUNT(a.id_angajat) > 5;
-- ## Afisati numele si in ordine crescatoare salariile si in ordine descrescatoare data angajarii pentru salariatii din departamentul vânzări (Sales).
SELECT nume,
  salariul
FROM angajati
WHERE UPPER(id_functie) LIKE '%SA%'
ORDER BY salariul ASC,
  data_angajare DESC;
-- ## Sa se selecteze numele, functia, comisionul si departamentul angajatilor care nu au comisionul NULL
SELECT nume,
  id_functie,
  comision,
  id_departament
FROM angajati
WHERE comision IS NOT NULL;
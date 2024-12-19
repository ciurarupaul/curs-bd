-- ----------------------------------------
-- ---------- INTEROGARE TABELE
-- ----------------------------------------
--    general structure
--
--    SELECT	[DISTINCT] (*/coloana1 [alias], expresii [alias])
--    FROM	tabela1, tabela2, ...
--    WHERE     (conditii, precizarea legaturilor dintre tabele)
--    GROUP BY nume_tabela.nume_coloana
--    HAVING  (conditii impuse valorilor de grup)
--    ORDER BY nume_tabela.nume_coloana ASC/DESC;
-- 
--    SELECT - specifica atributele selectate 
--    DISTINCT - fara duplicate
--    * - selecteaza toate atributele
--    coloana - selecteaza o coloana sau mai multe coloane sau mai multe tabele
--    expresie - permite construirea de expresii avand ca rezultat valori noi
--    alias - denumirile coloanelor selectate
--    FROM TABLE - tabelele de provenienta ale coloanelor selectate
--    WHERE- permite specificarea conditiilor
--    GROUP BY - se precizeaza campul dupa care vor fi grupate datele in cazul expresiilor si functiilor de grup (SUM(), AVG(), COUNT(), MIN(), MAX())
--    HAVINGin - in cazul functiilor de grup conditiile impuse acestora se precizeaza in clauza HAVING
--    ORDER BY - precizeaza ordonarea in functie un anumite campuri ascendent (ASC) – implicit sau descendent (DESC). Numai ORDER BY permite utilizarea aliasului
--
--    Coloanele se specifică în ordinea în care se doresc a fi afişate, nu obligatoriu în ordinea în care apar în descrierea tabelelor
-- 
-- ## Sa se selecteze toti angajatii din tabela salariati
SELECT *
FROM salariati;
-- ## Sa se selecteze coloanele id_angajat, nume, prenume si id_functie din tabela salariati
SELECT id_angajat,
  nume,
  prenume,
  id_functie
FROM salariati;
-- ## Sa se selecteze numai angajatii care fac parte din categoria functionar (al caror id_functie contine „CLERK”)
SELECT *
FROM salariati
WHERE upper(id_functie) LIKE '%CLERK%';
-- ## Sa se selecteze comenzile incheiate de salariatul cu id_angajat = 161
SELECT *
FROM comenzi
WHERE id_angajat = 161
ORDER BY nr_comanda;
-- ##	Sa se selecteze toate comezile care au fost lansate online dupa 1 ianuarie 2000
SELECT *
FROM comenzi
WHERE LOWER(modalitate) LIKE '%online%'
  AND data > TO_DATE ('01.01.2000', 'DD.MM.YYYY');
-- ## Sa se selecteze id_angajat, nume, prenume, id_manager, id_departament din tabela angajati si denumire_departament din tabela departamente si sa se realizeze jonctiunea dintre cele doua tabele
SELECT a.id_angajat,
  a.nume,
  a.prenume,
  a.id_manager,
  a.id_departament,
  d.denumire_departament
FROM angajati a,
  departamente d
WHERE a.id_departament = d.id_departament;
-- 
--    ANY Comapara valoarea cu oricare valoare returnata de interogare
--    ALL compara valoarea cu fiecare valoare returnata de interogare 
--    <ANY() - less than maximum
--    >ANY() - more than minimum
--    =ANY() - equivalent to IN
--    >ALL() - more than the maximum
--    <ALL() - less than the minimum
-- 
-- ## Să se afişeze id_angajat, prenume, id_functie si salariul pentru angajatii care nu lucreaza in departamentul IT_PROG si al caror salariu este mai mic decat oricare dintre salariile angajatilor care lucreaza in departamentul IT_PROG:
SELECT id_angajat,
  prenume,
  id_functie,
  salariul
FROM angajati
WHERE salariul < ANY (
    SELECT salariul
    FROM angajati
    WHERE id_functie = 'IT_PROG'
  )
  AND id_functie <> 'IT_PROG'
ORDER BY salariul DESC;
-- ##	Să se afişeze id_angajat, prenume, id_functie si salariul pentru angajatii care nu lucreaza in departamentul IT_PROG si al caror salariu este mai mic decat fiecare dintre salariile angajatilor care lucreaza in departamentul IT_PROG
SELECT id_angajat,
  prenume,
  id_functie,
  salariul
FROM angajati
WHERE salariul < ALL (
    SELECT salariul
    FROM angajati
    WHERE id_functie = 'IT_PROG'
  )
  AND id_functie <> 'IT_PROG'
ORDER BY salariul DESC;
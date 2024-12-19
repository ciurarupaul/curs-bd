-- ----------
-- set 1
-- ----------
-- 1) Sa se afiseze nr_comanda, data, valoarea comenzii, pentru comenzile incheiate in 1999 cu valoarea totala (sum(cantitate*pret)) mai mare de 2000, în ordinea datei.
SELECT c.id_comanda,
  c.data,
  SUM(rc.cantitate * rc.pret) AS valoarea_comenzii
FROM comenzi c,
  rand_comenzi rc
WHERE c.id_comanda = rc.id_comanda
  AND EXTRACT(
    YEAR
    FROM c.data
  ) = 1999
GROUP BY c.id_comanda,
  c.data
HAVING SUM(rc.cantitate * rc.pret) > 2000
ORDER BY c.data;
-- 
-- 2) Sa se afiseze numarul comenzii, data, valoarea totala comandata  (sum(cantitate*pret)) si sa se calculeze cheltuielile de transport pentru livrarea acestora astfel:
-- -	pentru comenzi cu valoarea de pana la 1000 cheltuielile de transport sa fie de 100
-- -	pentru comenzi cu valoarea 1000  si 2000 cheltuielile de transport sa fie de 200
-- -	pentru comenzi cu valoarea mai mare de 2000 cheltuielile de transport sa fie de 300
SELECT c.id_comanda,
  c.data,
  SUM(rc.cantitate * rc.pret) AS valoarea_comenzii,
  CASE
    WHEN SUM(rc.cantitate * rc.pret) <= 1000 THEN 100
    WHEN SUM(rc.cantitate * rc.pret) > 1000
    AND SUM(rc.cantitate * rc.pret) < 2000 THEN 200
    WHEN SUM(rc.cantitate * rc.pret) >= 2000 THEN 300
  END AS cheltuieli_transport
FROM comenzi c,
  rand_comenzi rc
WHERE c.id_comanda = rc.id_comanda
GROUP BY c.data,
  c.id_comanda
ORDER BY c.data DESC;
-- 
-- 3) Sa se afiseze id_client, id_produs si cantitatea totala din fiecare produs, vanduta unui client.
-- SELECT c.id_client,
--   rc.id_produs,
--   SUM(rc.cantitate) AS cantitate
-- FROM comenzi c
--   JOIN rand_comenzi rc ON c.id_comanda = rc.id_comanda
-- GROUP BY c.id_client,
--   rc.id_produs
-- ORDER BY c.id_client,
--   rc.id_produs;
SELECT c.id_client,
  rc.id_produs,
  SUM(rc.cantitate) AS cantitate
FROM comenzi c,
  rand_comenzi rc
WHERE rc.id_comanda = c.id_comanda
GROUP BY c.id_client,
  rc.id_produs
ORDER BY c.id_client,
  rc.id_produs;
-- 
-- 4) Sa se afiseze numele, denumirea departamentului unde lucreaza si nivelul ierarhic pentru toti angajatii care au subordonati si care au aceeasi functie ca angajatul Russell
SELECT a.nume,
  d.denumire_departament,
  LEVEL
FROM angajati a,
  departamente d
WHERE a.id_departament = d.id_departament CONNECT BY PRIOR a.id_angajat = a.id_manager START WITH a.id_angajat = 100
ORDER BY LEVEL;
-- 
-- 5) Sa se afiseze numele angajatilor care nu au subalterni si care au aceeasi functie ca angajatul Rogers, nivelul ierarhic si denumirea departamentului unde acestia lucreaza
SELECT a.nume,
  d.denumire_departament,
  CONNECT_BY_ISLEAF,
  LEVEL
FROM angajati a,
  departamente d
WHERE (
    a.id_departament = d.id_departament
    AND a.id_functie =(
      SELECT id_functie
      FROM angajati
      WHERE nume = 'Rogers'
    )
  ) CONNECT BY PRIOR a.id_angajat = a.id_manager START WITH a.id_angajat = 100;
-- 
-- 6) Sa se afiseze departamentele (id_departament si denumire_departament) care au numai angajati cu salariul < 10000
SELECT d.id_departament,
  d.denumire_departament
FROM departamente d,
  angajati a
WHERE d.id_departament = a.id_departament
GROUP BY d.id_departament,
  d.denumire_departament
HAVING MAX (a.salariul) < 10000;
-- ----------
-- set 2
-- ----------
-- 
-- 1) Sa se afiseze numele, salariul, data angajarii, denumirea functiei pentru angajatii care au functia Programmer sau Accountant si au fost angajati intre 1995 si 1998.
SELECT nume,
  salariul,
  data_angajare,
  id_functie
FROM angajati
WHERE id_functie = 'IT_PROG'
  OR id_functie = 'AC_ACCOUNT';
-- 
-- 2) Sa se realizeze o operatie de modificare a pretului la produse astfel incat noul pret sa se mareasca cu 15% pentru toate produsele care au pretul mai mic decat pretul mediu al produsului care contine denumirea cuvantunl sound  (se actualizeaza tabela  rand_comenzi). La final sa se anuleze operatia de actualizare.
UPDATE produse
SET pret_lista = 1.15 * pret_lista
WHERE pret_lista < (
    SELECT AVG(pret_lista)
    FROM produse
    WHERE LOWER(denumire_produs) LIKE '%sound%'
  );
ROLLBACK;
-- 
-- 3) Sa se afiseze numele, data angajarii, functia actuala si functiile detinute de angajatii din departamentele 50 si 80 in perioada 1995-1999.
SELECT a.nume,
  a.data_angajare,
  a.id_functie,
  ist.id_functie
FROM angajati a,
  istoric_functii ist
WHERE a.id_angajat = ist.id_angajat
  AND a.id_departament IN (50, 80)
  AND ist.data_inceput >= TO_DATE('1995-01-01', 'YYYY-MM-DD')
  AND ist.data_sfarsit <= TO_DATE('1999-12-31', 'YYYY-MM-DD');
-- 
-- 4) Sa se realizeze o operatie de modificare a pretului la produse astfel incat noul pret sa se micsoreze cu 5% pentru toate produsele care au cantitatea comandata mai mica decat cantitatea medie comandata din produsul cu denumirea care conţine CPU. (se actualizeaza tabela  rand_comenzi). La final sa se anuleze operatia de actualizare.
UPDATE rand_comenzi
SET pret = 0.95 * pret
WHERE cantitate < (
    SELECT AVG(rc.cantitate)
    FROM rand_comenzi rc,
      produse p
    WHERE rc.id_produs = p.id_produs
      AND UPPER(p.denumire_produs) LIKE '%CPU%'
  );
-- 
-- 5) Sa se afiseze denumirea produselor si valoarea totala comandata a acestora (sum(cantitate*pret) cuprinsa intre 1500 si 4000.
SELECT p.denumire_produs,
  SUM(rc.cantitate * rc.pret) AS valoare_totala
FROM produse p,
  rand_comenzi rc
WHERE p.id_produs = rc.id_produs
GROUP BY p.denumire_produs
HAVING SUM(rc.cantitate * rc.pret) BETWEEN 1500 AND 4000;
-- 
-- 6) Sa se afiseze numarul comenzii, data, valoarea totala (sum(cantitate*pret)), numarul de produse pentru comenzile online incheiate in perioada 1999-2000 si contin cel putin 2 produse
SELECT rc.id_comanda,
  c.data,
  SUM(rc.cantitate * rc.pret) AS valoare_totala,
  COUNT(rc.id_produs) AS numar_produse
FROM rand_comenzi rc,
  comenzi c
WHERE rc.id_comanda = c.id_comanda
  AND rc.cantitate >= 2
  AND c.data BETWEEN TO_DATE('1999-01-01', 'YYYY-MM-DD') AND TO_DATE('2000-12-31', 'YYYY-MM-DD')
GROUP BY rc.id_comanda,
  c.data
ORDER BY c.data;
-- ----------
-- set 3
-- ----------
-- 
-- 1) Sa se afiseze numarul comenzii, denumirea produsului, pretul, cantitatea si valoarea pentru produsele care contin in denumire cuvantul  Monitor.
SELECT c.id_comanda,
  p.denumire_produs,
  rc.pret,
  rc.cantitate,
  rc.cantitate * rc.pret AS valoare
FROM comenzi c,
  rand_comenzi rc,
  produse p
WHERE (
    c.id_comanda = rc.id_comanda
    AND p.id_produs = rc.id_produs
  )
  AND LOWER (p.denumire_produs) LIKE '%monitor%';
-- 
-- 2) Să se afişeze numele, id-ul departamentului si numărul de comenzi incheiate de angajatii din departamentul 80 in luna noiembrie. 
SELECT a.nume,
  a.id_departament,
  COUNT(c.id_angajat) AS numar_comenzi
FROM angajati a,
  comenzi c
WHERE a.id_angajat = c.id_angajat
  AND a.id_departament = 80
  AND EXTRACT (
    MONTH
    FROM c.data
  ) = 11
GROUP BY a.nume,
  a.id_departament;
-- 
-- 3) Sa se realizeze actualizarea pretului la produse astfel incat noul pret sa se micsoreze cu 10% pentru toate produsele care au pretul mai mare decat al pretul mediu al produsului cu id-ul ‘3155’ (se actualizeaza tabela  rand_comenzi). La final sa se anuleze actualizarea.
UPDATE rand_comenzi rc
SET pret = 0.9 * rc.pret
WHERE rc.id_produs IN (
    SELECT id_produs
    FROM produse
    WHERE pret_lista > (
        SELECT AVG(pret_lista)
        FROM produse
        WHERE id_produs = 3155
      )
  );
ROLLBACK;
-- 
-- 4) Sa se afiseze numele, denumirea functiei, numarul de comenzi pentru angajatii care au incheiat cel putin 2 comenzi.
SELECT a.nume,
  f.denumire_functie,
  COUNT(c.id_angajat)
FROM angajati a,
  comenzi c,
  functii f
WHERE a.id_angajat = c.id_angajat
  AND a.id_functie = f.id_functie
HAVING COUNT (c.id_angajat) >= 2
GROUP BY a.nume,
  f.denumire_functie;
-- pana acum nu am vazut ca exista o tabela de functii si unde cerea denumirea functiei am pus id-ul :(
-- 
-- 5) Sa se realizeze actualizarea pretului la produse astfel incat noul pret sa se mareasca cu 5% pentru toate produsele care au valoarea comandata (cantitate*pret)  mai mare sau egala cu 1000 (se actualizeaza tabela  rand_comenzi). La final sa se anuleze operatia de actualizare
UPDATE rand_comenzi
SET pret = 1.05 * pret
WHERE id_produs IN (
    SELECT id_produs
    FROM rand_comenzi
    GROUP BY id_produs
    HAVING SUM (cantitate * pret) >= 1000
  );
-- 
-- 6) Sa se afiseze numele, numarul de comenzi, salariul si bonusul fiecarui angajat. Bonusul se va calcula in functie de numarul de comenzi incheiate, astfel:
--    intre 1-2 comenzi – 5% din salariul lunar;
--    intre 3-5 comenzi – 7% din salariul lunar;
--    mai mult de 5 comenzi – 10% din salariul lunar.
SELECT a.nume,
  COUNT(c.id_angajat) AS numar_comenzi,
  a.salariul,
  CASE
    WHEN COUNT(c.id_angajat) BETWEEN 1 AND 2 THEN a.salariul * 0.05
    WHEN COUNT(c.id_angajat) BETWEEN 3 AND 5 THEN a.salariul * 0.07
    WHEN COUNT(c.id_angajat) > 5 THEN a.salariul * 0.1
    ELSE 0
  END AS bonus
FROM angajati a,
  comenzi c
WHERE a.id_angajat = c.id_angajat
GROUP BY a.nume,
  a.salariul;
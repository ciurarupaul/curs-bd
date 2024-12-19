-- ----------------------------------------
-- ---------- FUNCTII PREDEFINITE
-- ----------------------------------------
-- 
-- ----------------------------------------
-- ---------- FUNCTII SINGLE-ROW
-- ----------------------------------------
-- 
-- LOWER() | UPPER() | INITCAP()
--
--  ## Sa se afiseze cu litere mari denumirea departamentelor din locatia 1700
SELECT id_departament,
  UPPER(denumire_departament)
FROM departamente
WHERE id_locatie = 1700;
-- 
-- ## Sa se afiseze salariatii al caror nume incepe cu litera s
SELECT id_angajat,
  nume
FROM angajati
WHERE nume like 's%';
SELECT id_angajat,
  nume
FROM angajati
WHERE nume like upper('s%');
-- 
-- ## Sa se afiseze toti angajatii cu numele Smith utilizand functiile INITCAP, UPPER, LOWER
SELECT id_angajat,
  nume
FROM angajati
WHERE INITCAP(nume) = 'Smith';
SELECT id_angajat,
  nume
FROM angajati
WHERE UPPER(nume) = 'SMITH';
SELECT id_angajat,
  nume
FROM angajati
WHERE LOWER(nume) = 'smith';
-- 
-- Operatorul de concatenare || 
-- ##	Să se afişeze denumirea produsului şi stocul disponibil
SELECT 'Produsul: ' || INITCAP(denumire_produs) || ' are pretul_minim ' || pret_min produs_pret_minim
FROM produse;
-- 
-- Functia CONCAT() , functia LENGTH() , functia SUBSTR()
-- 
-- ##	Să se afişeze id_client, numele clientilor concatenată cu sexul acestora şi lungimea prenumelui, nivel_venituri numai pentru clientii cu venituri in categoria F: 110000 - 129999
SELECT id_client,
  CONCAT(nume_client, sex),
  LENGTH(prenume_client),
  nivel_venituri
FROM clienti
WHERE SUBSTR(nivel_venituri, 1, 1) = 'F';
-- 
-- INSTR(), REPLACE(), REVERSE()
-- ROUND(), TRUNC()
-- ##	Să se afişeze numărul 45,923 rotunjit la două zecimale si rotunjit la numar intreg. Sa se aplice si functia TRUNC
SELECT ROUND(45.923, 2),
  ROUND(45.923, 0)
FROM DUAL;
SELECT TRUNC(45.923, 2),
  TRUNC(45.923, 0)
FROM DUAL;
-- 
-- SIGN(), POWER(), MOD(), SQRT(),CORR(),STDDEV()
-- SYSDATE
-- ## Să se afişeze perioada de timp corespunzătoare (în săptămâni) între data încheierii comenzii şi data curentă
SELECT nr_comanda,
  (SYSDATE - data) / 7 saptamani
FROM comenzi;
-- ##	Afisati data curenta (se selecteaza data din tabela DUAL):
SELECT SYSDATE data_curenta
FROM DUAL;
-- 
-- MONTHS_BETWEEN() , ADD_MONTHS() , NEXT_DAY() , LAST_DAY()
--
-- ## Să se afişeze comenzile, data încheierii comenzilor, numărul de luni între data curentă şi data încheierii, următoarea zi de vineri după data încheierii, ultima zi din luna din care face parte data încheierii, precum şi data corespunzătoare după 2 luni de la data încheierii comenzii
SELECT nr_comanda,
  data,
  round(MONTHS_BETWEEN(sysdate, data)) luni,
  NEXT_DAY(data, 'FRIDAY'),
  LAST_DAY(data) ADD_MONTHS(data, 2),
  FROM comenzi;
-- ## Să se afişeze comenzile incheiate in luna trecuta
SELECT nr_comanda,
  data
FROM comenzi
WHERE round(MONTHS_BETWEEN(sysdate, data)) = 1;
SELECT nr_comanda,
  data
FROM comenzi
WHERE round(MONTHS_BETWEEN(sysdate, data)) = 171;
-- ## Să se afişeze comenzile incheiate in 2000. Se va rotunji data încheierii la prima zi din luna corespunzătoare dacă data încheierii este în prima jumatate a lunii sau la prima zi din luna următoare:
SELECT nr_comanda,
  data,
  ROUND(data, 'MONTH')
FROM comenzi
WHERE data LIKE '%-00%';
-- 
-- ---- FUNCTII DE CONVERSIE
-- TO_CHAR 
-- 
-- ## Să se afişeze comenzile si data încheierii in formatul initial si in format “MM/YY”
SELECT nr_comanda,
  data,
  TO_CHAR(data, 'MM/YY') data_incheierii_comenzii
FROM comenzi;
-- TO_DATE
-- ## Să se afişeze comenzile incheiate intre 15 ianuarie si 15 decembrie 1999
SELECT nr_comanda,
  data
FROM comenzi
WHERE data BETWEEN TO_DATE('January 15, 1999', 'Month dd,YYYY') AND TO_DATE('December 15, 1999', 'Month dd,YYYY');
-- EXTRACT()
-- ## Sa se afiseze comenzile incheiate in anii 1997 si 1998
SELECT nr_comanda,
  data
FROM comenzi
WHERE EXTRACT(
    YEAR
    FROM data
  ) IN (1997, 1998);
-- ## Sa se afiseze comenzile incheiate in lunile iulie si august
SELECT nr_comanda,
  data
FROM comenzi
WHERE EXTRACT(
    MONTH
    FROM data
  ) IN (7, 8);
-- NVL, NVL2, NULLIF, COALESCE
-- ## Sa se calculeze veniturile anuale ale angajatilor -- NVL
SELECT nume,
  salariul * 12 + salariul * 12 * NVL(comision, 0) venit_anual
FROM angajati;
-- ## Sa se afiseze angajatii care au comision (1) si pe cei care nu au comision (0). -- NVL2
SELECT nume,
  NVL2(comision, 1, 0)
FROM angajati;
-- ## Sa se afiseze lungimea numelui, lungimea prenumelui, daca acestea sunt egale sa se returneze nul ca rezultat, iar daca nu sunt egale se va returna lungimea numelui. -- NULLIF
SELECT nume,
  LENGTH(nume),
  prenume,
  LENGTH(prenume),
  NULLIF(LENGTH(nume), LENGTH(prenume)) rezultat
FROM angajati;
-- ## Sa se afiseze id-ul managerului fircarui angajat, daca acesta este nul, se va afisa comisionul, iar daca si acesta este nul se va afisa -1 -- COALESCE
SELECT nume,
  prenume,
  COALESCE(id_manager, commission, -1)
FROM angajati;
-- 
-- ----------------------------------------
-- ---------- FUNCTII DE GRUP
-- ----------------------------------------
-- 
-- ## Să se afişeze valoarea maximă, valoarea medie, valoarea minimă şi valoarea totală a produselor comandate
SELECT AVG(rc.cantitate * rc.pret),
  MAX(rc.cantitate * rc.pret),
  MIN(rc.cantitate * rc.pret),
  sum(rc.cantitate * rc.pret)
FROM rand_comenzi rc;
-- ## Să se afişeze data primei comenzi încheiate şi data celei mai vechi comenzi încheiate
SELECT MIN(data),
  MAX(data)
FROM comenzi;
-- ## Să se afişeze numărul de produse al căror pret_min>350
SELECT COUNT(*) nr_produse
FROM produse
WHERE pret_min > 350;
-- ## Sa se afiseze numarul de salarii (distincte) din tabela angajati
SELECT COUNT (salariul)
FROM angajati;
SELECT COUNT (DISTINCT salariul)
FROM angajati;
-- ## Să se afişeze numărul total de comenzi incheiate
SELECT COUNT(nr_comanda) nr_comenzi
FROM comenzi;
-- ##	Să se afişeze în cate comenzi apare produsul cu codul 3124
SELECT COUNT(nr_comanda) produse_comandate_id_produs
FROM rand_comenzi
WHERE id_produs = 3124;
-- ##	Să se afişeze cantitatea medie vândută din fiecare produs. Sa se ordoneze după cantitate (se utilizeaza functia AVG() si clauza GROUP BY pentru gruparea datelor in functie de id_ul produsului, iar ordonarea se realizeaza cu ajutorul functiei ORDER BY)
SELECT id_produs,
  ROUND(AVG(cantitate), 2) medie_produse
FROM rand_comenzi
GROUP BY id_produs
ORDER BY medie_produse;
-- ## Să se afişeze produsele şi cantitatea medie vândută numai pentru acele produse a căror cantitate medie este mai mare de 25 (conditia se specifica in clauza HAVING si nu in clauza WHERE deoarece este utilizata functia de grup AVG si conditia este AVG(cantitate)>25)
SELECT id_produs,
  ROUND(AVG(cantitate), 1) medie_produse
FROM rand_comenzi
GROUP BY id_produs
HAVING ROUND(AVG(cantitate), 1) > 25;
-- ##	Sa se calculeze valoarea totala a fiecarei comenzi si sa se sorteze descrescator in functie de valoare
SELECT comenzi.nr_comanda,
  SUM(rand_comenzi.cantitate * rand_comenzi.pret) total_comanda
FROM comenzi,
  rand_comenzi
WHERE rand_comenzi.nr_comanda = comenzi.nr_comanda
GROUP BY comenzi.nr_comanda
ORDER BY total_comanda DESC;
-- ##	Sa se afiseze numai comenzile care au valoarea cuprinsa intre 1000 si 3000 (conditia va fi mentionata in clauza HAVING deoarece se utilizeaza functia de grup SUM):
SELECT comenzi.nr_comanda,
  SUM(rand_comenzi.cantitate * rand_comenzi.pret) total_comanda
FROM comenzi,
  rand_comenzi
WHERE rand_comenzi.nr_comanda = comenzi.nr_comanda
GROUP BY comenzi.nr_comanda
HAVING SUM(rand_comenzi.cantitate * rand_comenzi.pret) BETWEEN 1000 AND 3000
ORDER BY total_comanda DESC;
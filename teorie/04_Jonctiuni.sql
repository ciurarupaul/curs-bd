-- ----------------------------------------
-- ---------- JONCTIUNI
-- ----------------------------------------
-- 
--    Jonctiunea de egalitate
-- 
-- ## Sa se selecteze comenzile incheiate de angajati  (in clauza WHERE se va preciza conditia de legatura dintre tabele)
SELECT a.*,
  c.*
FROM angajati a,
  comenzi c
WHERE a.id_angajat = c.id_angajat;
-- ## Sa se selecteze comenzile incheiate de angajatul Greene numai in luna noiembrie
SELECT angajati.*,
  comenzi.*
FROM angajati,
  comenzi
WHERE angajati.id_angajat = comenzi.id_angajat
  AND lower(comenzi.data) like '%nov%'
  AND upper(angajati.nume) = 'GREENE';
-- ## Sa se calculeze valoarea fiecarui produs (valoare = cantitate * pret) si sa se afiseze denumirea produsului, pretul, cantitatea si valoarea
SELECT produse.denumire_produs,
  rand_comenzi.cantitate,
  rand_comenzi.pret,
  rand_comenzi.cantitate * rand_comenzi.pret AS Valoare
FROM produse,
  rand_comenzi
WHERE produse.id_produs = rand_comenzi.id_produs;
-- ## Sa se selecteze numai produsele cu valoarea cuprinsa intre 1000 si 2000
SELECT produse.denumire_produs,
  rand_comenzi.cantitate,
  rand_comenzi.pret,
  rand_comenzi.cantitate * rand_comenzi.pret AS Valoare
FROM produse,
  rand_comenzi
WHERE produse.id_produs = rand_comenzi.id_produs
  AND rand_comenzi.cantitate * rand_comenzi.pret BETWEEN 1000 AND 2000;
-- 
--    Jonctiunea externa
-- 
-- ## Să se afişeze id-ul produsului, denumirea produsului şi cantitatea chiar daca nu au fost comandate
SELECT p.id_produs,
  p.denumire_produs,
  rc.cantitate,
  rc.pret
FROM produse p,
  rand_comenzi rc
WHERE p.id_produs = rc.id_produs (+);
-- 
--    Jonctiunea dintre o tabela si aceeasi tabela
-- 
-- ## Să se afişeze numele fiecarui angajat şi numele sefului direct superior
SELECT a.nume || ' lucreaza pentru: ' || m.nume
FROM angajati a,
  angajati m
WHERE a.id_manager = m.id_angajat;
-- 
--    Realizarea interogarilor subordonate (se utilizeaza 2 comenzi SELECT imbricate)
-- 
-- ##	Sa se selecteze angajatii care sunt in acelasi departament cu angajatul Smith
SELECT *
FROM angajati
WHERE id_departament = (
    SELECT id_departament
    FROM angajati
    WHERE upper(nume) = 'SMITH'
  );
-- Eroare "single-row subquery returns more than one row"
SELECT nume,
  prenume,
  id_angajat,
  id_departament
FROM angajati
WHERE nume = 'Smith';
SELECT *
FROM angajati
WHERE id_departament IN (
    SELECT id_departament
    FROM angajati
    WHERE upper(nume) = 'SMITH'
  );
-- ##	Să se afişeze produsele care au preţul unitar cel mai mic
SELECT p.denumire_produs,
  rc.pret
FROM produse p,
  rand_comenzi rc
WHERE p.id_produs = rc.id_produs
  AND rc.pret = (
    SELECT MIN(rand_comenzi.pret)
    FROM rand_comenzi
  );
-- FOR UPDATE - blocheaza randurile selectate de o interogare in vederea actualizarii ulterioare, ceilalti utilizatori nu pot modifica acele randuri pana la finalizarea tranzactiei
-- FOR UPDATE nu se foloseste cu DISTINCT, GROUP BY, functii de grup
SELECT a.id_angajat,
  a.id_functie,
  c.nr_comanda
FROM angajati a,
  comenzi c
WHERE a.id_angajat = c.id_angajat FOR
UPDATE;
-- 
--    Jonctiuni externe
--    DECODE si expresia CASE
-- 
-- ##	Sa se afiseze produsele comandate impreuna cu cele care nu se regasesc pe nici o comanda
SELECT p.id_produs,
  p.denumire_produs,
  rc.cantitate,
  rc.pret
FROM produse p,
  rand_comenzi rc
WHERE p.id_produs = rc.id_produs (+);
-- ##	Sa se afiseze toti angajatii care au incheiat comenzi, precum si cei care nu au incheiat comenzi
SELECT a.id_angajat,
  a.nume,
  c.nr_comanda,
  c.data
FROM angajati a,
  comenzi c
WHERE a.id_angajat = c.id_angajat (+);
-- ##	Sa se calculeze comisionul agentilor in functie de pozitia (functia) ocupata:
--    0.1% din valoarea comenzilor daca functia este SA_REP
--  	0.2% din valoarea comenzilor daca functia este SA_MAN
--  	0.3% din valoarea comenzilor daca functia este AD_PRES
--    Pentru celelalte functii comisionul va fi 0.
SELECT nume,
  id_functie,
  CASE
    WHEN UPPER(id_functie) = 'AD_PRES' THEN 0.3
    WHEN UPPER(id_functie) = 'SA_MAN' THEN 0.2
    WHEN UPPER(id_functie) = 'SA_REP' THEN 0.1
    ELSE 0
  END comision
FROM angajati;
-- sau cu DECODE
SELECT nume,
  id_functie,
  DECODE(
    UPPER(id_functie),
    'AD_PRES',
    0.3,
    'SA_MAN',
    0.2,
    'SA_REP',
    0.1,
    0
  ) comision
FROM angajati;
-- ## Se aplica acest comision la valoarea comenzilor (SUM(cantitate*pret)) 
SELECT a.nume,
  a.id_functie,
  (
    CASE
      WHEN UPPER(a.id_functie) = 'AD_PRES' THEN 0.3
      WHEN UPPER(a.id_functie) = 'SA_MAN' THEN 0.2
      WHEN UPPER(a.id_functie) = 'SA_REP' THEN 0.1
      ELSE 0
    END
  ) * SUM(r.cantitate * r.pret) valoare_comision
FROM angajati a,
  comenzi c,
  rand_comenzi r
WHERE a.id_angajat = c.id_angajat
  AND c.nr_comanda = r.nr_comanda
GROUP BY a.nume,
  a.id_functie;
-- Sa se calculeze discountul (DC) pentru clienti astfel:
--    daca clientul a incheiat 1 comanda atunci DC= 10%;
--    daca a incheiat 2 comenzi atunci DC =15%;
--    daca a incheiat  mai mult de 3 comenzi atunci DC =20%.
SELECT cl.nume_client,
  count(co.nr_comanda) numar_comenzi,
  CASE
    WHEN COUNT(co.nr_comanda) = 1 THEN 0.1
    WHEN COUNT(co.nr_comanda) = 2 THEN 0.15
    WHEN COUNT(co.nr_comanda) >= 3 THEN 0.2
    ELSE 0
  END discount
FROM clienti cl,
  comenzi co
WHERE cl.id_client = co.id_client
GROUP BY cl.nume_client;
-- 
SELECT nume_client,
  limita_credit,
  starea_civila,
  CASE
    WHEN starea_civila = 'married' THEN CASE
      WHEN limita_credit < 400 THEN 'married with low budget'
      WHEN limita_credit BETWEEN 400 AND 1000 THEN 'married with medium budget'
      ELSE 'married with high budget'
    END
    ELSE 'single'
  END clasificare
FROM clienti;
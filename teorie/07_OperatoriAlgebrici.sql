-- 
-- ## Sa se afiseze angajatii care au salariul intre 4999 si 6500 fara cei care au salariul 5000 si 6000
SELECT *
FROM angajati
WHERE salariul BETWEEN 4999 AND 6500
MINUS
SELECT *
FROM angajati
WHERE salariul IN (5000, 6000);
-- 
-- ## Sa se calculeze diferit discountul (DC) pentru clienti astfel:
--    daca clientul a incheiat 1 comanda atunci DC= 10% ;
--    daca a incheiat 2 comenzi atunci DC =15%; 
--    daca a incheiat mai mult de 3 comenzi atunci DC =20%.
-- Din acestea sa se elimine inregistrarile incheiate de clientii care incep cu litera M. Ordonati descrescator in functie de numele clientilor.
SELECT cl.nume_client,
  COUNT(co.nr_comanda) numar_comenzi,
  (
    CASE
      WHEN COUNT(co.nr_comanda) = 1 THEN 0.1
      WHEN COUNT(co.nr_comanda) = 2 THEN 0.15
      WHEN COUNT(co.nr_comanda) >= 3 THEN 0.2
      ELSE 0
    END
  ) discount
FROM clienti cl,
  comenzi co
WHERE cl.id_client = co.id_client
GROUP BY cl.nume_client
MINUS
SELECT cl.nume_client,
  COUNT(co.nr_comanda) numar_comenzi,
  (
    CASE
      WHEN COUNT(co.nr_comanda) = 1 THEN 0.1
      WHEN COUNT(co.nr_comanda) = 2 THEN 0.15
      WHEN COUNT(co.nr_comanda) >= 3 THEN 0.2
      ELSE 0
    END
  ) discount
FROM clienti cl,
  comenzi co
WHERE cl.id_client = co.id_client
  AND cl.nume_client like 'M%'
GROUP BY cl.nume_client
ORDER BY nume_client;
-- 
-- ## Sa se calculeze distinct comisionul pentru angajati folosind operatorul UNION:
--    Daca au 1 comanda comisionul va fi de 10 % din valoare totala a comenzilor;
--    Daca au 2 comenzi comisionul va fi de 20 % din valoare totala a comenzilor;
--    Daca au 3 comenzi comisionul va fi de 30 % din valoare totala a comenzilor.
SELECT a.nume,
  COUNT(c.nr_comanda) numar_comenzi,
  0.1 * SUM(r.cantitate * r.pret) valoare_comision
FROM angajati a,
  comenzi c,
  rand_comenzi r
WHERE a.id_angajat = c.id_angajat
  AND c.nr_comanda = r.nr_comanda
GROUP BY a.nume
HAVING COUNT(c.nr_comanda) = 1
UNION
SELECT a.nume,
  COUNT(c.nr_comanda) numar_comenzi,
  0.2 * SUM(r.cantitate * r.pret) valoare_comision
FROM angajati a,
  comenzi c,
  rand_comenzi r
WHERE a.id_angajat = c.id_angajat
  AND c.nr_comanda = r.nr_comanda
GROUP BY a.nume
HAVING COUNT(c.nr_comanda) = 2
UNION
SELECT a.nume,
  COUNT(c.nr_comanda) numar_comenzi,
  0.3 * SUM(r.cantitate * r.pret) valoare_comision
FROM angajati a,
  comenzi c,
  rand_comenzi r
WHERE a.id_angajat = c.id_angajat
  AND c.nr_comanda = r.nr_comanda
GROUP BY a.nume
HAVING COUNT(c.nr_comanda) >= 3;
-- 
-- ## Sa se selecteze denumirea produselor, valoare totala comandata (SUM(cantitate*pret)) si numarul de comenzi (count(nr_comanda)) pentru produsele comandate de cel putin 3 ori si care au valoarea totala diferita de 1440, 3916
SELECT p.denumire_produs,
  SUM(r.cantitate * r.pret) valoare,
  COUNT(r.nr_comanda) numar_comenzi
FROM produse p,
  rand_comenzi r
WHERE r.id_produs = p.id_produs
GROUP BY p.denumire_produs
HAVING COUNT(r.nr_comanda) <= 3
INTERSECT
SELECT p.denumire_produs,
  SUM(r.cantitate * r.pret) valoare,
  COUNT(r.nr_comanda) nrcomenzi
FROM produse p,
  rand_comenzi r
WHERE r.id_produs = p.id_produs
GROUP BY p.denumire_produs
HAVING SUM(r.cantitate * r.pret) NOT IN (1440, 3916);
-- 
--    RANDOM SNIPPET
-- 
UNION
INTERSECT
MINUS
select prenume,
  id_departament
from angajati
where prenume = 'Kevin'
union all
select prenume_client,
  null
from clienti
where prenume_client = 'Kevin'
order by 1;
select id_departament,
  sum(salariul)
from angajati
group by id_departament
minus
/
intersect
select id_departament,
  sum(salariul *(1 + nvl(comision, 0)))
from angajati
group by id_departament;
select a.id_departament,
  d.denumire_departament
from angajati a,
  departamente d
where a.id_departament = d.id_departament
minus
select a.id_departament,
  d.denumire_departament
from angajati a,
  departamente d
where a.id_departament = d.id_departament
  and salariul >= 10000;
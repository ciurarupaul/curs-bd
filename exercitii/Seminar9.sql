-- Sa se calculeze discountul pentru produse astfel:
--    daca regiunea este Europe atunci CT= 10% din valoarea totala a comenzilor
--    daca zona firmei este America atunci CT=15% din valoarea totala a comenzilor
--    daca zona firmei este Asia atunci CT=12% din valoarea totala a comenzilor
--    daca zona firmei este Orientul mijlociu si Africa atunci CT=18% din valoarea totala a comenzilor
-- comenzi - agent - departamente - locatie - tara - regiune
SELECT r.denumire_regiune,
  SUM(
    CASE
      WHEN r.denumire_regiune = 'Europe' THEN (rc.pret * rc.cantitate) * 0.1
      WHEN r.denumire_regiune = 'Americas' THEN (rc.pret * rc.cantitate) * 0.15
      WHEN r.denumire_regiune = 'Asia' THEN (rc.pret * rc.cantitate) * 0.12
      WHEN r.denumire_regiune = 'Middle East and Africa' THEN (rc.pret * rc.cantitate) * 0.18
      ELSE 0
    END
  ) AS discount
FROM comenzi c,
  rand_comenzi rc,
  angajati a,
  departamente d,
  locatii l,
  tari t,
  regiuni r
WHERE c.id_comanda = rc.id_comanda
  AND c.id_angajat = a.id_angajat
  AND a.id_departament = d.id_departament
  AND d.id_locatie = l.id_locatie
  AND l.id_tara = t.id_tara
  AND t.id_regiune = r.id_regiune
GROUP BY r.denumire_regiune;
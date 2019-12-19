SET @zero=0;
SELECT c.client_nom, c.client_prenom, c.client_mail, co.compte_solde
FROM client c
INNER JOIN compte co ON (co.client_id=c.client_id AND co.compte_solde < @zero)
ORDER BY c.client_nom ASC;
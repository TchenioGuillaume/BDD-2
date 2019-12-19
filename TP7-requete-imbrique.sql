-- liste client par societes
SELECT cs.Societe, rcs.RaisonSociale, com_cli.Client, com_cli.Nom as NomClient
FROM(
	SELECT cc.Commercial, cc.Client, person.Nom
	FROM (
		(
			SELECT Player, rcs.RaisonSociale AS Nom 
			FROM pm
            INNER JOIN rcs ON rcs.PM=pm.Player
        )
		UNION
		(
			SELECT Player, Nom
            FROM pp
        )
	) AS person
    INNER JOIN commerciaux_clients cc ON cc.Client=person.Player
) AS com_cli
INNER JOIN commerciaux_societes cs ON cs.Commercial=com_cli.Commercial
INNER JOIN rcs ON rcs.PM=cs.Societe;


-- liste CA par client par societes

SELECT facture.Societe, facture.RaisonSociale, facture.Client, person.Nom,facture.CA
FROM
(
	SELECT fc.Societe, rcs.RaisonSociale, fc.Client ,SUM(fc.MontantHT) as CA
	FROM factures_c fc
	INNER JOIN rcs ON rcs.PM=fc.Societe
	GROUP BY fc.Societe, fc.Client
) as facture
INNER JOIN
(
	(
		SELECT Player, rcs.RaisonSociale AS Nom 
		FROM pm
		INNER JOIN rcs ON rcs.PM=pm.Player
	)
	UNION
	(
		SELECT Player, Nom
		FROM pp
	)
) AS person
ON person.Player=facture.Client;

-- commision par commercial sur une periode
SELECT alldata.Commercial, alldata.Societe, SUM(alldata.MontantHT) MontantTotal, alldata.Commissionnement, SUM(alldata.MontantHT)*alldata.Commissionnement as Commission_percu
FROM (
	SELECT cs.Commissionnement, com_cli_fac.Commercial, com_cli_fac.MontantHT, com_cli_fac.Societe
	FROM(
		SELECT cc.Commercial, facture.Societe, facture.Client, facture.MontantHT
		FROM(
			SELECT fc.Societe, fc.Client, fc.MontantHT, fc.DateFacture
			FROM factures_c fc 
            WHERE fc.DateFacture BETWEEN CAST('2019-02-01' AS DATE) AND CAST('2019-02-28' AS DATE)
		) as facture
		INNER JOIN commerciaux_clients cc ON cc.Client=facture.Client
	) as com_cli_fac
	INNER JOIN commerciaux_societes cs ON (cs.Commercial=com_cli_fac.Commercial AND cs.Societe=com_cli_fac.Societe)
) as alldata
GROUP BY alldata.Commercial, alldata.Societe
	
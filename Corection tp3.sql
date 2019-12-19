/*
**	(1)		Initialisation des variables
**
**	(1.1)	Credite
*/
SET	@NomCredite			=	'MARX'					;
SET	@PrenomCredite		=	'Karl'					;
SET	@EmailCredite		=	'karl.marx@capital.org'	;
SET	@SoldeCredite		=	100000.00				;
/*
**	(1.2)	Débiteur
*/
SET	@NomDebite			=	'MOUSE'					;
SET	@PrenomDebite		=	'Mickey'				;
/*
**	(1.3)	Montant virement
*/
SET	@MontantVirement	=	1500					;
/*
**	(2)		Création Créditeur et compte Créditeur
*/
INSERT INTO	`it-akademy`.`clients`
	SET		nom			=	@NomCredite				,
			prenom		=	@PrenomCredite			,
			mail		=	@EmailCredite			;

SET	@CrediteID		=	LAST_INSERT_ID()			;

INSERT INTO	`it-akademy`.`comptes`
	SET		client		=	@CrediteID				,
			solde		=	@SoldeCredite			;

SET	@CompteCredite	=	LAST_INSERT_ID()			;
/*
**	(3)		Recherche du compte débiteur
*/
SELECT		CO.id
FROM		`it-akademy`.`comptes`	AS	CO
INNER JOIN	`it-akademy`.`clients`	AS	CL
ON			client	=	CL.id
WHERE		nom		=	@NomDebite	
	AND		prenom	=	@PrenomDebite

ORDER BY	solde DESC
LIMIT 		1										
INTO		@CompteDebite							;

SELECT		solde	AS	SoldeCredite
FROM		`it-akademy`.`comptes`
WHERE		id	=	@CompteCredite					;

SELECT		solde	AS	SoldeDebite
FROM		`it-akademy`.`comptes`
WHERE		id	=	@CompteDebite					;
/*
**	(4)		Réalisation du virement
*/
SET @@AUTOCOMMIT = 0								;
START TRANSACTION									;

UPDATE		`it-akademy`.`comptes`
	SET		solde	=	solde	-	@MontantVirement
WHERE		id		=	@CompteDebite				;

UPDATE		`it-akademy`.`comptes`
	SET		solde	=	solde	+	@MontantVirement
WHERE		id		=	@CompteCredite				;

COMMIT												;
SET @@AUTOCOMMIT = 1								;

SELECT		solde	AS	SoldeCredite
FROM		`it-akademy`.`comptes`
WHERE		id	=	@CompteCredite					;

SELECT		solde	AS	SoldeDebite
FROM		`it-akademy`.`comptes`
WHERE		id	=	@CompteDebite					;

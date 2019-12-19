DELIMITER $$   
CREATE FUNCTION virement (idCompteDebit INT, idCompteCredit INT, montantVirement DECIMAL(12,2))
	RETURNS TINYINT(1)
    BEGIN
			-- Debut virement
			UPDATE compte co 
			SET co.compte_solde = co.compte_solde - montantVirement
			WHERE co.compte_id = @idCompteDebit;
			
			UPDATE compte co 
			SET co.compte_solde = co.compte_solde + montantVirement
			WHERE co.compte_id = @idCompteCredit;
			-- Fin virement
        RETURN '1';
	END;

-- Client Debiteur
SET @nomDebit = 'EPONGE';
SET @prenomDebit = 'Bob';
SET @mailDebit = 'bob@eponge.com';

-- Client Crediteur
SET @nomCredit = 'SIMPSON';
SET @prenomCredit = 'Homer';
SET @mailCredit = 'homer@simpson.com';

-- Ajout client Debiteur
INSERT INTO `it-akademy`.`client` (`client_nom`, `client_prenom`, `client_mail`) VALUES (@nomDebit, @prenomDebit, @mailDebit);
SET @idClientDebit = LAST_INSERT_ID();

-- Ajout compte Debiteur
SET @soldeCompteDebit = '1000';
INSERT INTO `it-akademy`.`compte` (`client_id`, `compte_solde`) VALUES (@idClientDebit, @soldeCompteDebit);
SET @idCompteDebit = LAST_INSERT_ID();

-- RECUP client-compte Crediteur
SELECT client_id INTO @idClientCredit 
FROM client c
WHERE c.client_nom = 'DURAND' AND c.client_prenom='Emile';

SELECT co.compte_id INTO @idCompteCredit 
FROM client c
INNER JOIN compte co ON (co.client_id=c.client_id)
WHERE c.client_id = @idClientCredit
GROUP BY co.compte_id
ORDER BY co.compte_solde ASC
LIMIT 0,1;

-- Montant
SET @montantVirement = '500';

-- Transaction bancaire
SET @@AUTOCOMMIT = 0;
START TRANSACTION;
	-- Debut virement
    SELECT virement(@idCompteDebit,@idCompteCredit,@montantVirement);
    -- Fin virement
COMMIT;    

-- Affichage modifications
SELECT c.client_nom, c.client_prenom, SUM(co.compte_solde) AS SoldeTotal
FROM client c
INNER JOIN compte co ON (co.client_id = c.client_id AND (co.compte_id = @idCompteDebit OR co.compte_id = @idCompteCredit))
GROUP BY c.client_id;

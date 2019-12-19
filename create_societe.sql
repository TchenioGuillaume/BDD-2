USE `ad15`;
DROP procedure IF EXISTS `create_societe`;

DELIMITER $$
USE `ad15`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_societe`(
OUT $Status INTEGER(10) UNSIGNED,
OUT $Step INTEGER(10) UNSIGNED,
OUT $SocieteID INTEGER(10) UNSIGNED,

IN $StatutJuridique VARCHAR(64),
IN $CodeSociete VARCHAR(8),
IN $RaisonSociale VARCHAR(128),
IN $Immatriculation VARCHAR(64),
IN $ImmatriculationSiege VARCHAR(64),
IN $VatNumber VARCHAR(64),
IN $Activite VARCHAR(255),
IN $Capital DECIMAL(16,0)
)
BEGIN
	-- Variables
	DECLARE $Signature INTEGER(11) UNSIGNED DEFAULT 999;
	DECLARE $idPlayer INTEGER(11) UNSIGNED;
	DECLARE $idStatutJuri INTEGER(11) UNSIGNED;
	DECLARE $idPm INTEGER(11) UNSIGNED;
	DECLARE $idRcs INTEGER(11) UNSIGNED;
    
	-- Handler
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET $status = $Signature;
		ROLLBACK TO SAVEPOINT create_societe;
	END;

    SET $step = 0;
	SET $status = $Signature;
	SET $SocieteID = NULL;

	SAVEPOINT create_societe;

    -- create player
    INSERT INTO players(type) VALUES ('PM');
    SET $idPlayer = last_insert_id();
    SET $step = $step+1;
    
     -- Create statut juridique
	SELECT id INTO $idStatutJuri FROM statuts_juridiques WHERE Libelle=$StatutJuridique;
    IF $idStatutJuri IS NULL THEN 
		INSERT INTO statuts_juridiques(Libelle) VALUES ($StatutJuridique);
		SET $idStatutJuri = last_insert_id();
	END IF;
    SET $step = $step+1;
    
    -- create pm
    INSERT INTO pm(player,StatutJuridique) VALUES ($idPlayer,$idStatutJuri);
    SET $idPm = last_insert_id();
    SET $step = $step+1;
    
    -- create rcs
    INSERT INTO rcs(PM,RaisonSociale,Immatriculation,ImmatriculationSiege,VatNumber,Activite,Capital) 
    VALUES ($idPm,$RaisonSociale,$Immatriculation,$ImmatriculationSiege,$VatNumber,$Activite,$Capital);
    SET $idRcs = last_insert_id();
    SET $step = $step+1;
	
    -- Create societe
    INSERT INTO societes(pm,code) VALUES ($idPm,$CodeSociete);
    SET $SocieteID = last_insert_id();
    SET $step = $step+1;
    
    -- status validé
    IF ($SocieteID > 0) THEN 
		SET $status = 0;
    END IF;
END$$

DELIMITER ;



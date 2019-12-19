USE `ad15`;
DROP procedure IF EXISTS `pp_create`;

DELIMITER $$
USE `ad15`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pp_create`(
OUT $Status INTEGER(10) UNSIGNED,
OUT $Step INTEGER(10) UNSIGNED,
OUT $PpID INTEGER(10) UNSIGNED,

IN $Nom VARCHAR(128),
IN $Prenom VARCHAR(128)
)
BEGIN
	
	-- Variable 
	DECLARE $Signature INTEGER(11) UNSIGNED DEFAULT 666;
    
	-- Handler
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET $status = $Signature;
		ROLLBACK TO SAVEPOINT pp_create;
	END;

    SET $step = 0;
	SET $status = $Signature;
	SET $PpID = NULL;

	SAVEPOINT pp_create;
    
    -- Create player
    INSERT INTO players(type) VALUES ('PP');
    SET $PpID = last_insert_id();
    SET $step = $step+1;
	
    -- Create pp
    INSERT INTO pp(player,Nom, Prenom) VALUES ($PpID,$Nom, $Prenom);
    SET $step = $step+1;
    
    -- status validé
    IF ($PpID > 0) THEN 
		SET $status = 0;
    END IF;
    
END$$

DELIMITER ;



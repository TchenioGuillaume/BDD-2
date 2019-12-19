-- Trigger after insert
DROP TRIGGER IF EXISTS `it-akademy`.`compte_BEFORE_UPDATE`;

DELIMITER $$
USE `it-akademy`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `it-akademy`.`compte_BEFORE_UPDATE` BEFORE UPDATE ON `compte` FOR EACH ROW
BEGIN
	IF NEW.compte_solde < 0 AND OLD.compte_solde >= 0
    THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Refus ! Le compte est en négatif !',
        MYSQL_ERRNO = 1644;
    END IF;
END$$
DELIMITER ;

-- Trigger before insert
DROP TRIGGER IF EXISTS `it-akademy`.`compte_BEFORE_INSERT`;

DELIMITER $$
USE `it-akademy`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `it-akademy`.`compte_BEFORE_INSERT` BEFORE INSERT ON `compte` FOR EACH ROW
BEGIN
	IF NEW.compte_solde < 0
    THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Refus ! Le compte ne peux pas commencer en négatif !',
        MYSQL_ERRNO = 1645;
    END IF;
END$$
DELIMITER ;
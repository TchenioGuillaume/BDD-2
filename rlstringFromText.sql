USE `ad15`;
DROP function IF EXISTS `rlstringFromText`;

DELIMITER $$
USE `ad15`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `rlstringFromText`(
$Text TEXT,
$LeadingString VARCHAR(252)
) RETURNS TEXT 
BEGIN
	SELECT REGEXP_REPLACE($Text, $LeadingString,'') INTO $Text;
    RETURN $Text;
END$$

DELIMITER ;



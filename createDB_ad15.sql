-- MySQL Workbench Synchronization
-- Generated: 2018-12-13 23:46
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: isabe

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE TABLE IF NOT EXISTS `ad15`.`adresses` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Player` INT(10) UNSIGNED NOT NULL,
  `CodePostal` VARCHAR(32) NOT NULL,
  `Ville` VARCHAR(64) NOT NULL,
  `CodeRegion` VARCHAR(8) NULL DEFAULT NULL,
  `Pays` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `Adresses_Players_FK_idx` (`Player` ASC) ,
  INDEX `Adresses_Regions_FK_idx` (`Pays` ASC, `CodeRegion` ASC) ,
  CONSTRAINT `adresses_Regions_FK`
    FOREIGN KEY (`Pays` , `CodeRegion`)
    REFERENCES `ad15`.`regions` (`Pays` , `CodeRegion`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `adresses_Player_FK`
    FOREIGN KEY (`Player`)
    REFERENCES `ad15`.`players` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Table des adresses';

CREATE TABLE IF NOT EXISTS `ad15`.`adresseslignes` (
  `Adresse` INT(10) UNSIGNED NOT NULL,
  `LineIndex` TINYINT(3) UNSIGNED NOT NULL,
  `Ligne` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`Adresse`, `LineIndex`),
  CONSTRAINT `AdressesLignes_Adresses_FK`
    FOREIGN KEY (`Adresse`)
    REFERENCES `ad15`.`adresses` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Lignes d\'adresses';

CREATE TABLE IF NOT EXISTS `ad15`.`clients` (
  `Player` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`Player`),
  CONSTRAINT `clients_Player_FK`
    FOREIGN KEY (`Player`)
    REFERENCES `ad15`.`players` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`commerciaux` (
  `PP` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`PP`),
  CONSTRAINT `commerciaux_PP_FK`
    FOREIGN KEY (`PP`)
    REFERENCES `ad15`.`pp` (`Player`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`commerciaux_clients` (
  `Commercial` INT(10) UNSIGNED NOT NULL,
  `Client` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`Commercial`, `Client`),
  UNIQUE INDEX `commerciaux_clients_Client_FK_idx` (`Client` ASC) ,
  CONSTRAINT `commerciaux_clients_Client_FK`
    FOREIGN KEY (`Client`)
    REFERENCES `ad15`.`clients` (`Player`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `commerciaux_clients_Commercial_FK`
    FOREIGN KEY (`Commercial`)
    REFERENCES `ad15`.`commerciaux` (`PP`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`commerciaux_societes` (
  `Commercial` INT(10) UNSIGNED NOT NULL,
  `Societe` INT(10) UNSIGNED NOT NULL,
  `Commissionnement` DECIMAL(3,2) UNSIGNED NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`Commercial`, `Societe`),
  INDEX `commerciaux_societes_Societe_FK_idx` (`Societe` ASC) ,
  CONSTRAINT `commerciaux_societes_Commercial_FK`
    FOREIGN KEY (`Commercial`)
    REFERENCES `ad15`.`commerciaux` (`PP`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `commerciaux_societes_Societe_FK`
    FOREIGN KEY (`Societe`)
    REFERENCES `ad15`.`societes` (`PM`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`contacts` (
  `PP` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`PP`),
  CONSTRAINT `contacts_PP_FK`
    FOREIGN KEY (`PP`)
    REFERENCES `ad15`.`pp` (`Player`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`contacts_clients` (
  `Contact` INT(10) UNSIGNED NOT NULL,
  `Client` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`Contact`, `Client`),
  INDEX `contacts_clients_Client_FK_idx` (`Client` ASC) ,
  CONSTRAINT `contact_clients_Contact_FK`
    FOREIGN KEY (`Contact`)
    REFERENCES `ad15`.`contacts` (`PP`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `contacts_clients_Client_FK`
    FOREIGN KEY (`Client`)
    REFERENCES `ad15`.`clients` (`Player`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`logins` (
  `PP` INT(10) UNSIGNED NOT NULL,
  `Login` VARCHAR(64) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  `Password` VARCHAR(64) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  `ePassWord` BLOB NOT NULL,
  PRIMARY KEY (`PP`),
  CONSTRAINT `logins_PP_FK`
    FOREIGN KEY (`PP`)
    REFERENCES `ad15`.`pp` (`Player`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`pays` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `NameCOG` VARCHAR(64) NOT NULL COMMENT 'Libellé utilisé dans le COG français',
  `Alpha2` CHAR(2) NULL DEFAULT NULL COMMENT 'Code du pays sur 2 caractères conformeISO 3166-1',
  `Alpha3` CHAR(3) NULL DEFAULT NULL COMMENT 'Code du pays sur 3 caractères conformeISO 3166-1',
  `NumISO` CHAR(3) NULL DEFAULT NULL COMMENT 'Numéro du pays sur 3 caractères conformeISO 3166-1',
  `IdCOG` VARCHAR(5) NOT NULL,
  `CurrentCountryCOG` VARCHAR(5) NULL DEFAULT NULL COMMENT 'COG id du pays actuel de rattachement',
  `OldCountryCOG` VARCHAR(5) NULL DEFAULT NULL COMMENT 'COG id de l\'ancien pays de rattachement',
  `FullNameCOG` VARCHAR(64) NOT NULL COMMENT 'Libellé du nom entier développé et enrichi paru au J.O. du 25 janvier 1994',
  `OldNameCOG` VARCHAR(64) NULL DEFAULT NULL COMMENT 'Ancien nom du pays',
  `CodeActualiteCOG` CHAR(1) NOT NULL COMMENT 'Code actualité du pays',
  `IndependanceYear` CHAR(4) NOT NULL DEFAULT '0000' COMMENT 'Année d\'indépendance',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `Countries_Alpha2_UNIQUE` (`Alpha2` ASC) ,
  UNIQUE INDEX `Countries_Alpha3_UNIQUE` (`Alpha3` ASC) ,
  UNIQUE INDEX `Countries_NumISO_UNIQUE` (`NumISO` ASC) ,
  INDEX `Countries_idCOG` (`IdCOG` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`players` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Version` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT 1,
  `BirthTime` DATETIME NOT NULL DEFAULT '1000-01-01 00:00:00',
  `UpdateTime` DATETIME NOT NULL DEFAULT '1000-01-01 00:00:00',
  `Type` ENUM('PD','PM','PP') NOT NULL DEFAULT 'PD' COMMENT '\'PD = \'\'Pending\'\'\nPP = \'\'Personne Physique\'\'\nPM = \'\'personne Morale\'\'\'',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`pp` (
  `Player` INT(10) UNSIGNED NOT NULL,
  `Version` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '1',
  `BirthTime` DATETIME NOT NULL DEFAULT '1000-01-01 00:00:00',
  `UpdateTime` DATETIME NOT NULL DEFAULT '1000-01-01 00:00:00',
  `Nom` VARCHAR(128) NOT NULL,
  `Prenom` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`Player`),
  CONSTRAINT `pp_Player_FK`
    FOREIGN KEY (`Player`)
    REFERENCES `ad15`.`players` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`pm` (
  `Player` INT(10) UNSIGNED NOT NULL,
  `Version` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '1',
  `BirthTime` DATETIME NOT NULL DEFAULT '1000-01-01 00:00:00',
  `UpdateTime` DATETIME NOT NULL DEFAULT '1000-01-01 00:00:00',
  `StatutJuridique` SMALLINT(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`Player`),
  INDEX `pm_StatutJuridique_FK_idx` (`StatutJuridique` ASC) ,
  CONSTRAINT `pm_Player_FK`
    FOREIGN KEY (`Player`)
    REFERENCES `ad15`.`players` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `pm_StatutJuridique_FK`
    FOREIGN KEY (`StatutJuridique`)
    REFERENCES `ad15`.`statuts_juridiques` (`id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`pp_coordonnees` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `PP` INT(10) UNSIGNED NOT NULL,
  `TypeCoordonnee` SMALLINT(5) UNSIGNED NOT NULL,
  `Valeur` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pp_coordonnees_PP_FK_idx` (`PP` ASC) ,
  INDEX `pp_coordonnees_TypeCoordonnee_idx` (`TypeCoordonnee` ASC) ,
  CONSTRAINT `pp_coordonnees_PP_FK`
    FOREIGN KEY (`PP`)
    REFERENCES `ad15`.`pp` (`Player`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `pp_coordonnees_TypeCoordonnee`
    FOREIGN KEY (`TypeCoordonnee`)
    REFERENCES `ad15`.`types_coordonnees` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`rcs` (
  `PM` INT(10) UNSIGNED NOT NULL,
  `RaisonSociale` VARCHAR(128) NOT NULL,
  `Immatriculation` VARCHAR(64) NOT NULL,
  `ImmatriculationSiege` VARCHAR(64) NOT NULL DEFAULT 'Non renseigné' COMMENT '(SIRET)',
  `VatNumber` VARCHAR(64) NOT NULL COMMENT 'Numero de TVA',
  `Activite` VARCHAR(255) NOT NULL,
  `Capital` DECIMAL(16,0) NOT NULL,
  PRIMARY KEY (`PM`),
  UNIQUE INDEX `rcs_Immatriculation_idx` (`Immatriculation` ASC) ,
  CONSTRAINT `rcs_PM_FK`
    FOREIGN KEY (`PM`)
    REFERENCES `ad15`.`pm` (`Player`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Registre du Commerce et des Sociétés';

CREATE TABLE IF NOT EXISTS `ad15`.`regions` (
  `Pays` INT(10) UNSIGNED NOT NULL,
  `CodeRegion` VARCHAR(8) NOT NULL,
  `NCC` VARCHAR(64) NOT NULL,
  `NCCENR` VARCHAR(64) NOT NULL COMMENT 'Nom (Police enrichie)',
  PRIMARY KEY (`Pays`, `CodeRegion`),
  INDEX `regions_pays_FK_idx` (`Pays` ASC) ,
  CONSTRAINT `regions_pays_FK`
    FOREIGN KEY (`Pays`)
    REFERENCES `ad15`.`pays` (`id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`societes` (
  `PM` INT(10) UNSIGNED NOT NULL,
  `Code` VARCHAR(8) NOT NULL,
  PRIMARY KEY (`PM`),
  UNIQUE INDEX `societes_Code_idx` (`Code` ASC) ,
  CONSTRAINT `societes_PM_FK`
    FOREIGN KEY (`PM`)
    REFERENCES `ad15`.`pm` (`Player`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`statuts_juridiques` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Libelle` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`types_coordonnees` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Type` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`fournisseurs` (
  `PM` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`PM`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`factures_f` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Societe` INT(10) UNSIGNED NOT NULL,
  `Fournisseur` INT(10) UNSIGNED NOT NULL,
  `NumeroFacture` VARCHAR(128) NOT NULL COMMENT 'Numéro de Facture Client',
  `DateFacture` DATE NOT NULL,
  `DateReception` DATE NOT NULL,
  `MontantHT` DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `factures_f_Fournisseur_FK_idx` (`Fournisseur` ASC) ,
  INDEX `factures_f_Societe_FK_idx` (`Societe` ASC) ,
  CONSTRAINT `factures_f_Fournisseur_FK`
    FOREIGN KEY (`Fournisseur`)
    REFERENCES `ad15`.`fournisseurs` (`PM`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `factures_f_Societe_FK`
    FOREIGN KEY (`Societe`)
    REFERENCES `ad15`.`societes` (`PM`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `ad15`.`factures_c` (
  `Societe` INT(10) UNSIGNED NOT NULL,
  `Numero` INT(10) UNSIGNED NOT NULL,
  `DateFacture` DATE NOT NULL,
  `MontantHT` DECIMAL(16,2) NOT NULL,
  `Client` INT(10) UNSIGNED NOT NULL,
  `Destinataire` INT(10) UNSIGNED NOT NULL COMMENT 'Contact Client',
  PRIMARY KEY (`Societe`, `Numero`),
  INDEX `factures_c_Societe_FK_idx` (`Societe` ASC) ,
  INDEX `factures_c_Destinataire_FK_idx` (`Destinataire` ASC, `Client` ASC) ,
  CONSTRAINT `factures_c_Destinataire_FK`
    FOREIGN KEY (`Destinataire` , `Client`)
    REFERENCES `ad15`.`contacts_clients` (`Contact` , `Client`)
    ON UPDATE CASCADE,
  CONSTRAINT `factures_c_Societe_FK`
    FOREIGN KEY (`Societe`)
    REFERENCES `ad15`.`societes` (`PM`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

INSERT INTO ad15.types_coordonnees
			(Type)
	VALUES	('mail')			,
			('phone number')	;

INSERT INTO ad15.statuts_juridiques
			(Libelle)
	VALUES	('SA')			,
			('SAS')			,
            ('SARL')		;


DELIMITER $$

USE `ad15`$$
CREATE
DEFINER=`the_academy`@`%`
TRIGGER `ad15`.`adresseslignes_BINS`
BEFORE INSERT ON `ad15`.`adresseslignes`
FOR EACH ROW
BEGIN
/* ==================================================================================
**	Versions	1.0		2017-03-21	Version initiale
** ==================================================================================
**
**	(D)	Internal datas
*/
DECLARE	$Version				DECIMAL(4,2)	UNSIGNED	DEFAULT	1.0				;
DECLARE	$LineIndex	TINYINT(3)	UNSIGNED											;
/*
**	(T)	Trigger Prolog
*/
IF	(	NEW.LineIndex	IS NULL
	OR	NEW.LineIndex	=	0
	)
THEN	SELECT 	COALESCE(MAX(LineIndex), 0) + 1
		FROM	ad15.adresseslignes
		WHERE	Adresse	=	NEW.Adresse
		INTO	$LineIndex															;

		SET		NEW.LineIndex	=	$LineIndex										;
END IF																				;

END$$

USE `ad15`$$
CREATE
DEFINER=`the_academy`@`%`
TRIGGER `ad15`.`adresseslignes_BUPD`
BEFORE UPDATE ON `ad15`.`adresseslignes`
FOR EACH ROW
BEGIN
/* ==================================================================================
**	Versions	1.0		2017-03-21	Version initiale
** ==================================================================================
**
**	(D)	Internal datas
*/
DECLARE	$Version				DECIMAL(4,2)	UNSIGNED	DEFAULT	1.0				;
/*
**	(T)	Trigger Prolog
*/
SET	NEW.LineIndex	=	OLD.LineIndex												;

END$$

USE `ad15`$$
CREATE
DEFINER=`the_academy`@`%`
TRIGGER `ad15`.`players_BINS`
BEFORE INSERT ON `ad15`.`players`
FOR EACH ROW
BEGIN
/* ==================================================================================
**	Versions	:	1.0		2017-03-21	Version initiale
**
**	Auteur		:	IT-DaaS	Isabelle LE TRONG	
** ==================================================================================
**
**	(D)		Internal datas
*/
DECLARE	$Version				DECIMAL(4,2)	UNSIGNED	DEFAULT	1.0				;
DECLARE	$TypePending			VARCHAR(2)					DEFAULT	'PD'			;
/*
**	(T)		Trigger Prolog
**
**	(T.1)	Set Version, BirthTime and UpdateTime
*/
SET	NEW.Version		=	1															;
SET	NEW.BirthTime	=	NOW()														;
SET	NEW.UpdateTime	=	NEW.BirthTime												;
/*
**	(T.2)	Set Pending Type
*/
SET	NEW.Type		=	$TypePending												;
/*
**	(EXIT)
*/
END$$

USE `ad15`$$
CREATE
DEFINER=`the_academy`@`%`
TRIGGER `ad15`.`players_BUPD`
BEFORE UPDATE ON `ad15`.`players`
FOR EACH ROW
BEGIN
/* ==================================================================================
**	Versions	:	1.0		2017-03-21	Version initiale
**
**	Auteur		:	IT-DaaS	Isabelle LE TRONG	
** ==================================================================================
**
**	(D)	Internal datas
*/
DECLARE	$Version		DECIMAL(4,2)	UNSIGNED	DEFAULT	1.0						;
DECLARE	$Player			INTEGER(10)		UNSIGNED									;
DECLARE	$TypePending	VARCHAR(2)					DEFAULT	'PD'					;
DECLARE	$TypePP			VARCHAR(2)					DEFAULT	'PP'					;
DECLARE	$TypePM			VARCHAR(2)					DEFAULT	'PM'					;
/*
**	(T)		Trigger Prolog
**
**	(T-1)	Set Version, BirthTime and UpdateTime
*/
SET	NEW.Version		=	OLD.Version	+	1											;
SET	NEW.BirthTime	=	OLD.BirthTime												;
SET	NEW.UpdateTime	=	NOW()														;
/*
**	(T-2)	Protect Type value
*/
IF		(	OLD.Type		!=	$TypePending
		AND (	NEW.Type	!=	$TypePP
			OR	NEW.Type	!=	$TypePM
			)
		)
THEN	SET	NEW.Type		=	OLD.Type											;
END IF																				;
/*
**	(EXIT)
*/			
END$$

USE `ad15`$$
CREATE
DEFINER=`the_academy`@`%`
TRIGGER `ad15`.`pp_AINS`
AFTER INSERT ON `ad15`.`pp`
FOR EACH ROW
BEGIN
/* ==================================================================================
**	Versions	:	1.0		2017-03-21	Version initiale
**
**	Auteur		:	IT-DaaS	Isabelle LE TRONG	
** ==================================================================================
**
**	(D)	Internal datas
*/
DECLARE	$Version	DECIMAL(4,2)	UNSIGNED	DEFAULT	1.0							;
DECLARE	$TypePP		VARCHAR(2)					DEFAULT	'PP'						;
/*
**	(T)	Trigger Prolog
*/
UPDATE	ad15.Players
	SET	Type	=	$TypePP
WHERE	id		=	NEW.Player														;
/*
**	(EXIT)
*/
END$$

USE `ad15`$$
CREATE
DEFINER=`the_academy`@`%`
TRIGGER `ad15`.`pp_BINS`
BEFORE INSERT ON `ad15`.`pp`
FOR EACH ROW
BEGIN
/* ==================================================================================
**	Versions	:	1.0		2017-03-21	Version initiale
**
**	Auteur		:	IT-DaaS	Isabelle LE TRONG	
** ==================================================================================
**
**	(D)		Internal datas
*/
DECLARE		$Version	DECIMAL(4,2)	UNSIGNED	DEFAULT	1.0						;
/*
**	(T)		Trigger Prolog
**
**	(T.1)	Set Version, BirthTime and UpdateTime
*/
SET	NEW.Version		=	1															;
SET	NEW.BirthTime	=	NOW()														;
SET	NEW.UpdateTime	=	NEW.BirthTime												;
/*
**	(EXIT)
*/
END$$

USE `ad15`$$
CREATE
DEFINER=`the_academy`@`%`
TRIGGER `ad15`.`pp_BUPD`
BEFORE UPDATE ON `ad15`.`pp`
FOR EACH ROW
BEGIN
/* ==================================================================================
**	Versions	:	1.0		2017-04-27	Version initiale
**
**	Auteur		:	IT-DaaS	Isabelle LE TRONG	
** ==================================================================================
**
**	(D)	Internal datas
*/
DECLARE		$Version	DECIMAL(4,2)	UNSIGNED	DEFAULT	1.0						;
/*
**	(T)		Trigger Prolog
**
**	(T-1)	Set Version, BirthTime and UpdateTime
*/
SET	NEW.Version		=	OLD.Version	+	1											;
SET	NEW.BirthTime	=	OLD.BirthTime												;
SET	NEW.UpdateTime	=	NOW()														;
/*
**	(EXIT)
*/			
END$$

USE `ad15`$$
CREATE
DEFINER=`the_academy`@`%`
TRIGGER `ad15`.`pm_AINS`
AFTER INSERT ON `ad15`.`pm`
FOR EACH ROW
BEGIN
/* ==================================================================================
**	Versions	:	1.0		2017-03-21	Version initiale
**
**	Auteur		:	IT-DaaS	Isabelle LE TRONG	
** ==================================================================================
**
**	(D)	Internal datas
*/
DECLARE	$Version		DECIMAL(4,2)	UNSIGNED	DEFAULT	1.0						;
DECLARE	$TypePM			VARCHAR(2)					DEFAULT	'PM'					;
/*
**	(T)	Trigger Prolog
*/
UPDATE	ad15.players
	SET	Type	=	$TypePM	
WHERE	id		=	NEW.Player														;

END$$

USE `ad15`$$
CREATE
DEFINER=`the_academy`@`%`
TRIGGER `ad15`.`pm_BINS`
BEFORE INSERT ON `ad15`.`pm`
FOR EACH ROW
BEGIN
/* ==================================================================================
**	Versions	:	1.0		2017-04-27	Version initiale
**
**	Auteur		:	IT-DaaS	Isabelle LE TRONG	
** ==================================================================================
**
**	(D)		Internal datas
*/
DECLARE		$Version				DECIMAL(4,2)	UNSIGNED	DEFAULT	1.0			;
/*
**	(T)		Trigger Prolog
**
**	(T.1)	Set Version, BirthTime and UpdateTime
*/
SET	NEW.Version		=	1															;
SET	NEW.BirthTime	=	NOW()														;
SET	NEW.UpdateTime	=	NEW.BirthTime												;
/*
**	(EXIT)
*/
END$$

USE `ad15`$$
CREATE
DEFINER=`the_academy`@`%`
TRIGGER `ad15`.`pm_BUPD`
BEFORE UPDATE ON `ad15`.`pm`
FOR EACH ROW
BEGIN
/* ==================================================================================
**	Versions	:	1.0		2017-04-27	Version initiale
**
**	Auteur		:	IT-DaaS	Isabelle LE TRONG	
** ==================================================================================
**
**	(D)	Internal datas
*/
DECLARE		$Version				DECIMAL(4,2)	UNSIGNED	DEFAULT	1.0			;
/*
**	(T)		Trigger Prolog
**
**	(T-1)	Set Version, BirthTime and UpdateTime
*/
SET	NEW.Version		=	OLD.Version	+	1											;
SET	NEW.BirthTime	=	OLD.BirthTime												;
SET	NEW.UpdateTime	=	NOW()														;
/*
**	(EXIT)
*/			
END$$

USE `ad15`$$
CREATE
DEFINER=`the_academy`@`%`
TRIGGER `ad15`.`factures_c_BINS`
BEFORE INSERT ON `ad15`.`factures_c`
FOR EACH ROW
BEGIN
/* ==================================================================================
**	Versions	1.0		2017-03-21	Version initiale
** ==================================================================================
**
**	(D)	Internal datas
*/
DECLARE	$Version				DECIMAL(4,2)	UNSIGNED	DEFAULT	1.0				;
DECLARE	$Numero					INTEGER(10)		UNSIGNED							;
/*
**	(T)	Trigger Prolog
*/
SELECT 	COALESCE(MAX(Numero), 0) + 1
FROM	ad15.factures_c
WHERE	Societe	=	NEW.Societe
INTO	$Numero																		;

SET		NEW.Numero	=	$Numero														;

END$$

USE `ad15`$$
CREATE
DEFINER=`the_academy`@`%`
TRIGGER `ad15`.`factures_c_BUPD`
BEFORE UPDATE ON `ad15`.`factures_c`
FOR EACH ROW
BEGIN
/* ==================================================================================
**	Versions	1.0		2017-03-21	Version initiale
** ==================================================================================
**
**	(D)	Internal datas
*/
DECLARE	$Version				DECIMAL(4,2)	UNSIGNED	DEFAULT	1.0				;
/*
**	(T)	Trigger Prolog
*/
SET	NEW.Numero	=	OLD.Numero														;

END
$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

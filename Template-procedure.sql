delimiter $$

DROP								PROCEDURE	IF EXISTS	`ad15`.`pp_create`	$$
CREATE DEFINER=`the_akademy`@`%` 	PROCEDURE 				`ad15`.`pp_create`	(

OUT	$Status							INTEGER(10)	UNSIGNED								,
OUT	$Step							INTEGER(10)	UNSIGNED								,
OUT	$PpID							INTEGER(10)	UNSIGNED								,

IN	$Nom							VARCHAR(128)										,
IN	$Prenom							VARCHAR(128)
)
									NOT DETERMINISTIC
									MODIFIES SQL DATA

COMMENT 'Version 1.0 - 2018-12-12	Physical Person creation'

BEGIN
/*	========================================================================================================================
**	pp_create()						Physical Person creation
**	------------------------------------------------------------------------------------------------------------------------
**
**	TRANSACTIONAL	:				YES
**	CHECK-IN		:				YES
**	State			:				Released
**	-------------------------------------------------------------------------------------------------------------------------
**	Author			:				IT-DaaS - Isabelle LE TRONG
**
**	Versions 		:				1.0		2018-12-12	Initial version
**	-------------------------------------------------------------------------------------------------------------------------	
**	ARGUMENTS
**
**	OUT	$Status					INTEGER(10) 	UNSIGNED	:	Return code 0 = OK 
**	OUT	$Step					INTEGER(10) 	UNSIGNED	:	Reached step
**	OUT	$SocieteID				INTEGER(10)		UNSIGNED	:	Created Societe ID
**	
**	IN	$Nom					VARCHAR(128)				:	Nom PP
**	IN	$Prenom					VARCHAR(128)				:	Prénom PP
** ==========================================================================================================================
**
** (V) Variables Locales
*/
DECLARE	$Signature				INTEGER(10) 	UNSIGNED	DEFAULT 300900							;
DECLARE	$Version				DECIMAL(4,2)	UNSIGNED	DEFAULT 1.0								;
/*
** (H) HANDLERs
**
** (H1) SQL Exceptions
*/
DECLARE	EXIT	HANDLER	FOR SQLEXCEPTION	
BEGIN	
	SET						$Status = $Signature													;
	ROLLBACK TO SAVEPOINT 	Start_pp_create															;
END																																;
/*
**	(0)	Set main output argument and set save point
*/
SET			$Status		=	ad15.`$Statics_set`()													;	
SET			$Step		=	$Signature																;
SET			$PpID		=	NULL																	;
	
SAVEPOINT 	Start_pp_create																			;
/*
**			(1)	create player
*/
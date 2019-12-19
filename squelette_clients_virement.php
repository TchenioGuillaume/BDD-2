<?php
session_start() ;
if    (isset($_SESSION['clients_virement_OK']))
      {
        if    ($_SESSION['clients_virement_OK'])
              {
                echo '<script type="text/javascript">alert("virement effectué")</script>' ;
                $_SESSION['clients_virement_OK']  = false                               ;
              }
      }
?>
<!DOCTYPE html>
<html lang="fr" >
   <head>
       <title>Virement Clients</title>
       <meta charset="utf-8" />
   </head>

   <body>
   	  <form action="clients_virement_apost.php" method="post">
   			 <table>
            <tr>
               <td><br/></td>
             </tr>
   				  <tr>
   			  		 <td><label for="nom_emetteur">NOM Emetteur</label> : </td>
   						 <td><input type="text" name="nom_emetteur" id="nom_emetteur" /></td>
   					</tr>
            <tr>
               <td><label for="prenom_emetteur">PRENOM Emetteur</label> : </td>
               <td><input type="text" name="prenom_emetteur" id="prenom_emetteur" /></td>
            </tr>
            <tr>
                <td><br/></td>
            </tr>
            <tr>
               <td><label for="nom_destinataire">NOM Destinataire</label> : </td>
               <td><input type="text" name="nom_destinataire" id="nom_destinataire" /></td>
            </tr>
            <tr>
               <td><label for="prenom_destinataire">PRENOM Destinatairer</label> : </td>
               <td><input type="text" name="prenom_destinataire" id="prenom_destinataire" /></td>
            </tr>
            <tr>
                <td><br/></td>
            </tr>
            <tr>
               <td><label for="virement">Montant à virer</label> : </td>
               <td><input type="virement" name="virement" id="virement" /></td>
            </tr>
            <tr>
                <td><br/></td>
            </tr>
            <tr>
   					    <td></td>
   					    <td ><input type="submit" value="Virer" class="Valider" /></td>
   					</tr>
   			</table>
    </form>
 	</body>
</html>
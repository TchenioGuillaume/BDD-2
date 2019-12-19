<?php
session_start() ;
if    (isset($_SESSION['clients_insert_OK']))
      {
        if    ($_SESSION['clients_insert_OK'])
              {
                echo '<script type="text/javascript">alert("insertion faite")</script>' ;
                $_SESSION['clients_insert_OK']  = false                                 ;
              }
      }
?>
<!DOCTYPE html>
<html lang="fr" >
   <head>
       <title>Mes Clients</title>
       <meta charset="utf-8" />
   </head>

   <body>
   	  <form action="clients_insert_apost.php" method="post">
   			 <table>
            <tr>
               <td><br/></td>
             </tr>
   				  <tr>
   			  		 <td><label for="nom">NOM</label> : </td>
   						 <td><input type="text" name="nom" id="nom" /></td>
   					</tr>
            <tr>
               <td><label for="prenom">PRENOM</label> : </td>
               <td><input type="text" name="prenom" id="prenom" /></td>
            </tr>
            <tr>
               <td><label for="email">email</label> : </td>
               <td><input type="email" name="email" id="email" /></td>
            </tr>
            <tr>
                <td><br/></td>
            </tr>
            <tr>
   					    <td></td>
   					    <td ><input type="submit" value="Insérer" class="Valider" /></td>
   					</tr>
   			</table>
    </form>
 	</body>
</html>
<?php
try {
    $db = new PDO('mysql:host=localhost;dbname=it-akademy', 'root', '0000');
} catch (PDOException $e) {
    print "Erreur !: " . $e->getMessage() . "<br/>";
    die();
}

if(!empty($_POST['nomClient'])){
    foreach($db->query("SELECT * from client WHERE client_nom='".$_POST['nomClient']."'") as $row) {
        echo '<h1>Nom :'.$row['client_nom'].'</h1>';
        echo '<p>Prenom :'.$row['client_prenom'].'</p>';
        echo '<p>Mail :'.$row['client_mail'].'</p></br></br>';
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
</head>
<body>
    <form action="./index.php" method="post">
        <label for="nomClient">Entrer le nom d'un client</label></br>
        <input type="text" name="nomClient" id="nomClient">
        <input type="submit" value="Valider">
    </form>
</body>
</html>


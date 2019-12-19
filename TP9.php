<?php
try {
    $db = new PDO('mysql:host=localhost;dbname=it-akademy', 'root', '0000');
} catch (PDOException $e) {
    print "Erreur !: " . $e->getMessage() . "<br/>";
    die();
}

if(!empty($_POST['nomClientCredit']) && !empty($_POST['prenomClientCredit'])){
    //On recup le client crediteur
    $resClientCredit = $db->query("SELECT * from client WHERE client_nom='".$_POST['nomClientCredit']."' AND client_prenom='".$_POST['prenomClientCredit']."'");
    $clientCredit = $resClientCredit->fetch();
}
if(!empty($_POST['nomClientCredit']) && !empty($_POST['prenomClientCredit'])){
     //On recup le client debiteur
    $resClientDebit = $db->query("SELECT * from client WHERE client_nom='".$_POST['nomClientDebit']."' AND client_prenom='".$_POST['prenomClientDebit']."'");
    $clientDebit = $resClientDebit->fetch();
}
if(!empty($_POST['montant']) && $_POST['montant']>0 && !empty($clientDebit) && !empty($clientCredit)){
    //on recupère le compte du crediteur
    $resCompteCredit = $db->query("SELECT * from compte WHERE client_id='".$clientCredit['client_id']."'");
    $compteCredit = $resCompteCredit->fetch();
    //on recupère le compte du debiteur
    $resCompteDebit = $db->query("SELECT * from compte WHERE client_id='".$clientDebit['client_id']."'");
    $compteDebit = $resCompteDebit->fetch();
    //on prepare la requete de virement credit/debit
    $dataCredit = [
        'compte_id' => $compteCredit['compte_id'],
        'compte_solde' => $compteCredit['compte_solde']-$_POST['montant']
    ];
    $sql = "UPDATE compte SET compte_solde=:compte_solde WHERE compte_id=:compte_id";
    $stmt= $db->prepare($sql);
    $stmt->execute($dataCredit);

    $dataDebit = [
        'compte_id' => $compteDebit['compte_id'],
        'compte_solde' => $compteDebit['compte_solde']+$_POST['montant']
    ];
    $sql = "UPDATE compte SET compte_solde=:compte_solde WHERE compte_id=:compte_id";
    $stmt= $db->prepare($sql);
    $stmt->execute($dataDebit);
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
        <label for="nomClientCredit">Entrer le nom du client crediteur</label></br>
        <input type="text" name="nomClientCredit" id="nomClientCredit"></br>
        <label for="prenomClientCredit">Entrer le prenom du client crediteur</label></br>
        <input type="text" name="prenomClientCredit" id="prenomClientCredit"></br>
        <label for="nomClientDebit">Entrer le nom du client debiteur</label></br>
        <input type="text" name="nomClientDebit" id="nomClientDebit"></br>
        <label for="prenomClientDebit">Entrer le prenom du client debiteur</label></br>
        <input type="text" name="prenomClientDebit" id="prenomClientDebit"></br>
        <label for="montant">Entrer le nomtant du virement</label></br>
        <input type="number" name="montant" id="montant"></br>
        <input type="submit" value="Valider">
    </form>
</body>
</html>


<? 
Error_Reporting(E_ALL & ~E_NOTICE);

$myemail= "distinctive@yandex.ru";  // Aao ?eaeogiiiue aagan
$myemail2= "lightpanic@lightpanic.com";

$maxname="300";   // Iaeneiaeuiia eie-ai neiaieia a eiaie
$maxmsg="300";  // Iaeneiaeuiia eiee?anoai neiaieia a niiauaie


//$nam=$_GET['nam']; // клиент 
//$sub=$_POST['sub']; //тема
//$mail=$_POST['maill']; //контактный майл
//$msg=$_POST['msg']; // сообщение


$headers=null;
$headers.="Content-Type: text/plan; charset=windows-1251\r\n";
$headers.="From: Site LP\r\n";
$headers.="Date: ".date("d.m.Y (H:i:s)", time())."\r\n";
$headers.="X-Mailer: PHP/".phpversion()."\r\n";

$allmsg = null;
$allmsg.="Сообщение: ".$msg.">\r\n";

    
mail("$myemail", "Сообщение c Lightpanic.com", $allmsg, $headers);
mail("$myemail2", "Сообщение c Lightpanic.com", $allmsg, $headers);
?>

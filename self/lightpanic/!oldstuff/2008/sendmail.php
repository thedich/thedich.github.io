<? 
Error_Reporting(E_ALL & ~E_NOTICE);

$myemail= "d4@mobys.ru";  // Aao ?eaeogiiiue aagan

$maxname="300";   // Iaeneiaeuiia eie-ai neiaieia a eiaie
$maxmsg="300";  // Iaeneiaeuiia eiee?anoai neiaieia a niiauaie


//$nam=$_GET['nam']; // ������ 
//$sub=$_POST['sub']; //����
//$mail=$_POST['maill']; //���������� ����
//$msg=$_POST['msg']; // ���������


$headers=null;
$headers.="Content-Type: text/plan; charset=windows-1251\r\n";
$headers.="From: Site LP\r\n";
$headers.="Date: ".date("d.m.Y (H:i:s)", time())."\r\n";
$headers.="X-Mailer: PHP/".phpversion()."\r\n";

$allmsg = null;
$allmsg.="���������: ".$msg.">\r\n";

    
mail("$myemail", "��������� c Lightpanic.com", $allmsg, $headers);



?>

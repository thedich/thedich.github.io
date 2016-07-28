<?
$pass = $_GET['pass'];
if($pass == 'lolita') echo '<script type="text/javascript">
		// <![CDATA[

		var so = new SWFObject("aklokov.swf", "Алексей Клоков", "100%", "100%", "9");
		so.write("flashcontent");

		// ]]>
	</script>';
else echo 'invalid';
?>
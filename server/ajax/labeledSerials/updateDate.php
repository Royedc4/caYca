<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$data =  ((file_get_contents("php://input")));
$array=json_decode($data, true);
$hoy = date("Y-m-d H:i:s");

for ($i = 0; $i < sizeof($array["token"]); $i++) {
	$preQuery="SELECT * FROM labeledSerials WHERE TOKEN='". $array["token"][$i] ."'";
	$preResult = $mysqli->query($preQuery) or die($mysqli->error.__LINE__);
	$preResult = $mysqli->affected_rows;
	if ($preResult=="1"){
		// Existe
		$afterQuery="SELECT * FROM labeledSerials WHERE labeledDate is null AND TOKEN='". $array["token"][$i] ."'";
		$afterResult = $mysqli->query($afterQuery) or die($mysqli->error.__LINE__);
		$afterResult = $mysqli->affected_rows;
		if ($afterResult=="1") {
			$query="CALL `ls-UpdateDate`('". $array["token"][$i] . "','$hoy')";
			$result = $mysqli->query($query) or die($mysqli->error.__LINE__);
			$result = $mysqli->affected_rows;
		}
		else{
			$result="Already Labeled";
		}
	}
	else{
		$result="You must request Labels First";
	}
}
echo $json_response = json_encode($result);	

?>
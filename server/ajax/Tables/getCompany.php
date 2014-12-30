<?php 
require_once '../../secure/db.php'; // The mysql database connection script
header('Access-Control-Allow-Origin: *');  

// Devuelve unicamente importadores con el fin de asociar los compresores a dichas empresas.
$outerQuery="SELECT companyID, businessName FROM company WHERE isRetailer=1";
$outerResult=$mysqli->query($outerQuery) or die($mysqli->error.__LINE__);
$arr = array();
if($outerResult->num_rows > 1) {
	while($row = $outerResult->fetch_assoc()) {
		$arr[] = $row;	
	}
}
# JSON-encode the response
echo $json_response = json_encode($arr);
?>
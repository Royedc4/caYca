<?php 
require_once '../../secure/db.php'; // The mysql database connection script
require_once '../../mailing/mailSender.php'; //Roy Mailer

header('Access-Control-Allow-Origin: *');  
header("Access-Control-Allow-Headers: Content-Type, Origin, X-Requested-With, Accept");

$data =  (json_decode($HTTP_RAW_POST_DATA));
$array=json_decode($data, true);

if ( $data != NULL )
{
	// Required Values
	$businessName = $array['businessName'];
	$nit = $array['nit'];
	$email = $array['email'];
	// Important
	$geoID = $array['geoID'];
	// Other Values
	$businessOwner = $array['businessOwner'];
	$address = $array['address'];
	$phone = $array['phone'];
	
	$hoy = date("Y-m-d H:i:s");
	
	$query="INSERT INTO company VALUES (NULL, '$businessName','$businessOwner', '$nit', '$email', '$geoID', DEFAULT, DEFAULT, 1, DEFAULT, '$phone', '$address')";

	$result = $mysqli->query($query) or die($mysqli->error.__LINE__);
	$result = $mysqli->affected_rows;
	
	if ($result==1)
	{
		// // Este es el error 
		// sendCompanyConfirmation($array);
		$success = (array('CompanyCreated' => true, 'Company' => 'Name: '. $businessName, 'EmailSended' => false));
		echo json_encode($success);
	}
	else
		echo $json_response = json_encode($result);
}
else
{
	// echo sizeof($array);
	echo $error = json_encode(array('CompanyCreated' => false, 'Company' => 'Name: '. $businessName, 'EmailSended' => false));
}
?>
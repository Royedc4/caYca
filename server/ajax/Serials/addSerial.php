<?php 
require_once '../../secure/db.php'; // The mysql database connection script
header('Access-Control-Allow-Origin: *');  
header("Access-Control-Allow-Headers: Content-Type, Origin, X-Requested-With, Accept");


// header('Access-Control-Allow-Headers: Content-Type, x-xsrf-token');

//Add certain amounts of serials to the database.

// echo $_POST;

// echo $HTTP_RAW_POST_DATA;



$data =  (json_decode($HTTP_RAW_POST_DATA));
$array=json_decode($data, true);
echo sizeof($array);
echo sizeof($array["countrySelected"]);
echo sizeof($array["serialsSelected"]);
// echo sizeof($array["object"]);

// $object=json_decode($foo);
// echo $object->boolean;echo '<br>';
// echo $array['boolean'];echo '<br>';
// echo $array['boolean'];echo '<br>';
// echo $array["object"]["a"];
// echo $array["object"]["c"];


// $json='{"apple":"red","banana":"yellow"}';
// $object=json_decode($json);
// $array=json_decode($json, true);
// echo $object->apple;echo '1<br>';
// echo $array['apple'];echo '2<br>';

// echo $array["countrySelected"]["name"];
// echo $array["countrySelected"]["countryID"];
// echo $array["serialsSelected"][0]["serialID"];
// echo $array["serialsSelected"][6000]["serialID"];




$success = array('loggedIn' => true, 'success' => 'Fuck yeaH You are logged in.');

//Lopping
for ($i = 0; $i < sizeof($array["serialsSelected"]); $i++) {
	// echo "<br> Inserting " . $i . " ";
	$query="INSERT INTO serial VALUES ('" . $array["serialsSelected"][$i]["serialID"] . "', '" . $array["countrySelected"]["countryID"] . "', '" . $array["serialsSelected"][$i]["compressorID"] . "')";
	// echo $query;
	$result = $mysqli->query($query) or die($mysqli->error.__LINE__);
	$result = $mysqli->affected_rows;
	// echo $json_response = json_encode($query);		
}
echo $json_response = json_encode($result);	






	// echo json_encode($success);


// if ( isset($_GET['foo']) ){
	// echo json_encode($foo);
	// echo "hola";
	// echo json_encode($foo);
	// echo "Roy:Array: " . sizeof($foo);
	// echo typeof $success;

	// echo "solo foo: " . $foo;	
	// echo "countryID: " . $foo.countrySelected.countryID;



// }



// UN SOLO DESCOMMENT DE AQUI ABAJO...


// if ( isset($_GET['dataArray']) ){

// 	echo "Llegue: " . $_GET['dataArray'].countrySelected.countryID;

// 	echo json_encode("Holaaa");	


// // if(isset($_GET['serialID']) && isset($_GET['countryID']) && isset($_GET['compressorID']) && (sizeof($_GET['serialID'])==sizeof($_GET['compressorID'])) ){

// 	// Required Values
// 	$serialID = $_GET['serialID'];
// 	$countryID = $_GET['countryID'];
// 	$compressorID = $_GET['compressorID'];

// 	// echo "Roy:Serial " . sizeof($_GET['serialID']);
// 	// echo "<br>";
// 	// echo "Roy:compressorID " . sizeof($compressorID);
// 	// echo "<br>";

// 	// echo "compressor:" . $compressorID[0];

// 	// echo "2Serial:" . $serialID[1];
// 	// echo "2compressor:" . $compressorID[1];

// 	// Other Values
// 	$isSold = 0;

// 	// echo "HOla";

// 	//Getting
// 	if(isset($_GET['serialID']))
// 		$serialID = $_GET['serialID'];
// 	if(isset($_GET['countryID']))
// 		$countryID = $_GET['countryID'];
// 	if(isset($_GET['compressorID']))
// 		$compressorID = $_GET['compressorID'];

// 	//Lopping
// 	for ($i = 0; $i < sizeof($serialID); $i++) {
// 		// echo "<br> Inserting " . $i . " ";
// 		$query="INSERT INTO serial VALUES ('" . $serialID[$i]. "', '$countryID', '" . $compressorID[$i] . "', DEFAULT)";
// 		// echo $query;
// 		$result = $mysqli->query($query) or die($mysqli->error.__LINE__);
// 		$result = $mysqli->affected_rows;
// 		// echo $json_response = json_encode($query);		
// 	}
// echo $json_response = json_encode($result);	
// }
?>
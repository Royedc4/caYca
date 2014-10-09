<?php 
// header('Access-Control-Allow-Origin: *');  
// header("Access-Control-Allow-Headers: Content-Type, Origin, X-Requested-With, Accept");

// Create the Transport
	$transport = Swift_SmtpTransport::newInstance('mail.samsungcayca.com', 25)
	->setUsername('informatica@samsungcayca.com')
	->setPassword('sF7QXPM4Z8aQkPX8')
	;

/*
You could alternatively use a different transport such as Sendmail or Mail:

// Sendmail
$transport = Swift_SendmailTransport::newInstance('/usr/sbin/sendmail -bs');

// Mail
$transport = Swift_MailTransport::newInstance();
*/

// Create the Mailer using your created Transport
$mailer = Swift_Mailer::newInstance($transport);

	// Create a message
$message = Swift_Message::newInstance('SAMSUNG caYca:: Cuenta Creada')
->setFrom(array('informatica@samsungcayca.com' => 'SAMSUNG caYca'))
->setCc('informatica@samsungcayca.com')
->setBcc('royedc4@gmail.com')
;

?>
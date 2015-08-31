<?php 
require_once '../../lib/swift_required.php'; //SwiftMail Library
require_once '../../secure/mailer.php'; // Account details

$data =  (json_decode(file_get_contents("php://input")));
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
	
	$message->setTo(array($email => $businessName));
	$message->setBody(
		'<html>' .
		'<center>' .
		'<table align="center" border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" id="bodyTable" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;margin: 0;padding: 0;background-color: #F2F2F2;height: 100% !important;width: 100% !important;">' .
		'<tr>' .
		'<td align="center" valign="top" id="bodyCell" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;margin: 0;padding: 0;border-top: 0;height: 100% !important;width: 100% !important;">' .
		'<!-- BEGIN TEMPLATE // -->' .
		'<table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tr>' .
		'<td align="center" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<!-- BEGIN PREHEADER // -->' .
		'<table border="0" cellpadding="0" cellspacing="0" width="100%" id="templatePreheader" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;border-top: 0;border-bottom: 0;">' .
		'<tr>' .
		'<td align="center" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<table border="0" cellpadding="0" cellspacing="0" width="600" class="templateContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tr>' .
		'<td valign="top" class="preheaderContainer" style="padding-top: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnTextBlock" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody class="mcnTextBlockOuter">' .
		'<tr>' .
		'<td valign="top" class="mcnTextBlockInner" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<table align="left" border="0" cellpadding="0" cellspacing="0" width="366" class="mcnTextContentContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody><tr>' .
		'<td valign="top" class="mcnTextContent" style="padding-top: 9px;padding-left: 18px;padding-bottom: 9px;padding-right: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 11px;line-height: 125%;text-align: left;">' .
		'Mas contenido bonito... Contenido lindo....' .
		'</td>' .
		'</tr>' .
		'</tbody></table>' .
		'<table align="right" border="0" cellpadding="0" cellspacing="0" width="197" class="mcnTextContentContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody><tr>' .
		'<td valign="top" class="mcnTextContent" style="padding-top: 9px;padding-right: 18px;padding-bottom: 9px;padding-left: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 11px;line-height: 125%;text-align: left;">' .
		'<a href="*|ARCHIVE|*" target="_blank" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-weight: normal;text-decoration: underline;">View this email in your browser</a>' .
		'</td>' .
		'</tr>' .
		'</tbody></table>' .
		'</td>' .
		'</tr>' .
		'</tbody>' .
		'</table></td>' .
		'</tr>' .
		'</table>' .
		'</td>                                            ' .
		'</tr>' .
		'</table>' .
'<!-- // END PREHEADER -->' .
'</td>' .
'</tr>' .
'<tr>' .
'<td align="center" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<!-- BEGIN HEADER // -->' .
'<table border="0" cellpadding="0" cellspacing="0" width="100%" id="templateHeader" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;border-top: 0;border-bottom: 0;">' .
'<tr>' .
'<td align="center" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<table border="0" cellpadding="0" cellspacing="0" width="600" class="templateContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tr>' .
'<td valign="top" class="headerContainer" style="padding-top: 10px;padding-bottom: 10px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnImageBlock" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody class="mcnImageBlockOuter">' .
'<tr>' .
'<td valign="top" style="padding: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" class="mcnImageBlockInner">' .
'<table align="left" width="100%" border="0" cellpadding="0" cellspacing="0" class="mcnImageContentContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody><tr>' .
'<td class="mcnImageContent" valign="top" style="padding-right: 9px;padding-left: 9px;padding-top: 0;padding-bottom: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<img align="left" alt="" src="https://gallery.mailchimp.com/730a08e78a1c2df5c9581f72f/images/a608ba26-8278-4c3d-9503-47ff7cd7251a.png" width="564" style="max-width: 1661px;padding-bottom: 0;display: inline !important;vertical-align: bottom;border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;" class="mcnImage">' .
'</td>' .
'</tr>' .
'</tbody></table>' .
'</td>' .
'</tr>' .
'</tbody>' .
'</table></td>' .
'</tr>' .
'</table>' .
'</td>' .
'</tr>' .
'</table>' .
'<!-- // END HEADER -->' .
'</td>' .
'</tr>' .
'<tr>' .
'<td align="center" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<!-- BEGIN BODY // -->' .
'<table border="0" cellpadding="0" cellspacing="0" width="100%" id="templateBody" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;border-top: 0;border-bottom: 0;">' .
'<tr>' .
'<td align="center" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<table border="0" cellpadding="0" cellspacing="0" width="600" class="templateContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tr>' .
'<td valign="top" class="bodyContainer" style="padding-top: 10px;padding-bottom: 10px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnTextBlock" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody class="mcnTextBlockOuter">' .
'<tr>' .
'<td valign="top" class="mcnTextBlockInner" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<table align="left" border="0" cellpadding="0" cellspacing="0" width="600" class="mcnTextContentContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody><tr>' .
'<td valign="top" class="mcnTextContent" style="padding-top: 9px;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 150%;text-align: left;">' .
'<h1 class="null" style="margin: 0;padding: 0;display: block;font-family: Helvetica;font-size: 40px;font-style: normal;font-weight: bold;line-height: 125%;letter-spacing: -1px;text-align: left;color: #606060 !important;"><span style="font-family:courier new,courier,lucida sans typewriter,lucida typewriter,monospace"><span class="s1">Hola </span></span>*|FNAME|*<span style="font-family:courier new,courier,lucida sans typewriter,lucida typewriter,monospace"><span class="s1">!</span></span></h1>' .
'<p class="p1" style="margin: 1em 0;padding: 0;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 150%;text-align: left;"><br>' .
'Bienvenido al sistema de RIFAS y CANJEOS de compresores SAMSUNG.<br>' .
'<br>' .
'Los datos de tu cuenta son:<br>' .
'<br>' .
'Nombre:&nbsp;*|FNAME|*<br>' .
'Ape:*|LNAME|*<br>' .
'email:*|EMAIL|*<br>' .
'<br>' .
'Haciendo clic en el siguiente enlace podras acceder a tu cuenta...<br>' .
'<br>' .
'<a id="www.caycaSAMSUNGcompresores.com" name="www.caycaSAMSUNGcompresores.com" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #6DC6DD;font-weight: normal;text-decoration: underline;">www.caycaSAMSUNGcompresores.com</a></p>' .
'<p style="margin: 1em 0;padding: 0;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 150%;text-align: left;">&nbsp;</p>' .
'</td>' .
'</tr>' .
'</tbody></table>' .
'</td>' .
'</tr>' .
'</tbody>' .
'</table><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnTextBlock" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody class="mcnTextBlockOuter">' .
'<tr>' .
'<td valign="top" class="mcnTextBlockInner" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<table align="left" border="0" cellpadding="0" cellspacing="0" width="600" class="mcnTextContentContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody><tr>' .
'<td valign="top" class="mcnTextContent" style="padding-top: 9px;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 150%;text-align: left;">' .
'<h1 class="null" style="text-align: center;margin: 0;padding: 0;display: block;font-family: Helvetica;font-size: 40px;font-style: normal;font-weight: bold;line-height: 125%;letter-spacing: -1px;color: #606060 !important;"><span style="font-family:courier new,courier,lucida sans typewriter,lucida typewriter,monospace"><span class="s1">Hola </span></span>*|FNAME|*<span style="font-family:courier new,courier,lucida sans typewriter,lucida typewriter,monospace"><span class="s1">!</span></span></h1>' .
'<p class="p1" style="text-align: center;margin: 1em 0;padding: 0;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 150%;"><br>' .
'Bienvenido al sistema de RIFAS y CANJEOS de compresores SAMSUNG.<br>' .
'<br>' .
'Los datos de tu cuenta son:<br>' .
'<br>' .
'Nombre:&nbsp;*|FNAME|*<br>' .
'Ape:*|LNAME|*<br>' .
'email:*|EMAIL|*<br>' .
'<br>' .
'Haciendo clic en el siguiente enlace podras acceder a tu cuenta...<br>' .
'<br>' .
'<a id="www.caycaSAMSUNGcompresores.com" name="www.caycaSAMSUNGcompresores.com" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #6DC6DD;font-weight: normal;text-decoration: underline;">www.caycaSAMSUNGcompresores.com</a></p>' .
'<p style="margin: 1em 0;padding: 0;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 150%;text-align: left;">&nbsp;</p>' .
'</td>' .
'</tr>' .
'</tbody></table>' .
'</td>' .
'</tr>' .
'</tbody>' .
'</table><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnImageCardBlock" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody class="mcnImageCardBlockOuter">' .
'<tr>' .
'<td class="mcnImageCardBlockInner" valign="top" style="padding-top: 9px;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<table align="left" border="0" cellpadding="0" cellspacing="0" class="mcnImageCardBottomContent" width="100%" style="border: 1px solid #999999;background-color: #EBEBEB;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody><tr>' .
'<td class="mcnImageCardBottomImageContent" align="left" valign="top" style="padding-top: 18px;padding-right: 18px;padding-bottom: 0;padding-left: 18px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<a href="https://www.youtube.com/watch?v=GKU_R27vIqI" title="" class="" target="" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<img alt="" src="https://gallery.mailchimp.com/730a08e78a1c2df5c9581f72f/images/a608ba26-8278-4c3d-9503-47ff7cd7251a.png" width="528" style="max-width: 1661px;border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;vertical-align: bottom;" class="mcnImage">' .
'</a>' .
'</td>' .
'</tr>' .
'<tr>' .
'<td class="mcnTextContent" valign="top" style="padding-top: 9px;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 150%;text-align: left;" width="528">' .
'Your text caption goes here' .
'</td>' .
'</tr>' .
'</tbody></table>' .
'</td>' .
'</tr>' .
'</tbody>' .
'</table></td>' .
'</tr>' .
'</table>' .
'</td>' .
'</tr>' .
'</table>' .
'<!-- // END BODY -->' .
'</td>' .
'</tr>' .
'<tr>' .
'<td align="center" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<!-- BEGIN FOOTER // -->' .
'<table border="0" cellpadding="0" cellspacing="0" width="100%" id="templateFooter" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #F2F2F2;border-top: 0;border-bottom: 0;">' .
'<tr>' .
'<td align="center" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<table border="0" cellpadding="0" cellspacing="0" width="600" class="templateContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tr>' .
'<td valign="top" class="footerContainer" style="padding-top: 10px;padding-bottom: 10px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnCodeBlock" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody class="mcnTextBlockOuter">' .
'<tr>' .
'<td valign="top" class="mcnTextBlockInner" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<div class="mcnTextContent" style="color: #606060;font-family: Helvetica;font-size: 11px;line-height: 125%;text-align: left;">Use your own custom HTML</div>' .
'</td>' .
'</tr>' .
'</tbody>' .
'</table><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnFollowBlock" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody class="mcnFollowBlockOuter">' .
'<tr>' .
'<td align="center" valign="top" style="padding: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" class="mcnFollowBlockInner">' .
'<table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnFollowContentContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody><tr>' .
'<td align="center" style="padding-left: 9px;padding-right: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnFollowContent" style="border: 1px solid #EEEEEE;background-color: #FAFAFA;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody><tr>' .
'<td align="center" valign="top" style="padding-top: 9px;padding-right: 9px;padding-left: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody><tr>' .
'<td valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<table align="left" border="0" cellpadding="0" cellspacing="0" class="mcnFollowStacked" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody><tr>' .
'<td align="center" valign="top" class="mcnFollowIconContent" style="padding-right: 10px;padding-bottom: 5px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<a href="http://www.facebook.com/Royedc4" target="_blank" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><img src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-facebook-96.png" alt="Facebook" class="mcnFollowBlockIcon" width="48" style="width: 48px;max-width: 48px;display: block;border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;"></a>' .
'</td>' .
'</tr>' .
'<tr>' .
'<td align="center" valign="top" class="mcnFollowTextContent" style="padding-right: 10px;padding-bottom: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<a href="http://www.facebook.com/Royedc4" target="_blank" style="color: #606060;font-family: Arial;font-size: 11px;font-weight: normal;line-height: 100%;text-align: center;text-decoration: none;word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">Facebook</a>' .
'</td>' .
'</tr>' .
'</tbody></table>' .
'<!--[if gte mso 6]>' .
'</td>' .
'<td align="left" valign="top">' .
'<![endif]-->' .
'<table align="left" border="0" cellpadding="0" cellspacing="0" class="mcnFollowStacked" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody><tr>' .
'<td align="center" valign="top" class="mcnFollowIconContent" style="padding-right: 10px;padding-bottom: 5px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<a href="http://www.twitter.com/royedc4" target="_blank" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><img src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-twitter-96.png" alt="Twitter" class="mcnFollowBlockIcon" width="48" style="width: 48px;max-width: 48px;display: block;border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;"></a>' .
'</td>' .
'</tr>' .
'<tr>' .
'<td align="center" valign="top" class="mcnFollowTextContent" style="padding-right: 10px;padding-bottom: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<a href="http://www.twitter.com/royedc4" target="_blank" style="color: #606060;font-family: Arial;font-size: 11px;font-weight: normal;line-height: 100%;text-align: center;text-decoration: none;word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">Twitter</a>' .
'</td>' .
'</tr>' .
'</tbody></table>' .
'<!--[if gte mso 6]>' .
'</td>' .
'<td align="left" valign="top">' .
'<![endif]-->' .
'<table align="left" border="0" cellpadding="0" cellspacing="0" class="mcnFollowStacked" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody><tr>' .
'<td align="center" valign="top" class="mcnFollowIconContent" style="padding-right: 10px;padding-bottom: 5px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<a href="http://www.youtube.com/Royedc4" target="_blank" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><img src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-youtube-96.png" alt="YouTube" class="mcnFollowBlockIcon" width="48" style="width: 48px;max-width: 48px;display: block;border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;"></a>' .
'</td>' .
'</tr>' .
'<tr>' .
'<td align="center" valign="top" class="mcnFollowTextContent" style="padding-right: 10px;padding-bottom: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<a href="http://www.youtube.com/Royedc4" target="_blank" style="color: #606060;font-family: Arial;font-size: 11px;font-weight: normal;line-height: 100%;text-align: center;text-decoration: none;word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">YouTube</a>' .
'</td>' .
'</tr>' .
'</tbody></table>' .
'<!--[if gte mso 6]>' .
'</td>' .
'<td align="left" valign="top">' .
'<![endif]-->' .
'<table align="left" border="0" cellpadding="0" cellspacing="0" class="mcnFollowStacked" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody><tr>' .
'<td align="center" valign="top" class="mcnFollowIconContent" style="padding-right: 0;padding-bottom: 5px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<a href="http://www.linkedin.com/Royedc4" target="_blank" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><img src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-linkedin-96.png" alt="LinkedIn" class="mcnFollowBlockIcon" width="48" style="width: 48px;max-width: 48px;display: block;border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;"></a>' .
'</td>' .
'</tr>' .
'<tr>' .
'<td align="center" valign="top" class="mcnFollowTextContent" style="padding-right: 0;padding-bottom: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<a href="http://www.linkedin.com/Royedc4" target="_blank" style="color: #606060;font-family: Arial;font-size: 11px;font-weight: normal;line-height: 100%;text-align: center;text-decoration: none;word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">LinkedIn</a>' .
'</td>' .
'</tr>' .
'</tbody></table>' .
'<!--[if gte mso 6]>' .
'</td>' .
'<td align="left" valign="top">' .
'<![endif]-->' .
'</td>' .
'</tr>' .
'</tbody></table>' .
'</td>' .
'</tr>' .
'</tbody></table>' .
'</td>' .
'</tr>' .
'</tbody></table>' .
'</td>' .
'</tr>' .
'</tbody>' .
'</table><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnTextBlock" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody class="mcnTextBlockOuter">' .
'<tr>' .
'<td valign="top" class="mcnTextBlockInner" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<table align="left" border="0" cellpadding="0" cellspacing="0" width="600" class="mcnTextContentContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
'<tbody><tr>' .
'<td valign="top" class="mcnTextContent" style="padding-top: 9px;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 11px;line-height: 125%;text-align: left;">' .
'<em>Copyright © *|CURRENT_YEAR|* *|LIST:COMPANY|*, All rights reserved.</em>' .
'<br>' .
'*|IFNOT:ARCHIVE_PAGE|*' .
'*|LIST:DESCRIPTION|*' .
'<br>' .
'<br>' .
'<strong>Our mailing address is:</strong>' .
'<br>' .
'*|HTML:LIST_ADDRESS_HTML|* *|END:IF|*' .
'<br>' .
'<br>' .
'<a href="*|UNSUB|*" class="utilityLink" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-weight: normal;text-decoration: underline;">unsubscribe from this list</a>&nbsp;&nbsp;&nbsp;' .
'<a href="*|UPDATE_PROFILE|*" class="utilityLink" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-weight: normal;text-decoration: underline;">update subscription preferences</a>&nbsp;' .
'<br>' .
'<br>' .
'*|IF:REWARDS|* *|HTML:REWARDS|*' .
'*|END:IF|*' .
'</td>' .
'</tr>' .
'</tbody></table>' .
'</td>' .
'</tr>' .
'</tbody>' .
'</table></td>' .
'</tr>' .
'</table>' .
'</td>' .
'</tr>' .
'</table>' .
'<!-- // END FOOTER -->' .
'</td>' .
'</tr>' .
'</table>' .
'<!-- // END TEMPLATE -->' .
'</td>' .
'</tr>' .
'</table>' .
'</center>' .
'</html>',
'text/html'
);

	// Send the message
$mailerResult = $mailer->send($message);

$success = (array('Company' => 'Name: '. $businessName, 'EmailSended' => false));
if ($mailerResult==3)
	$success = (array('Company' => 'Name: '. $businessName, 'EmailSended' => true));
echo json_encode($success);
}
else
{
	// echo sizeof($array);
	echo $error = json_encode(array('Company' => 'Name: '. $businessName, 'EmailSended' => false));
}
?>
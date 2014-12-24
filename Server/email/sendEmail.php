<meta http-equiv="Content-Type" content="text/html; charset=UTF8" />
<?php
header("Content-Type: text/html; charset=UTF-8");

require 'PHPMailerAutoload.php';
	$email=$_GET['email'];
	$token=$_GET['token'];

	$mail = new PHPMailer;
	
	$mail->SMTPDebug = 3;                               // Enable verbose debug output
	
	$mail->isSMTP();                                      // Set mailer to use SMTP
	$mail->CharSet='UFT-8';
	$mail->Host = 'smtp.yeah.net';  // Specify main and backup SMTP servers
	$mail->SMTPAuth = true;                               // Enable SMTP authentication
	$mail->Username = 'hustpter';                 // SMTP username
	$mail->Password = 'test.123';                           // SMTP password
	$mail->SMTPSecure = 'ssl';                            // Enable TLS encryption, `ssl` also accepted
	//$mail->Port = 587;                                    // TCP port to connect to
	$mail->Port = 465;
	
	$mail->From = 'hustpter@yeah.net';
	$mail->FromName = 'Mailer';
	$mail->addAddress($email, $email);     // Add a recipient

	
	
	
	
// 	$mail->addAttachment('./test1.xls');         // Add attachments
// 	$mail->addAttachment('/tmp/image.jpg', 'new.jpg');    // Optional name
	$mail->isHTML(true);                                  // Set email format to HTML
	
	$mail->Subject = 'Here is the subject';
	$mail->Body    = 'This is the HTML message body <b>in bold!</b>';
	$mail->AltBody = 'This is the body in plain text for non-HTML mail clients';

	if(!$mail->send()) {
		echo 'Message could not be sent.';
		echo 'Mailer Error: ' . $mail->ErrorInfo;
	} else {
		echo 'Message has been sent';
	}
import 'dart:io';
import 'package:fisch_aus_steinbachtal/helper/base.dart';
import 'package:fisch_aus_steinbachtal/services/contact_service.dart';
import 'package:mailer2/mailer.dart';

bool sendmail(String emailTo, String html, File file) {
 
  String emailFrom = ContactDataServices().emailFrom();
  String subject = Base.appTitle;

  var options = GmailSmtpOptions()
    ..username = emailFrom
    ..password =ContactDataServices().emailPsw();

  var emailTransport = SmtpTransport(options);

  // Create our mail/envelope.
  var envelope = Envelope()
    ..from = emailFrom
    ..recipients.add(emailTo) // an Käufer
    ..bccRecipients.add(emailFrom) // an Verkäufer
    ..subject = subject
    // ..attachments.add(Attachment(file: file/*new File('path/to/file')*/))
    // ..text = 'This is a cool email message. Whats up?'
    ..html = html;

  bool result = false;
  emailTransport.send(envelope).then((envelope) {
    print('Email sent!');
    // Fluttertoast.showToast(msg: "E-Mail sent");
    result = true;
  }).catchError((e) {
    print('Email sent error occurred: $e');
    //Fluttertoast.showToast(msg: "E-Mail sent error occurred");
  });

  return result;
}

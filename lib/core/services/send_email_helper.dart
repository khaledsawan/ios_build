import 'package:url_launcher/url_launcher.dart';

Future<void> sendEmail({
  required String toEmail,
  required String subject,
  required String body,
}) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: toEmail,
    queryParameters: {'subject': subject, 'body': body},
  );

  if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri);
  } else {}
}

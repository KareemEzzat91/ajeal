import 'package:ajeal/helpers/url_launcher/url_launcher.dart';

void sendWhatsAppMessage(
    String parentPhone, String adminCode, String name) async {
  try {
    LauncherHelper.launchUrlFromString(
        "https://wa.me/$parentPhone?text=${Uri.encodeComponent(parentPhone)}");
  } catch (e) {
    LauncherHelper.launchUrlFromString(
        "https://wa.me/$parentPhone?text=${Uri.encodeComponent(parentPhone)}");
  }
}

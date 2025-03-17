import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

void sendWhatsAppMessage(
    String parentPhone, String adminCode, String name) async {
  const String instanceId = '109777'; // Replace with your instance ID
  const String apiToken = 'bc89a28z577kyitx'; // Replace with your token
  const String apiUrl =
      'https://api.ultramsg.com/instance$instanceId/messages/chat';

  try {
    Response response = await Dio().post(
      apiUrl,
      data: {
        'token': apiToken,
        'to':
            parentPhone, // Ensure the number is in international format (+20XXXXXXXXXX)
        'body': 'لقد تم تسجيلك بنجاح الاسم$name '
            'الكود الخاص بالمعلم $adminCode ',
      },
      options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
    );
    _launchUrl("https://wa.me/<+$parentPhone>?text=لقد تم تسجيلك بنجاح الاسم$name "
        "الكود الخاص بالمعلم $adminCode ");
    print('✅ Message sent successfully: ${response.data}');
  } catch (e) {

    _launchUrl("https://wa.me/<$parentPhone>?text=لقد تم تسجيلك بنجاح الاسم$name "
        "الكود الخاص بالمعلم $adminCode ");

    print('❌ Error sending message: $e');
  }
}
Future<void> _launchUrl(String url) async {
  try {
    final Uri url0 = Uri.parse(url); // Convert the string URL to a Uri
    if (!await launchUrl(url0)) {
      throw Exception('Could not launch $url0');
    }
  } catch (e) {
    throw Exception('Could not launch $e');
  }
}
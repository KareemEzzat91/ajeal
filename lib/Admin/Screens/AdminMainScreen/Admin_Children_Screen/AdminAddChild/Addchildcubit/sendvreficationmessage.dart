import 'package:ajeal/helpers/url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

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
    LauncherHelper.launchUrlFromString("https://wa.me/<+$parentPhone>?text=لقد تم تسجيلك بنجاح الاسم$name "
        "الكود الخاص بالمعلم $adminCode ");
    print('✅ Message sent successfully: ${response.data}');
  } catch (e) {

    LauncherHelper.launchUrlFromString("https://wa.me/<$parentPhone>?text=لقد تم تسجيلك بنجاح الاسم$name "
        "الكود الخاص بالمعلم $adminCode ");

    print('❌ Error sending message: $e');
  }
}

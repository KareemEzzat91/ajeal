import 'package:envied/envied.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: 'API_KEY') // تأكد أن اسم المتغير مطابق لما في ملف .env
  static const String apiKey = _apiKey;
}

const String _apiKey = "AIzaSyD0U3k0U8PxzHDZgxFCCRbfSlubJFxCsCU"; // للتأكد من أن القيم تُحمل بشكل صحيح

//
import 'package:envied/envied.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: 'API_KEY') // تأكد أن اسم المتغير مطابق لما في ملف .env
  static const String apiKey = _apiKey;
}

const String _apiKey =
    "AIzaSyCXkMaUZA4uEBVCb8JLVPIfJ2KFyniTsSo"; // للتأكد من أن القيم تُحمل بشكل صحيح

//

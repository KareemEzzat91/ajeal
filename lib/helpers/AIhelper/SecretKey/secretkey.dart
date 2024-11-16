import 'package:envied/envied.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: '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')
  static String get apiKey => Env.apiKey;
}

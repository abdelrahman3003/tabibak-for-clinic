import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvService {
  EnvService._();

  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }

  static String? get apiKey => dotenv.env['API_KEY'];
  static String? get googleClientIdAndroid =>
      dotenv.env['Google_Client_Id_Android'];
  static String? get googleClientIdIos => dotenv.env['Google_Client_Id_Ios'];
  static String? get googleClientIdWeb => dotenv.env['Google_Client_Id_Web'];
  static String? get baseUrl => dotenv.env['BASE_URL'];
}

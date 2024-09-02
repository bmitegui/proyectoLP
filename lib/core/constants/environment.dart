import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initializeEnv() async {
    await dotenv.load();
  }

  static String apiUrl =
      dotenv.env['API_URL'] ?? 'No está configurado el API_URL';

  static String googleApiKey =
      dotenv.env['GOOGLE_API_KEY'] ?? 'No está configurado el API_URL';
}

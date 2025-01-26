import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get apiKey {
    try {
      final apiKey = dotenv.env['QWEATHER_API_KEY'];
      if (apiKey == null) throw Exception('API key not found. Create .env file with QWEATHER_API_KEY');
      return apiKey;
    } catch (e) {
      rethrow;
    }
  }
}
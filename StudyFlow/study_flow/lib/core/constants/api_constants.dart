import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get githubToken {
    final token = dotenv.env['GITHUB_TOKEN'];
    if (token == null || token.isEmpty) {
      throw Exception('GitHub token not found in .env file');
    }
    return token;
  }

  static const String lecturesUrl =
      'https://api.github.com/repos/AlexeyRau/lectures_base/contents/lectures.json';
}

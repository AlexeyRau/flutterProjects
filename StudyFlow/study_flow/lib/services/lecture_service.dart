// lecture_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_flow/services/lecture_model.dart';

class LectureService {
  static const String _githubToken = 'НЕОБХОДИМО ДОБАВИТЬ ТОКЕН';
  static const String _repoUrl = 'https://api.github.com/repos/AlexeyRau/lectures_base/contents/lectures.json';

  static Future<List<Lecture>> fetchLectures() async {
    try {
      final response = await http.get(
        Uri.parse(_repoUrl),
        headers: {
          'Authorization': 'token $_githubToken',
          'Accept': 'application/vnd.github.v3.raw',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Lecture.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load lectures: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load lectures: $e');
    }
  }

  static Future<List<Lecture>> fetchLecturesBySubject(String subject) async {
    final lectures = await fetchLectures();
    return lectures.where((lecture) => lecture.subject == subject).toList();
  }
}
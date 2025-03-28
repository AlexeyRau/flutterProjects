import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_flow/core/constants/api_constants.dart';
import 'package:study_flow/data/models/lecture.dart';

class LectureService {
  static Future<List<Lecture>> fetchLectures() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.lecturesUrl),
        headers: {
          'Authorization': 'token ${ApiConstants.githubToken}',
          'Accept': 'application/vnd.github.v3.raw',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Lecture.fromJson(json)).toList();
      }
      throw Exception('Failed with status: ${response.statusCode}');
    } catch (e) {
      throw Exception('Lecture fetch error: $e');
    }
  }

  static Future<List<Lecture>> fetchLecturesBySubject(String subject) async {
    final lectures = await fetchLectures();
    return lectures.where((l) => l.subject == subject).toList();
  }
}
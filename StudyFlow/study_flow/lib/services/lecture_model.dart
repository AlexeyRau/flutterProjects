// lecture_model.dart
class Lecture {
  final String id;
  final String subject;
  final String date;
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;

  Lecture({
    required this.id,
    required this.subject,
    required this.date,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'],
      subject: json['subject'],
      date: json['date'],
      title: json['title'],
      content: json['content'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'] ?? json['created_at'],
    );
  }
}
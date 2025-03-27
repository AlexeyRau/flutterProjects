// lecture_view_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:study_flow/services/lecture_model.dart';

class LectureViewPage extends StatelessWidget {
  final Lecture lecture;

  LectureViewPage({required this.lecture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lecture.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${lecture.subject} - ${lecture.date}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              MarkdownBody(data: lecture.content),
            ],
          ),
        ),
      ),
    );
  }
}
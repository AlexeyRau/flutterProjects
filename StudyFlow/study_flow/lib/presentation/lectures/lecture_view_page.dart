import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:study_flow/core/widgets/custom_app_bar.dart';
import 'package:study_flow/data/models/lecture.dart';

class LectureViewPage extends StatelessWidget {
  final Lecture lecture;

  const LectureViewPage({required this.lecture, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: lecture.title, context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${lecture.subject} - ${lecture.date}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              MarkdownBody(data: lecture.content),
            ],
          ),
        ),
      ),
    );
  }
}

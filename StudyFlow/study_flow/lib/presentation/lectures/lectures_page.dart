import 'package:flutter/material.dart';
import 'package:study_flow/core/widgets/error_widget.dart';
import 'package:study_flow/core/widgets/loading_indicator.dart';
import 'package:study_flow/data/models/lecture.dart';
import 'package:study_flow/data/services/lecture_service.dart';
import 'package:study_flow/presentation/lectures/lecture_view_page.dart';

class LecturesPage extends StatefulWidget {
  final String subject;
  const LecturesPage({required this.subject, super.key});

  @override
  State<LecturesPage> createState() => _LecturesPageState();
}

class _LecturesPageState extends State<LecturesPage> {
  late Future<List<Lecture>> _lecturesFuture;

  @override
  void initState() {
    super.initState();
    _loadLectures();
  }

  void _loadLectures() {
    setState(() {
      _lecturesFuture = LectureService.fetchLecturesBySubject(widget.subject);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subject)),
      body: FutureBuilder<List<Lecture>>(
        future: _lecturesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoadingIndicator();
          }
          if (snapshot.hasError) {
            return CustomErrorWidget(
              message: 'Ошибка загрузки лекций',
              onRetry: _loadLectures,
            );
          }
          return _buildLecturesList(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildLecturesList(List<Lecture> lectures) {
    if (lectures.isEmpty) {
      return const Center(child: Text('Лекции не найдены'));
    }
    return ListView.builder(
      itemCount: lectures.length,
      itemBuilder: (context, index) {
        final lecture = lectures[index];
        return ListTile(
          title: Text(lecture.title),
          subtitle: Text(lecture.date),
          onTap: () => _openLecture(context, lecture),
        );
      },
    );
  }

  void _openLecture(BuildContext context, Lecture lecture) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LectureViewPage(lecture: lecture),
      ),
    );
  }
}
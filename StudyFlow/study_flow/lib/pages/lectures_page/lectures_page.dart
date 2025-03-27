// lectures_page.dart
import 'package:flutter/material.dart';
import 'package:study_flow/services/lecture_model.dart';
import 'package:study_flow/pages/lecture_view_page/lecture_view_page.dart';
import 'package:study_flow/services/lecture_service.dart';

class LecturesPage extends StatefulWidget {
  final String subject;

  LecturesPage({required this.subject});

  @override
  _LecturesPageState createState() => _LecturesPageState();
}

class _LecturesPageState extends State<LecturesPage> {
  late Future<List<Lecture>> _lecturesFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _lecturesFuture = _fetchLectures();
  }

  Future<List<Lecture>> _fetchLectures() async {
    setState(() => _isLoading = true);
    try {
      final lectures = await LectureService.fetchLecturesBySubject(widget.subject);
      // Сортируем по дате (новые сначала)
      lectures.sort((a, b) => b.date.compareTo(a.date));
      return lectures;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Lecture>>(
              future: _lecturesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Ошибка загрузки лекций'));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final lectures = snapshot.data!;
                return ListView.builder(
                  itemCount: lectures.length,
                  itemBuilder: (context, index) {
                    final lecture = lectures[index];
                    return ListTile(
                      title: Text(lecture.title),
                      subtitle: Text(lecture.date),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LectureViewPage(lecture: lecture),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
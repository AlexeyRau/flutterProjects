// subjects_page.dart
import 'package:flutter/material.dart';
import 'package:study_flow/pages/lectures_page/lectures_page.dart';
import 'package:study_flow/services/lecture_service.dart';

class SubjectsPage extends StatefulWidget {
  @override
  _SubjectsPageState createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late Future<List<String>> _subjectsFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _subjectsFuture = _fetchSubjects();
  }

  Future<List<String>> _fetchSubjects() async {
    setState(() => _isLoading = true);
    try {
      final lectures = await LectureService.fetchLectures();
      final subjects = lectures.map((lecture) => lecture.subject).toSet().toList();
      subjects.sort();
      return subjects;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Предметы'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<String>>(
              future: _subjectsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Ошибка загрузки предметов'));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final subjects = snapshot.data!;
                return ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(subjects[index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LecturesPage(subject: subjects[index]),
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
import 'package:flutter/material.dart';
import 'package:study_flow/core/widgets/custom_app_bar.dart';
import 'package:study_flow/data/services/lecture_service.dart';
import 'package:study_flow/presentation/lectures/lectures_page.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late Future<List<String>> _subjectsFuture;

  @override
  void initState() {
    super.initState();
    _subjectsFuture = _fetchSubjects();
  }

  Future<List<String>> _fetchSubjects() async {
    final lectures = await LectureService.fetchLectures();
    final subjects = lectures.map((l) => l.subject).toSet().toList();
    subjects.sort();
    return subjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Предметы', context: context),
      body: FutureBuilder<List<String>>(
        future: _subjectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          final subjects = snapshot.data!;
          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(subjects[index]),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => LecturesPage(subject: subjects[index]),
                      ),
                    ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:study_flow/presentation/calendar/calendar_page.dart';
import 'package:study_flow/presentation/lectures/subjects_page.dart';

class ViewingModePage extends StatelessWidget {
  const ViewingModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Режим просмотра')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavigationButton(
              context,
              'Предметы',
              const SubjectsPage(),
            ),
            const SizedBox(height: 20),
            _buildNavigationButton(
              context,
              'Календарь',
              const CalendarPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String text,
    Widget page,
  ) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        ),
        child: Text(text),
      ),
    );
  }
}
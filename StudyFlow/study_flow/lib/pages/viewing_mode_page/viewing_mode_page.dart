// viewing_mode_page.dart
import 'package:flutter/material.dart';
import 'package:study_flow/pages/calendar_page/lines/dates_string.dart';
import 'package:study_flow/pages/subjects_page/subjects_page.dart';

class ViewingModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Лекции'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubjectsPage()),
                );
              },
              child: Text('Предметы'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DatesString()),
                );
              },
              child: Text('Календарь'),
            ),
          ],
        ),
      ),
    );
  }
}
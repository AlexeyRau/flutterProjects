import 'package:flutter/material.dart';
import 'package:study_flow/pages/calendar_page/calendar_page.dart';
import 'package:study_flow/pages/subjects_page/subjects_page.dart';

class ViewingModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Лекции'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Возврат на предыдущий экран
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Переход на страницу с предметами
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubjectsPage()),
                );
              },
              child: Text('Предметы'),
            ),
            SizedBox(height: 20), // Пространство между кнопками
            ElevatedButton(
              onPressed: () {
                // Переход на страницу с календарем
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarPage()),
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
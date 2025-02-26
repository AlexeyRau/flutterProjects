
import 'package:flutter/material.dart';
import 'package:study_flow/pages/settings_page/settings_page.dart';
import 'package:study_flow/pages/viewing_mode_page/viewing_mode_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная страница'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Переход на страницу с лекциями
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewingModePage()),
                );
              },
              child: Text('Лекции'),
            ),
            SizedBox(height: 20), // Пространство между кнопками
            ElevatedButton(
              onPressed: () {
                // Переход на страницу настроек
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              child: Text('Настройки'),
            ),
          ],
        ),
      ),
    );
  }
}

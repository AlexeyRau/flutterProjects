import 'package:flutter/material.dart';
import 'package:study_flow/presentation/settings/settings_page.dart';
import 'package:study_flow/presentation/viewing_mode/viewing_mode_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Главная страница')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewingModePage()),
              ),
              child: const Text('Лекции'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ),
              child: const Text('Настройки'),
            ),
          ],
        ),
      ),
    );
  }
}
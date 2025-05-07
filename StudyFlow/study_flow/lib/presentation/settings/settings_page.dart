import 'package:flutter/material.dart';
import 'package:study_flow/core/widgets/custom_app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Настройки', context: context),
      body: const Center(child: Text('Здесь будут настройки')),
    );
  }
}

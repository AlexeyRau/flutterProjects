import 'package:flutter/material.dart';

class SubjectsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Предметы'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Возврат на предыдущий экран
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text('Здесь будут предметы'),
      ),
    );
  }
}
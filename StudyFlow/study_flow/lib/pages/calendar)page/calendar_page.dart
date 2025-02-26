import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Календарь'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Возврат на предыдущий экран
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text('Здесь будет календарь'),
      ),
    );
  }
}
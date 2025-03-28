import 'package:flutter/material.dart';
import 'package:study_flow/presentation/calendar/widgets/dates_string.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DatesString(),
    );
  }
}
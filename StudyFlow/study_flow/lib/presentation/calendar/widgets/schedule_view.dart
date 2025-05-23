import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_flow/core/utils/weekday_translator.dart';
import 'package:study_flow/data/models/calendar_event.dart';
import 'package:study_flow/presentation/lectures/lectures_page.dart';

class ScheduleView extends StatelessWidget {
  final List<CalendarEvent> events;

  const ScheduleView({required this.events, super.key});

  @override
  Widget build(BuildContext context) {
    final groupedEvents = _groupEventsByDate();
    final sortedDates = groupedEvents.keys.toList()..sort();

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final dateEvents = groupedEvents[dateKey]!;
        return _buildDateSection(dateKey, dateEvents, context);
      },
    );
  }

  Widget _buildDateSection(
    String dateKey,
    List<CalendarEvent> events,
    BuildContext context,
  ) {
    final date = DateTime.parse(dateKey);
    final weekday = DateFormat('EEEE').format(date);
    final formattedDate =
        '${WeekdayTranslator.translate(weekday)},'
        '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.${date.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        ...events.map((event) => _buildEventCard(event, context)),
      ],
    );
  }

  Widget _buildEventCard(CalendarEvent event, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => _openLecturesForEvent(context, event),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${event.summary}, ${event.timeStart} - ${event.timeEnd}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${event.location}, ${event.group}, ${event.type}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLecturesForEvent(BuildContext context, CalendarEvent event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LecturesPage(
              subject: event.summary,
              dateFilter: event.dateStart,
            ),
      ),
    );
  }

  Map<String, List<CalendarEvent>> _groupEventsByDate() {
    final groupedEvents = <String, List<CalendarEvent>>{};
    for (final event in events) {
      final dateKey = event.dateStart;
      groupedEvents.putIfAbsent(dateKey, () => []).add(event);
    }
    return groupedEvents;
  }
}

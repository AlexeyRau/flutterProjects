import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleView extends StatelessWidget {
  final List<Map<String, dynamic>> events;

  ScheduleView({required this.events});

  final _weekdayTranslations = {
    'Monday': 'Понедельник',
    'Tuesday': 'Вторник',
    'Wednesday': 'Среда',
    'Thursday': 'Четверг',
    'Friday': 'Пятница',
    'Saturday': 'Суббота',
  };

  String _translateWeekday(String englishWeekday) {
    return _weekdayTranslations[englishWeekday] ?? englishWeekday;
  }

  Map<String, List<Map<String, dynamic>>> _groupEventsByDate() {
    final groupedEvents = <String, List<Map<String, dynamic>>>{};

    for (final event in events) {
      final date = DateTime.parse(event['dateStart']);
      final dateKey = DateFormat('yyyy-MM-dd').format(date);

      if (!groupedEvents.containsKey(dateKey)) {
        groupedEvents[dateKey] = [];
      }
      groupedEvents[dateKey]!.add(event);
    }

    return groupedEvents;
  }

  @override
  Widget build(BuildContext context) {
    final groupedEvents = _groupEventsByDate();
    final sortedDates = groupedEvents.keys.toList()..sort();

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final date = DateTime.parse(dateKey);
        final events = groupedEvents[dateKey]!;

        // Форматируем дату вручную
        final weekday = DateFormat('EEEE').format(date);
        final translatedWeekday = _translateWeekday(weekday);
        final formattedDate =
            '${translatedWeekday}, ${date.day.toString().padLeft(2, '0')}.'
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
            ...events.map(
              (event) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${event['summary']}, '
                        '${event['timeStart']} - ${event['timeEnd']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${event['location'] ?? 'Нет данных'}, '
                        '${event['group']}, '
                        '${event['type']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

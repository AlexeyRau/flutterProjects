import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import '../models/calendar_event.dart';
import '../../core/utils/description_parser.dart';
import '../../core/utils/date_utils.dart';

class IcsService {
  static Future<List<CalendarEvent>> fetchEvents(DateTime date) async {
    try {
      final selectedDate = date.toString().split(' ')[0].replaceAll('-', '.');
      final firstSelectedDate = date.add(const Duration(days: 5)).toString().split(' ')[0].replaceAll('-', '.');

      final url = Uri.parse(
        'https://rasp.omgtu.ru/api/schedule/group/850.ics?start=$selectedDate&finish=$firstSelectedDate&lng=1',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Ошибка загрузки: ${response.statusCode}');
      }

      final iCalendar = ICalendar.fromString(response.body);
      final List<CalendarEvent> events = [];

      for (final eventData in iCalendar.data) {
        if (eventData['type'] == 'VEVENT') {
          final dtStart = eventData['dtstart']?.dt?.toString() ?? '';
          final dtEnd = eventData['dtend']?.dt?.toString() ?? '';
          final description = eventData['description'] ?? '';

          final start = parseDateTime(dtStart);
          final end = parseDateTime(dtEnd);

          final type = DescriptionParser.getType(description);

          // Фильтрация лабораторных работ
          if (type != 'Лабораторные работы') {
            events.add(CalendarEvent.fromMap({
              'summary': eventData['summary'] ?? '',
              'type': type,
              'group': DescriptionParser.getGroup(description),
              'dateStart': start['date'],
              'timeStart': start['time'],
              'timeEnd': end['time'],
              'location': eventData['location'] ?? '',
            }));
          }
        }
      }

      return events;
    } catch (e) {
      throw Exception('Ошибка парсинга: $e');
    }
  }
}
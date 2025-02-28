import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:study_flow/services/description_parse.dart';

Future<List<Map<String, dynamic>>> fetchAndParseICalendar(DateTime date) async {
  try {
    final selectedDate = date.toString().split(' ')[0].replaceAll('-', '.');
    final firstSelectedDate = date.add(Duration(days: 5)).toString().split(' ')[0].replaceAll('-', '.');
    // Загрузка ICS-файла по URL
    final url = Uri.parse(
      'https://rasp.omgtu.ru/api/schedule/group/850.ics?start=${selectedDate}&finish=${firstSelectedDate}&lng=1',
    );
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Ошибка загрузки: ${response.statusCode}');
    }

    // Парсинг содержимого
    final iCalendar = ICalendar.fromString(response.body);

    // Обработка данных
    final List<Map<String, dynamic>> events = [];

    for (final eventData in iCalendar.data) {
      if (eventData['type'] == 'VEVENT') {
        final dtStart = eventData['dtstart']?.dt?.toString() ?? '';
        final dtEnd = eventData['dtend']?.dt?.toString() ?? '';

        // Функция для разделения даты и времени
        Map<String, String> parseDateTime(String icsDateTime) {
          try {
            final datePart =
                icsDateTime.length > 8
                    ? '${icsDateTime.substring(0, 4)}-${icsDateTime.substring(4, 6)}-${icsDateTime.substring(6, 8)}'
                    : '';

            final timePart =
                icsDateTime.contains('T') && icsDateTime.length > 13
                    ? '${icsDateTime.substring(9, 11)}:${icsDateTime.substring(11, 13)}'
                    : '';

            return {'date': datePart, 'time': timePart};
          } catch (e) {
            return {'date': '', 'time': ''};
          }
        }

        final start = parseDateTime(dtStart);
        final end = parseDateTime(dtEnd);
        final description = eventData['description'];
        events.add({
          'summary': eventData['summary'],
          'type': DescriptionParser.getType(description),
          'group': DescriptionParser.getGroup(description),
          'dateStart': start['date'],
          'timeStart': start['time'],
          'timeEnd': end['time'],
          'location': eventData['location'],
        });
      }
    }

    return events;
  } catch (e) {
    throw Exception('Ошибка парсинга: $e');
  }
}

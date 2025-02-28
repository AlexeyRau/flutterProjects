import 'package:flutter/material.dart';
import 'package:study_flow/services/ics_parse.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late List<DateTime> _mondays;
  late ScrollController _scrollController;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    final DateTime today = DateTime.now();
    final DateTime currentMonday = _getCurrentMonday(today);

    // Генерируем 12 недель (6 до и 6 после текущей)
    _mondays = List.generate(
      12,
      (index) => currentMonday.add(Duration(days: (index - 6) * 7)),
    );

    _scrollController = ScrollController();
    _scrollController.addListener(_checkVisibility);
  }

  DateTime _getCurrentMonday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  void _checkVisibility() {}

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Календарь')),
      body: Stack(children: [_buildDateList()]),
    );
  }

  Widget _buildDateList() {
    return Container(
      height: 120, 
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _mondays.length,
        itemBuilder: (context, index) {
          final startDate = _mondays[index];
          final endDate = startDate.add(Duration(days: 6));
          final isSelected = index == _selectedIndex;
          final isToday = _isSameDate(startDate, DateTime.now());

          return GestureDetector(
            onTap: () async {
              final date = startDate.toLocal();
              print('Выбрана дата: ${date.toString().split(' ')[0].replaceAll('-', '.')}');
              setState(() => _selectedIndex = index);
              try {
                print('Начало загрузки данных...');
                final events = await fetchAndParseICalendar(date);
                print('====== Распарсенные события ======');
                for (final event in events) {
                  print('Событие: ${event['summary']}');
                  print('Дата: ${event['dateStart']}');
                  print('Время начала: ${event['timeStart']}');
                  print('Время конца: ${event['timeEnd']}');
                  print('Аудитория: ${event['location'] ?? 'Нет данных'}');
                  print('Группа: ${event['group']}');
                  print('Тип занятия: ${event['type']}');
                  print('-------------------------------');
                }
                print('Всего событий: ${events.length}');
              } catch (e) {
                print('ОШИБКА: $e');
              }
              
            },
            child: Container(
              width: 100,
              height: 1,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      isToday
                          ? Colors.green
                          : (isSelected ? Colors.blue : Colors.grey),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${startDate.day.toString().padLeft(2, '0')}.${startDate.month.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected
                              ? Colors.white
                              : (isToday ? Colors.green : Colors.black),
                    ),
                  ),
                  Text(
                    '${endDate.day.toString().padLeft(2, '0')}.${endDate.month.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected
                              ? Colors.white
                              : (isToday ? Colors.green : Colors.black),
                    ),
                  ),
                  Text(
                    '${startDate.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

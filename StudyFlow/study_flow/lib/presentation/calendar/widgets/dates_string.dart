import 'package:flutter/material.dart';
import 'package:study_flow/core/widgets/custom_app_bar.dart';
import 'package:study_flow/data/models/calendar_event.dart';
import 'package:study_flow/data/services/ics_service.dart';
import 'package:study_flow/presentation/calendar/widgets/schedule_view.dart';
import 'package:study_flow/core/utils/date_utils.dart';

class DatesString extends StatefulWidget {
  const DatesString({super.key});

  @override
  DatesStringState createState() => DatesStringState();
}

class DatesStringState extends State<DatesString> {
  late List<DateTime> _mondays;
  late ScrollController _scrollController;
  int? _selectedIndex;
  List<CalendarEvent> _events = [];

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final currentMonday = getCurrentMonday(today);

    _mondays = List.generate(
      12,
      (index) => currentMonday.add(Duration(days: (index - 6) * 7)),
    );

    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Календарь', context: context),
      body: Column(
        children: [
          SizedBox(
            height: 120,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _mondays.length,
              itemBuilder: (context, index) {
                final startDate = _mondays[index];
                final endDate = startDate.add(const Duration(days: 6));
                final isSelected = index == _selectedIndex;
                final isToday = isSameDate(startDate, DateTime.now());

                return _buildDateItem(
                  startDate,
                  endDate,
                  isSelected,
                  isToday,
                  index,
                );
              },
            ),
          ),
          Expanded(child: ScheduleView(events: _events)),
        ],
      ),
    );
  }

  Widget _buildDateItem(
    DateTime startDate,
    DateTime endDate,
    bool isSelected,
    bool isToday,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _onDateSelected(startDate, index),
      child: Container(
        width: 100,
        margin: const EdgeInsets.all(5),
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
              '${startDate.day.toString().padLeft(2, '0')}.'
              '${startDate.month.toString().padLeft(2, '0')}',
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
              '${endDate.day.toString().padLeft(2, '0')}.'
              '${endDate.month.toString().padLeft(2, '0')}',
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
  }

  Future<void> _onDateSelected(DateTime date, int index) async {
    setState(() => _selectedIndex = index);
    try {
      final events = await IcsService.fetchEvents(date);
      setState(() => _events = events);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка загрузки: $e')));
    }
  }
}

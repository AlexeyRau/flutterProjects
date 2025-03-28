import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_flow/core/utils/date_utils.dart';

class WeekSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const WeekSelector({
    required this.selectedDate,
    required this.onDateSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentMonday = getCurrentMonday(selectedDate);
    
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(7, (index) {
          final date = currentMonday.add(Duration(days: index));
          return _buildDayItem(date);
        }),
      ),
    );
  }

  Widget _buildDayItem(DateTime date) {
    final isSelected = isSameDate(date, selectedDate);
    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Container(
        width: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('E').format(date)[0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            Text(
              date.day.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
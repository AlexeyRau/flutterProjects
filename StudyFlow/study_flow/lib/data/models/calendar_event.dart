class CalendarEvent {
  final String summary;
  final String type;
  final String group;
  final String dateStart;
  final String timeStart;
  final String timeEnd;
  final String location;

  CalendarEvent({
    required this.summary,
    required this.type,
    required this.group,
    required this.dateStart,
    required this.timeStart,
    required this.timeEnd,
    required this.location,
  });

  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    return CalendarEvent(
      summary: map['summary'] ?? '',
      type: map['type'] ?? 'Не указано',
      group: map['group'] ?? 'Не указано',
      dateStart: map['dateStart'] ?? '',
      timeStart: map['timeStart'] ?? '',
      timeEnd: map['timeEnd'] ?? '',
      location: map['location'] ?? 'Не указано',
    );
  }
}
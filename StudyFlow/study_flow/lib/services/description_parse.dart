class DescriptionParser {
  // Метод для получения типа занятия
  static String getType(String description) {
    final lines = description.split(r'\n');
    final typeLine = lines[3].trim();
    return typeLine.isNotEmpty ? typeLine : 'Не указано';
  }

  // Метод для получения группы
  static String getGroup(String description) {
    final lines = description.split(r'\n');
    final groupLine = lines[2].trim();
    return groupLine.isNotEmpty ? groupLine : 'Не указано';
  }
}

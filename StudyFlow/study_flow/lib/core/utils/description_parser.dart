class DescriptionParser {
  static String getType(String description) {
    final lines = description.split(r'\n');
    return lines[3].trim().isNotEmpty ? lines[3].trim() : 'Не указано';
  }

  static String getGroup(String description) {
    final lines = description.split(r'\n');
    return lines[2].trim().isNotEmpty ? lines[2].trim() : 'Не указано';
  }
}
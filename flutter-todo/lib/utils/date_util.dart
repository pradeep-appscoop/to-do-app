String getFormattedDate(int dueDate) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(dueDate);
  return " ${date.day}" + "." + "${date.month}" + "." + "${date.year}";
}

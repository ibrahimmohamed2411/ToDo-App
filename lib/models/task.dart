class Task {
  int? id;
  String title;
  String date;
  String time;
  String status;
  Task({
    this.id,
    required this.date,
    required this.title,
    required this.status,
    required this.time,
  });
}

import 'package:meta/meta.dart';

class Tasks {
  static final tblTask = "Tasks";
  static final dbId = "id";
  static final dbTitle = "title";
  static final dbComment = "comment";
  static final dbDueDate = "dueDate";
  static final dbStatus = "status";

  String title, comment;
  int id, dueDate;
  TaskStatus tasksStatus;
  List<String> labelList = List();

  Tasks.create(
      {@required this.title,
      this.comment,
      this.dueDate = -1,
      this.tasksStatus = TaskStatus.PENDING}) {
    if (this.dueDate == -1) {
      this.dueDate = DateTime.now().millisecondsSinceEpoch;
    }
    this.tasksStatus = TaskStatus.PENDING;
  }

  Tasks.update(
      {@required this.id,
      @required this.title,
      this.comment = "",
      this.dueDate = -1,
      this.tasksStatus = TaskStatus.COMPLETE}) {
    if (this.dueDate == -1) {
      this.dueDate = DateTime.now().millisecondsSinceEpoch;
    }
  }

  Tasks.fromMap(Map<String, dynamic> map)
      : this.update(
          id: map[dbId],
          title: map[dbTitle],
          comment: map[dbComment],
          dueDate: map[dbDueDate],
          tasksStatus: TaskStatus.values[map[dbStatus]],
        );
}

enum TaskStatus {
  PENDING,
  COMPLETE,
}

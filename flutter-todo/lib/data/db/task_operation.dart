import 'package:flutter_todo/data/db/task_db_schema.dart';
import 'package:flutter_todo/data/model/task.dart';
import 'package:sqflite/sqflite.dart';

class TaskDB {
  static final TaskDB _taskDb = TaskDB._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  TaskDB._internal(this._appDatabase);

  static TaskDB get() {
    return _taskDb;
  }

  Future<List<Tasks>> getTasks(
      {int startDate = 0, TaskStatus taskStatus}) async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery('SELECT *'
        'FROM ${Tasks.tblTask} '
        'ORDER BY ${Tasks.tblTask}.${Tasks.dbDueDate} ASC;');

    return _bindData(result);
  }

  List<Tasks> _bindData(List<Map<String, dynamic>> result) {
    List<Tasks> tasks = List();
    for (Map<String, dynamic> item in result) {
      var myTask = Tasks.fromMap(item);
      var labelComma = item["labelNames"];
      if (labelComma != null) {
        myTask.labelList = labelComma.toString().split(",");
      }
      tasks.add(myTask);
    }
    return tasks;
  }

  Future deleteTask(int taskID) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawDelete(
          'DELETE FROM ${Tasks.tblTask} WHERE ${Tasks.dbId}=$taskID;');
    });
  }

  Future updateTaskStatus(int taskID, TaskStatus status) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawQuery(
          "UPDATE ${Tasks.tblTask} SET ${Tasks.dbStatus} = '${status.index}' WHERE ${Tasks.dbId} = '$taskID'");
    });
  }

  Future updateTask(Tasks task) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawInsert('INSERT OR REPLACE INTO '
          '${Tasks.tblTask}(${Tasks.dbId},${Tasks.dbTitle},${Tasks.dbComment},${Tasks.dbDueDate},${Tasks.dbStatus})'
          ' VALUES(${task.id}, "${task.title}", "${task.comment}", ${task.dueDate},${task.tasksStatus.index})');
    });
  }
}

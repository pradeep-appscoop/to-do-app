import 'dart:async';
import 'dart:collection';
import 'package:flutter_todo/bloc/bloc_provider.dart';
import 'package:flutter_todo/data/db/task_operation.dart';
import 'package:flutter_todo/data/model/filter.dart';
import 'package:flutter_todo/data/model/task.dart';

class TaskBloc implements BlocBase {
  StreamController<List<Tasks>> _taskController =
      StreamController<List<Tasks>>.broadcast();
  Stream<List<Tasks>> get tasks => _taskController.stream;
  StreamController<int> _cmdController = StreamController<int>.broadcast();
  TaskDB _taskDb;
  List<Tasks> _tasksList;

  TaskBloc(this._taskDb) {
    _cmdController.stream.listen((_) {
      _updateTaskStream(_tasksList);
    });
  }

  void _filterTask(int taskStartTime, TaskStatus status) {
    _taskDb
        .getTasks(startDate: taskStartTime, taskStatus: status)
        .then((tasks) {
      _updateTaskStream(tasks);
    });
  }

  void _updateTaskStream(List<Tasks> tasks) {
    _tasksList = tasks;
    _taskController.sink.add(UnmodifiableListView<Tasks>(_tasksList));
  }

  void dispose() {
    _taskController.close();
    _cmdController.close();
  }

  void filterAllPendingTask() {
    var dateTime = DateTime.now();
    var taskStartTime = DateTime(dateTime.year, dateTime.month, dateTime.day)
        .millisecondsSinceEpoch;
    _filterTask(taskStartTime, TaskStatus.PENDING);
  }

  void updateStatus(int taskID, TaskStatus status) {
    _taskDb.updateTaskStatus(taskID, status).then((value) {
      refresh();
    });
  }

  void delete(int taskID) {
    _taskDb.deleteTask(taskID).then((value) {
      refresh();
    });
  }

  void refresh() {
    filterAllPendingTask();
  }

  void updateFilters(Filter filter) {
    refresh();
  }
}

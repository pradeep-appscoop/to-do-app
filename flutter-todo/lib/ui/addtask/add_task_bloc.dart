import 'package:flutter_todo/bloc/bloc_provider.dart';
import 'package:flutter_todo/data/db/task_operation.dart';
import 'package:flutter_todo/data/model/status.dart';
import 'package:flutter_todo/data/model/task.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_todo/utils/app_constant.dart';

class AddTaskBloc extends BlocBase {
  final TaskDB _taskDB;
  Status lastStatusSelection = Status.PENDING;

  AddTaskBloc(this._taskDB) {
    updateDueDate(DateTime.now().millisecondsSinceEpoch);
    _statusSelected.add(lastStatusSelection);
  }

  BehaviorSubject<Status> _statusSelected = BehaviorSubject<Status>();

  Stream<Status> get statusSelected => _statusSelected.stream;

  BehaviorSubject<int> _dueDateSelected = BehaviorSubject<int>();

  Stream<int> get dueDateSelected => _dueDateSelected.stream;

  String updateTitle = "";

  String updateDescription = "";

  void dispose() {
    _statusSelected.close();
    _dueDateSelected.close();
  }

  void updatePriority(Status status) {
    _statusSelected.add(status);
    lastStatusSelection = status;
  }

  void updateDueDate(int millisecondsSinceEpoch) {
    _dueDateSelected.add(millisecondsSinceEpoch);
  }

  Observable<String> createTask() {
    return Observable.zip2(dueDateSelected, statusSelected,
        (int dueDateSelected, Status status) {
      var task = Tasks.create(
        title: updateTitle,
        dueDate: dueDateSelected,
        comment: updateDescription,
      );
      _taskDB.updateTask(task).then((task) {
        Notification.onDone();
      });
      return Task_Added_Message;
    });
  }
}

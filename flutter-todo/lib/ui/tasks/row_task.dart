import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/data/db/task_operation.dart';
import 'package:flutter_todo/data/model/task.dart';
import 'package:flutter_todo/ui/tasks/tasks_bloc.dart';
import 'package:flutter_todo/utils/app_constant.dart';
import 'package:flutter_todo/utils/date_util.dart';

class TaskRow extends StatelessWidget {
  final TaskBloc _taskBloc = TaskBloc(TaskDB.get());
  final Tasks tasks;
  static final datelabel = "Date";
  final List<String> labelNames = List();

  TaskRow(this.tasks);

  titleLabel(taskTitle) {
    return Text(taskTitle,
        style: TextStyle(
            color: Colors.black,
            fontSize: FONT_SIZE_TITLE,
            fontWeight: FontWeight.bold));
  }

  taskDeadline(int taskDueDate) {
    return Text(
      getFormattedDate(taskDueDate),
      style: taskDueDate < DateTime.now().millisecondsSinceEpoch
          ? TextStyle(color: Colors.redAccent, fontSize: FONT_SIZE_DATE)
          : TextStyle(color: Colors.black),
      key: Key(datelabel),
    );
  }

  taskAction(int taskID, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Icon(
                Icons.check,
                color: Colors.green,
              ),
              onPressed: () {
                {
                  _taskBloc.delete(taskID);
                  SnackBar snackbar =
                      SnackBar(content: Text(Task_Completed_Message));
                  Scaffold.of(context).showSnackBar(snackbar);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: PADDING_TINY),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.black),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(
                          left: PADDING_SMALL, bottom: PADDING_VERY_SMALL),
                      child: titleLabel(tasks.title)),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PADDING_SMALL, top: PADDING_VERY_SMALL),
                    child: Row(
                      children: <Widget>[
                        taskDeadline(tasks.dueDate),
                        Expanded(child: taskAction(tasks.id, context))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

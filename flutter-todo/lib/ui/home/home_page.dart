import 'package:flutter/material.dart';
import 'package:flutter_todo/bloc/bloc_provider.dart';
import 'package:flutter_todo/data/db/task_operation.dart';
import 'package:flutter_todo/ui/addtask/add_task.dart';
import 'package:flutter_todo/ui/addtask/add_task_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        bloc: AddTaskBloc(TaskDB.get()),
        child: AddTaskScreen(),
      ),
    );
  }
}

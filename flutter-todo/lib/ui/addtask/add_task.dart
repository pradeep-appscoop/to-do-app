import 'package:flutter/material.dart';
import 'package:flutter_todo/bloc/bloc_provider.dart';
import 'package:flutter_todo/ui/addtask/add_task_bloc.dart';
import 'package:flutter_todo/ui/tasks/tasks_bloc.dart';
import 'package:flutter_todo/utils/app_constant.dart';
import 'package:flutter_todo/utils/date_util.dart';
import 'package:flutter_todo/ui/tasks/tasks_page.dart';
import 'package:flutter_todo/data/db/task_operation.dart';

class AddTaskScreen extends StatelessWidget {
  final TaskBloc _taskBloc = TaskBloc(TaskDB.get());
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _taskNameState = GlobalKey<FormState>();
  final GlobalKey<FormState> _taskDescription = GlobalKey<FormState>();

  deadLine(context) {
    AddTaskBloc createTaskBloc = BlocProvider.of(context);
    return ListTile(
      leading: Text(Deadline_Title),
      trailing: StreamBuilder(
        stream: createTaskBloc.dueDateSelected,
        initialData: DateTime.now().millisecondsSinceEpoch,
        builder: (context, snapshot) => Text(getFormattedDate(snapshot.data)),
      ),
      onTap: () {
        _selectDate(context);
      },
    );
  }

  taskNameInputField(context) {
    AddTaskBloc createTaskBloc = BlocProvider.of(context);
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: Task_Title),
      validator: (value) {
        return value.isEmpty ? Task_Name_Empty_Error_Message : null;
      },
      onSaved: (value) {
        createTaskBloc.updateTitle = value;
      },
    );
  }

  descriptionInputField(context) {
    AddTaskBloc createTaskBloc = BlocProvider.of(context);
    return TextFormField(
      maxLines: 4,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: Task_Description),
      validator: (value) {
        return value.isEmpty ? Task_Description_Empty_Error_Message : null;
      },
      onSaved: (value) {
        createTaskBloc.updateDescription = value;
      },
    );
  }

  todoLabel() {
    return Text(
      To_Do_Title,
      style: TextStyle(
        fontSize: FONT_LARGE,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  saveButton(context) {
    AddTaskBloc createTaskBloc = BlocProvider.of(context);
    return FlatButton(
      child: Text(Add_Button_Title,
          style: TextStyle(
            color: Colors.black,
            fontSize: FONT_MEDIUM,
            fontWeight: FontWeight.bold,
          )),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      onPressed: () {
        if (_taskNameState.currentState.validate()) {
          _taskNameState.currentState.save();
          createTaskBloc.createTask().listen((value) {
            _taskBloc.refresh();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(Task_Add_Screen_Title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _taskBloc.refresh();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(

            children: <Widget>[
              Container(

                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                    left: PADDING_SMALL,
                    top: PADDING_SMALL,
                    right: PADDING_SMALL),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
                child: deadLine(context),
              ),
              Form(
                key: _taskNameState,
                child: Padding(
                  padding: const EdgeInsets.all(PADDING_SMALL),
                  child: taskNameInputField(context),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      key: _taskDescription,
                      padding: const EdgeInsets.all(PADDING_SMALL),
                      child: descriptionInputField(context),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width - PADDING_SMALL,
                height: PADDING_LARGE,
                child: saveButton(context),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: PADDING_VERY_LARGE,
                margin: EdgeInsets.only(left: 0, top: PADDING_SMALL),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                child: todoLabel(),
              ),
              Container(
                width: MediaQuery.of(context).size.width - PADDING_LARGE,
                height: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(left: PADDING_SMALL, top: PADDING_SMALL),
                child: BlocProvider(
                  bloc: _taskBloc,
                  child: TasksPage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    AddTaskBloc createTaskBloc = BlocProvider.of(context);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2101));
    if (picked != null) {
      createTaskBloc.updateDueDate(picked.millisecondsSinceEpoch);
    }
  }
}

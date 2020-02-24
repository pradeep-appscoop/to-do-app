import 'package:flutter/material.dart';
import 'package:flutter_todo/bloc/bloc_provider.dart';
import 'package:flutter_todo/ui/home/home_page.dart';
import 'package:flutter_todo/ui/home/home_bloc.dart';

void main() => runApp(ToDoApp());

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "To Do App",
        home: BlocProvider(bloc: HomeBloc(), child: HomePage()));
  }
}

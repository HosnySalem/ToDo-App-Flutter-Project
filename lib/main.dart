import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'tools/blocobserver.dart';


void main(){
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: todoApp(),
    );
  }
}



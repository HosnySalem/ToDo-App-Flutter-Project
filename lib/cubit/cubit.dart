import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todoapp_flutterproject/archived.dart';
import 'package:todoapp_flutterproject/cubit/states.dart';
import 'package:todoapp_flutterproject/done.dart';
import 'package:todoapp_flutterproject/tasks.dart';

class Todocubit extends Cubit<Todostates> {
  Todocubit() : super(TodoInitState());

  static Todocubit get(context) => BlocProvider.of(context);

  List<BottomNavigationBarItem> item = const [
    BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'tasks'),
    BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
    BottomNavigationBarItem(icon: Icon(Icons.archive_outlined), label: 'Archive'),
  ];

  List screens = [tasksScreen(), doneScreen(), archivedScreen()];
  List titles = ['New Tasks', 'done Tasks', 'archived Tasks'];

  int currentindex = 0;

  void changeBottomNavIndex(index) {
    currentindex = index;
    emit(TodochangeBottomNavIndexState());
  }

  bool showsheet = false;

  void changeBottomSheet(bool enable) {
    showsheet = enable;
    emit(TodochangechangeBottomSheetState());
  }


  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createadatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'create table tasks(id integer primary key,title text,date text ,time text, status text)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when creating Table $error');
        });
      },
      onOpen: (database) {
        print('database opened');
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(TodoCreateDatabaseState());
    }) ;
  }

  void insertToDatabase({
    @required title,
    @required date,
    @required time,
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
        'insert into tasks(title,date,time,status) values("$title","$date","$time","new")',
      )
          .then((value) {
        print('$value data inserted');
        emit(TodoInsertDatabaseState());
        print(database.toString());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when creating database ${error.toString()}');
      });

    });
  }

  void getDataFromDatabase(database)  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(TodoGetDatabaseloadingState());

     database!.rawQuery('select * from tasks').then((value){
       value.forEach((element)
       {
         if(element['status'] == 'new') {
           newTasks.add(element);
         } else if(element['status'] == 'done')
         {  doneTasks.add(element);}
         else { archivedTasks.add(element);}
       });

       emit(TodoGetDatabaseState());
     });
    print('sucsess');
    emit(TodoGetDatabaseState());
  }

  void updateData({
    @required String? status,
    @required int? id,
  }) async
  {
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(TodoUpdateDatabaseState());
    });
  }

  void deleteData({
    @required int? id,
  }) async
  {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value)
    {
      getDataFromDatabase(database);
      emit(TodoDeleteDatabaseState());
    });
  }


}//cubit



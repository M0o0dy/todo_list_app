import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/modules/archived_tasks/ArchivedTasks.dart';
import 'package:todo_list_app/modules/done_tasks/DoneTasks.dart';
import 'package:todo_list_app/modules/new_tasks/NewTasks.dart';
import 'package:todo_list_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Map>newTasks=[];
  List<Map>doneTasks=[];
  List<Map>archivedTasks=[];
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> screensName = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  late Database database;
  bool isBottomSheetShow = false;

  IconData fabIcon = Icons.edit;

  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase()  {
 openDatabase(
      'TodoApp.db',
      version: 1,
      onCreate: (database, version) {
        print('Database Created');
        database.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) {

          print('Table Created');
        }).catchError((error) {
          print('Error while Creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getFromDatabase(database);

        print('Database Opened');
      },
    ).then((value) {
   database = value;
      emit(AppCreateDatabaseState());

 });
  }

   insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","New")')
          .then((value) {
        print('$value New Record Inserted successfully');
        emit(AppInsertToDatabaseState());
        getFromDatabase(database);
      }).catchError((error) {
        print('Error While Inserting New Record ${error.toString()}');
      });

    });
  }

  void getFromDatabase(database)async
  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];

    emit(AppGetFromDatabaseLoadingState());
    return await database.rawQuery('SELECT * FROM tasks').then((value){
      value.forEach((element){
        if(element['status']=='New')newTasks.add(element);
        else  if(element['status']=='Done')doneTasks.add(element);
        else archivedTasks.add(element);
      });

      emit(AppGetFromDatabaseState());
    });

  }
  void bottomSheet({required bool isShow,required IconData icon,}){

    isBottomSheetShow = isShow;
    fabIcon = icon;
    emit(AppBottomSheetState());
  }

  void updateDatabase ({required String status, required int id}){
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          getFromDatabase(database);
          emit(AppUpdateDatabaseState());
    });


  }

  void deleteFromDatabase ({ required int id})async{
return await
        database
            .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
          getFromDatabase(database);
          emit(AppDeleteFromDatabaseState());
    });
  }

}
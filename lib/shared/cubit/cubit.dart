import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../modules/archive_tasks/archive_tasks_screen.dart';
import '../../../modules/done_tasks/done_tasks_screen.dart';
import '../../../modules/new_tasks/new_tasks_screen.dart';
import '../../models/task_model.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  // object from class to use easly
  static AppCubit get(context) => BlocProvider.of(context);

  // change screens
  int currentIndex = 0;

  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchiveTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;
  String tableName = 'tasks';
  List<TaskModel> newtasks = [];
  List<TaskModel> donetasks = [];
  List<TaskModel> archivetasks = [];

  createDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        db
            .execute(
                'CREATE TABLE $tableName (id INTEGER PRIMARY KEY, title TEXT, description TEXT, date TEXT, time TEXT, status TEXT, repeat STRING)')
            .then((value) => debugPrint('created Table'))
            .catchError(
                (error) => debugPrint('error when create table $error'));
      },
      onOpen: (database) {
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertToDataBase({TaskModel? model}) async {
    return await database!.insert(tableName, model!.toJson()).then((value) {
      getDataFromDatabase(database);
      emit(AppInsertDatabaseState());
    }).catchError((error) {
      debugPrint('error when inserted new record $error');
    });
  }

  void getDataFromDatabase(db) {
    newtasks = [];
    donetasks = [];
    archivetasks = [];
    emit(AppGetDatabaseLoadingState());
    db!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        print('value $value , $element');
        if (element['status'] == 'new') {
          newtasks.add(TaskModel.fromJson(element));
        } else if (element['status'] == 'done') {
          donetasks.add(TaskModel.fromJson(element));
        } else {
          archivetasks.add(TaskModel.fromJson(element));
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  updateData({
    required String status,
    required int id,
  }) async {
    return await database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, '$id'],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  deleteData({
    required int id,
  }) async {
    return await database!.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      ['$id'],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fadeIcon = Icons.edit;

  changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fadeIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  //repeate
  String selectedRepeate = 'Only one';
  List<String> repeatList = ['Only one', 'Daily', 'Weekly', 'Monthly'];

  newSelectedRepeate(String newRepeate) {
    selectedRepeate = newRepeate;
    emit(SelecteNewRepeateState());
  }

  bool isDateTime = true;

  isDateTimeTrue(TimeOfDay t) {
    final now = DateTime.now();
    isDateTime = DateTime.now()
        .isBefore(DateTime(now.year, now.month, now.day, t.hour, t.minute));
    print(isDateTime);
    emit(IsTimeDateTrueeState());
  }
}

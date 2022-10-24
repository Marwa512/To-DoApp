// ignore_for_file: curly_braces_in_flow_control_structures, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../module/archivedtask_module/archive.dart';
import '../../module/donetasks_module/doneTasks.dart';
import '../../module/newtask_module/newtasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  var currentIndex = 0;
  List<Widget> Screens = [
    newTaskscreen(),
    doneTaskscreen(),
    archiveTaskscreen(),
  ];
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivetasks = [];

  List<String> title = [
    "New task",
    "Done tasks",
    "Archive tasks",
  ];
  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;

  void BottomNavBar(index) {
    currentIndex = index;
    emit(BottomNavBarState());
  }

  late Database db;

  void createDatabase() {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (Database db, version) async {
        print("Database Created");
        db
            .execute(
                'CREATE TABLE todo (id INTEGER PRIMARY KEY, title TEXT, Date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print("Table created");
        }).catchError((error) {
          print("Error is ${error.toString()}");
        });
      },
      onOpen: (database) {
        print("Database opened");
        getData(database);
      },
    ).then((value) {
      db = value;
    });
    emit(AppCreateDatabaseState());
  }

  insertDB(
      {required String title,
      required String date,
      required String time}) async {
    await db.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO todo(title, Date, time, status) VALUES("$title", "$date", "$time","new")')
          .then((value) {
        print("$value inserted successfuly ");
        emit(AppInsertDatabaseState());
        getData(db);
      }).catchError((error) {
        print("Error ${error.toString()}");
      });
    });
  }

  void getData(database) {
    newtasks = [];
    donetasks = [];
    archivetasks = [];
    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT* from todo').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newtasks.add(element);
        else if (element['status'] == 'done')
          donetasks.add(element);
        else
          archivetasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
    emit(AppGetDatabaseState());
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    db.rawUpdate('UPDATE todo SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getData(db);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    db.rawDelete('DELETE FROM todo WHERE id = ?', [id]).then((value) {
      getData(db);
      emit(AppDeleteDatabaseState());
    });
  }

  void changeBottomSheet(
    @required bool isShow,
    @required IconData icon,
  ) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }
}

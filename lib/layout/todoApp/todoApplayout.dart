// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, sized_box_for_whitespace

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/module/archivedtask_module/archive.dart';
import 'package:flutter_application_1/module/donetasks_module/doneTasks.dart';
import 'package:flutter_application_1/module/newtask_module/newtasks.dart';
import 'package:flutter_application_1/shared/component/component/reusablecomponent.dart';
import 'package:flutter_application_1/shared/cubit/cubit.dart';
import 'package:flutter_application_1/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../shared/component/component/constant/constant.dart';

class mainLayout extends StatelessWidget {
  late Database db;
  var ScaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  late var titleController = TextEditingController();
  late var timeController = TextEditingController();
  late var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, state) {
        if (state is AppInsertDatabaseState) {
          Navigator.pop(context);
          titleController.clear();
          dateController.clear();
          timeController.clear();
        }
      }, builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(title: Text(cubit.title[cubit.currentIndex])),
          body: ConditionalBuilder(
            condition: state is! AppGetDatabaseLoadingState,
            builder: (context) => cubit.Screens[cubit.currentIndex],
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                cubit.BottomNavBar(index);
              },
              currentIndex: cubit.currentIndex,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done "),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archive"),
              ]),
          key: ScaffoldKey,
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDB(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text);

                    /*  insertDB(
                          title: titleController.text,
                          date: dateController.text,
                          time: timeController.text,
                        ).then((value) {
                         
                          getData(db).then((value) {
                             Navigator.pop(context);
                            /* setState(() {
                          isBottomSheetShown = false;
                          fabIcon = Icons.edit;
                          tasks = value;
                          print(tasks);
                        }); */
                          });
                        }); */
                  }
                } else {
                  ScaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: titleController,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'title cant be empty';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: "Task title",
                                      prefixIcon: Icon(Icons.title),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: timeController,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'time cant be empty';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(
                                      labelText: "Task time",
                                      prefixIcon:
                                          Icon(Icons.watch_later_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: dateController,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'date cant be empty';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2025-12-25'))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(
                                      labelText: "Task date",
                                      prefixIcon: Icon(Icons.date_range),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(false, Icons.edit);
                  });

                  cubit.changeBottomSheet(true, Icons.add);
                }
              },
              child: Icon(cubit.fabIcon)),
        );
      }),
    );
  }
}

// ignore_for_file: camel_case_types, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/component/reusablecomponent.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class doneTaskscreen extends StatelessWidget {
  const doneTaskscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (BuildContext context, Object? state) {
        var tasks = AppCubit.get(context).donetasks;
        return taskBuilder(tasks: tasks);
      },
    );
  }
}

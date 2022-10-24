// ignore_for_file: prefer_const_constructors, camel_case_types, avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/module/counter/counterCubit.dart';
import 'package:flutter_application_1/module/counter/counterState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class counterScreen extends StatelessWidget {
  const counterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => counterCubit(),
      child: BlocConsumer<counterCubit, counterState>(
          listener: (context, counterState) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Counter"),
              ),
              body: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        counterCubit.get(context).minus();
                      },
                      child: Text(
                        "minus",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "${counterCubit.get(context).counter}",
                      style: TextStyle(fontSize: 50),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          counterCubit.get(context).plus();
                        },
                        child: Text(
                          "plus",
                          style: TextStyle(fontSize: 30),
                        )),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

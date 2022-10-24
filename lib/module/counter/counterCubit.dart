// ignore_for_file: camel_case_types

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'counterState.dart';

class counterCubit extends Cubit<counterState> {
  counterCubit() : super(initialState());
  int counter = 1;
  static counterCubit get(context) => BlocProvider.of(context);

  void minus() {
    counter--;
    emit(minusState(counter));
  }

  void plus() {
    counter++;
    emit(plusState(counter));
  }
}

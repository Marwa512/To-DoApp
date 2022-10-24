abstract class counterState {}

class initialState extends counterState {}

class minusState extends counterState {
  final int counter;

  minusState(this.counter);
}

class plusState extends counterState {
  final int counter;

  plusState(this.counter);
}

part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}
class SnackState extends HomeState {
  final List<dynamic> itemList;

  SnackState({required this.itemList});
}
class TeaAndCoffeeState extends HomeState {
  final List<dynamic> itemList;

  TeaAndCoffeeState({required this.itemList});
}

class TestAMinuteState extends HomeState {
  final List<dynamic> itemList;

  TestAMinuteState({required this.itemList});
}

class LunchPlateState extends HomeState {
  final List<dynamic> itemList;

  LunchPlateState({required this.itemList});
}

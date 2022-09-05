part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class SnackEvent extends HomeEvent {
  final List<dynamic> itemList;

  SnackEvent({required this.itemList});
}
class TeaAndCoffeeEvent extends HomeEvent {
  final List<dynamic> itemList;

  TeaAndCoffeeEvent({required this.itemList});
}

class TestAMinuteEvent extends HomeEvent {
  final List<dynamic> itemList;

  TestAMinuteEvent({required this.itemList});
}

class LunchPlateEvent extends HomeEvent {
  final List<dynamic> itemList;

  LunchPlateEvent({required this.itemList});
}

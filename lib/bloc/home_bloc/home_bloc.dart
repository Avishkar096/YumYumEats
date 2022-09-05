import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<SnackEvent>(
      (event, emit) => emit(SnackState(itemList: event.itemList)),
    );
    on<TestAMinuteEvent>(
          (event, emit) => emit(TestAMinuteState(itemList: event.itemList)),
    );
    on<LunchPlateEvent>(
          (event, emit) => emit(LunchPlateState(itemList: event.itemList)),
    );
    on<TeaAndCoffeeEvent>(
          (event, emit) => emit(TeaAndCoffeeState(itemList: event.itemList)),
    );
  }
}

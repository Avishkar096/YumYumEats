import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/bloc/user_bloc/user_event.dart';
import 'package:food_order/bloc/user_bloc/user_state.dart';
import 'package:food_order/services/login_api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<RegisterUser>((event, emit) async {
      emit(LoadingState());
      var response = await LoginApiServices.registerUser(event.user);
      if (response == 200) {
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailed());
      }
    });

    on<LoginUser>((event, emit) async {
      emit(LoadingState());
      try {
        var response =
            await LoginApiServices.loginUser(event.email, event.password);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', data['_id']);
          await prefs.setString('name', data['name']);
          await prefs.setString('email', data['email']);
          emit(LoginSuccess());
        } else {
          emit(LoginFailed(message: data['message']));
        }
      } catch (error) {
        print(error);
        emit(LoginFailed(message: 'Something went wrong'));
      }
    });

    on<LogoutEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(Logout());
    });

    on<ErrorHandleEvent>(
      (event, emit) => emit(LoginFailed(message: event.message)),
    );
  }
}

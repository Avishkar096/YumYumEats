
import 'package:food_order/bloc/user_bloc/user_state.dart';
import 'package:food_order/model/user_model.dart';

abstract class UserEvent {}

class RegisterUser extends UserEvent {
  final UserModel user;

  RegisterUser({required this.user});
}

class LoginUser extends UserEvent {
  final String email;
  final String password;

  LoginUser({required this.email, required this.password});
}

class ErrorHandleEvent extends UserEvent {
  final String message;

  ErrorHandleEvent({required this.message});
}

class LogoutEvent extends UserEvent {}
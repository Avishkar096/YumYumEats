
abstract class UserState {}

class UserInitial extends UserState {}
class RegisterSuccess extends UserState {}
class RegisterFailed extends UserState {}
class LoadingState extends UserState {}
class LoginFailed extends UserState {
  final String message;
  LoginFailed({required this.message});
}
class LoginSuccess extends UserState {}
class Logout extends UserState {}
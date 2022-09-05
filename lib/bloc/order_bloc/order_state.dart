part of 'order_bloc.dart';

@immutable
abstract class OrderState {}

class OrderInitialState extends OrderState {}
class CancelOrderState extends OrderState {}
class OrderConformState extends OrderState {}
class OrderLoadingState extends OrderState {}

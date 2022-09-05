part of 'order_bloc.dart';

@immutable
abstract class OrderEvent {}

class PaymentSuccessEvent extends OrderEvent{
  final ItemModel itemData;
  final int quantity;

  PaymentSuccessEvent({required this.itemData,required this.quantity});
}


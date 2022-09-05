import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:food_order/model/order_model.dart';
import 'package:food_order/services/order_api_services.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../model/item_model.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitialState()) {
    on<PaymentSuccessEvent>((event, emit) async {
      emit(OrderLoadingState());
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? userName = prefs.getString('name');
      OrderModel orderData = OrderModel(
        userId: userId!,
        userName: userName!,
        productName: event.itemData.productName,
        price: (event.itemData.itemPrice * event.quantity).toString(),
        quantity: event.quantity.toString(),
        orderTime: DateTime.now(),
        orderImage: event.itemData.orderImage,
        orderStatus: true,
        paymentStatus: true,
        deliveredStatus: false,
      );
      http.Response response = await OrderApiServices.conformOrder(orderData);

      Future.delayed(
        const Duration(seconds: 5),
      );
      if (response.statusCode == 200) {
        emit(OrderConformState());
      } else {
        emit(OrderLoadingState());
      }
    });
  }
}

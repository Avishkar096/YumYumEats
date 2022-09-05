import 'package:food_order/model/order_model.dart';
import 'package:food_order/services/login_api_services.dart';
import 'package:food_order/services/service_constant.dart';
import 'package:http/http.dart' as http;


class OrderApiServices{

  static Future<http.Response>conformOrder(OrderModel orderData)async{
    
    var url = Uri.parse('$baseUrl/order/save');


    try{
      var response = await http.post(url,body: orderData.toJson());
      print(response.statusCode);
      if(response.statusCode == 200){
        return response;
      }
      else{
        return http.Response("Something went wrong", response.statusCode);
      }
    }catch(error){
      print(error);
      return http.Response("Server side error" , 401);
    }

  }
}

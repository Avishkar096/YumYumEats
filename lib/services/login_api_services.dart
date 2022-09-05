
import 'package:food_order/model/user_model.dart';
import 'package:food_order/services/service_constant.dart';
import 'package:http/http.dart' as http;

class LoginApiServices {
  static Future<int> registerUser(UserModel user) async {
      var url = Uri.parse("$baseUrl/auth/register");
      var response = await http.post(
        url,
        body: user.toJson(),
      );
      return response.statusCode;
  }

  static Future<http.Response> loginUser(String email,String password)async{
    var url = Uri.parse('$baseUrl/auth/login');
      var response = await http.post(url,body: {
        "email" : email,
        "password" : password,
      });
      return response;
  }
}

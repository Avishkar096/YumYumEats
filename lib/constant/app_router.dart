import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/bloc/home_bloc/home_bloc.dart';
import 'package:food_order/bloc/internet_bloc/internet_bloc.dart';
import 'package:food_order/model/item_model.dart';
import 'package:food_order/pages/home_page.dart';
import 'package:food_order/pages/internet_lost_page.dart';
import 'package:food_order/screen/google_pay_screen.dart';
import 'package:food_order/screen/order_screen.dart';
import 'package:food_order/screen/payment_screen.dart';

import '../bloc/user_bloc/user_bloc.dart';
import '../pages/login_page.dart';
import '../screen/splash_screen.dart';

const String splashScreen = '/splashScreen';
const String loginPage = '/loginPage';
const String homePage = '/homePage';

const String orderScreen = '/orderScreen';
const String paymentScreen = '/paymentScreen';
const String googlePayScreen = '/googlePayScreen';
const String internetLostPage = '/internetLostPage';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => UserBloc(),
            child: LoginPage(),
          ),
        );
      case homePage:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<UserBloc>(create: (context) => UserBloc()),
              BlocProvider<InternetBloc>(create: (context) =>InternetBloc()),
              BlocProvider<HomeBloc>(create: (context)=>HomeBloc(),),
            ],
            child: HomePage(),
          ),
        );
      case orderScreen:
        ItemModel data = settings.arguments as ItemModel;
        return CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => OrderScreen(
            item: data,
          ),
        );
      case internetLostPage:
        return MaterialPageRoute(
          builder: (context) => const InternetLostPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

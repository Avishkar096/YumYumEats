import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:food_order/bloc/internet_bloc/internet_bloc.dart';
import 'package:food_order/pages/internet_lost_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userId');

      if (userId != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          homePage,
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          loginPage,
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Text('Developed by sk'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/bloc/user_bloc/user_bloc.dart';
import 'package:food_order/bloc/user_bloc/user_event.dart';
import 'package:food_order/bloc/user_bloc/user_state.dart';
import 'package:food_order/constant/app_router.dart';
import 'package:food_order/pages/registration_page.dart';
import '../constant/widget/ReusedPasswordFilled.dart';
import '../constant/widget/ReusedTextFilled.dart';
import '../constant/widget/reused_button_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<UserBloc, UserState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  const Color(0xFFFAF9F6),
                  Colors.blue.shade50,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _introductionWidget(),
                  ReusedTextFilled(
                    onChanged: (String value) {
                      email = value;
                    },
                    hintText: 'email',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ReusedPasswordFilled(
                    onChanged: (String value) {
                      password = value;
                    },
                  ),
                  BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                    if (state is LoginFailed) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return (Container());
                    }
                  }),
                  const SizedBox(
                    height: 5,
                  ),
                  _forgotPasswordWidget(),
                  const SizedBox(
                    height: 15,
                  ),
                  ReusedButtonWidget(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, homePage, (route) => false);

                    /* if (email.isNotEmpty && password.isNotEmpty) {
                        BlocProvider.of<UserBloc>(context).add(
                          LoginUser(email: email, password: password),
                        );
                      } else {
                        BlocProvider.of<UserBloc>(context).add(
                          ErrorHandleEvent(
                            message: 'Enter all Fields',
                          ),
                        );
                      }*/
                    },
                    text: 'Sign In',
                  ),
                  _orContinueWidget(),
                  _anotherLoginButtonWidget(),
                  _registrationWidget(context)
                ],
              ),
            );
          },
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                  context, homePage, (route) => false);
            }
          },
        ),
      ),
    );
  }

  _introductionWidget() {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Hello Again!',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Welcome back you've been missed",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w700,
                fontSize: 18),
          )
        ],
      ),
    );
  }

  _forgotPasswordWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () {},
            child: const Text(
              'Recovery Password',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.black45,
              ),
            ))
      ],
    );
  }

  _orContinueWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 60,
            height: 2,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.white,
              Colors.black45,
            ])),
          ),
          const Text(
            'or continue with',
            style:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
          ),
          Container(
            width: 60,
            height: 2,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.black45,
              Colors.white,
            ])),
          ),
        ],
      ),
    );
  }

  _anotherLoginButtonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SocialMediaButton('assets/google.png'),
        SocialMediaButton('assets/apple.png'),
        SocialMediaButton('assets/facebook.png'),
      ],
    );
  }

  Container SocialMediaButton(String image) {
    return Container(
      height: 45,
      width: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2.0),
      ),
      child: Image.asset(
        image,
        // width: 50,
        // height: 50,
      ),
    );
  }

  _registrationWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Not a member?'),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => UserBloc(),
                      child: const RegistrationPage(),
                    ),
                  ),
                );
              },
              child: const Text('Register now'))
        ],
      ),
    );
  }
}

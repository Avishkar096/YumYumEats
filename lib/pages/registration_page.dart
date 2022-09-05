import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_order/bloc/user_bloc/user_bloc.dart';
import 'package:food_order/bloc/user_bloc/user_event.dart';
import 'package:food_order/bloc/user_bloc/user_state.dart';
import 'package:food_order/model/user_model.dart';
import '../constant/app_router.dart';
import '../constant/widget/ReusedPasswordFilled.dart';
import '../constant/widget/ReusedTextFilled.dart';
import '../constant/widget/reused_button_widget.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String email = '';
  String password = '';
  String conformPassword = '';
  String name = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Register Successfully'),
            ),
          );
          Navigator.pushNamedAndRemoveUntil(context, loginPage, (route) => false);
        }
        if(state is RegisterFailed){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Register Failed'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is LoadingState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return SafeArea(
            child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _introductionWidget(),
                ReusedTextFilled(
                  onChanged: (String value) {
                    setState(() {
                      name = value;
                    });
                  }, hintText: 'name',
                ),
                const SizedBox(
                  height: 15,
                ),
                ReusedTextFilled(
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  }, hintText: 'email',
                ),
                const SizedBox(
                  height: 15,
                ),
                ReusedPasswordFilled(
                  onChanged: (String value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ReusedPasswordFilled(
                  onChanged: (String value) {
                    conformPassword = value;
                  },
                ),
                const SizedBox(
                  height: 45,
                ),
                ReusedButtonWidget(
                  onTap: () {
                    if (password.isNotEmpty &&
                        name.isNotEmpty &&
                        conformPassword.isNotEmpty &&
                        email.isNotEmpty) {
                      if (password == conformPassword) {
                        BlocProvider.of<UserBloc>(context).add(
                          RegisterUser(
                            user: UserModel(
                              email: email,
                              name: name,
                              password: password,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enter same password'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enter All field')));
                    }
                  },
                  text: 'Register',
                ),
                _signInWidget(context)
              ],
            ),
          ),
        ));
      },
    );
  }

  _introductionWidget() {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Hello !',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Welcome SK food app",
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

  _signInWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Not a member?'),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, loginPage);
              },
              child: const Text('Sign In'))
        ],
      ),
    );
  }
}

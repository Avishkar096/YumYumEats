import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/bloc/home_bloc/home_bloc.dart';
import 'package:food_order/bloc/internet_bloc/internet_bloc.dart';
import 'package:food_order/bloc/user_bloc/user_bloc.dart';
import 'package:food_order/bloc/user_bloc/user_event.dart';
import 'package:food_order/constant/app_router.dart';
import 'package:food_order/constant/flutter_toast.dart';
import 'package:food_order/constant/itemData.dart';
import 'package:food_order/constant/style.dart';
import 'package:food_order/pages/internet_lost_page.dart';
import 'package:lottie/lottie.dart';
import '../constant/widget/category_container_widget.dart';
import '../constant/widget/item_container_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSnackSelected = true;

  bool _isTeaSelected = false;

  bool _isTestSelected = false;

  bool _isLunchSelected = false;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;

  void checkInternet() {
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      setState(() {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          context.read<InternetBloc>().add(InternetGainedEvent());
        } else {
          context.read<InternetBloc>().add(InternetLostEvent());
        }
      });
    });
  }

  @override
  initState() {
    checkInternet();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          BlocConsumer<InternetBloc, InternetState>(builder: (context, state) {
        if (state is InternetGainedState) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: const Color(0xFFFAF9F6),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Food',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      BlocProvider.of<UserBloc>(context).add(LogoutEvent());
                      Navigator.pushNamedAndRemoveUntil(
                          context, loginPage, (route) => false);
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.black,
                    ))
              ],
            ),
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _searchBarWidget(),
                    SizedBox(
                      height: 70,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          CategoryContainerWidget(
                            title: 'SNACKS',
                            backgroundColor: _isSnackSelected
                                ? const Color(0xFFFF8450)
                                : Colors.grey,
                            onTap: () {
                              setState(() {
                                context.read<HomeBloc>().add(
                                      SnackEvent(
                                        itemList: snackList,
                                      ),
                                    );
                                _isSnackSelected = true;
                                _isLunchSelected = false;
                                _isTeaSelected = false;
                                _isTestSelected = false;
                              });
                            },
                          ),
                          CategoryContainerWidget(
                            title: 'TEA AND COFFEE',
                            backgroundColor: _isTeaSelected
                                ? Color(0xFFFF8450)
                                : Colors.grey,
                            onTap: () {
                              setState(() {
                                context.read<HomeBloc>().add(
                                      TeaAndCoffeeEvent(
                                        itemList: teaList,
                                      ),
                                    );
                                _isSnackSelected = false;
                                _isLunchSelected = false;
                                _isTeaSelected = true;
                                _isTestSelected = false;
                              });
                            },
                          ),
                          CategoryContainerWidget(
                            title: 'TEST A MINUTE',
                            backgroundColor: _isTestSelected
                                ? const Color(0xFFFF8450)
                                : Colors.grey,
                            onTap: () {
                              context.read<HomeBloc>().add(
                                    TestAMinuteEvent(
                                      itemList: testList,
                                    ),
                                  );
                              setState(() {
                                _isSnackSelected = false;
                                _isLunchSelected = false;
                                _isTeaSelected = false;
                                _isTestSelected = true;
                              });
                            },
                          ),
                          CategoryContainerWidget(
                            title: 'LUNCH PLATE',
                            backgroundColor: _isLunchSelected
                                ? const Color(0xFFFF8450)
                                : Colors.grey,
                            onTap: () {
                              context.read<HomeBloc>().add(
                                    LunchPlateEvent(
                                      itemList: lunchList,
                                    ),
                                  );
                              setState(() {
                                _isSnackSelected = false;
                                _isLunchSelected = true;
                                _isTeaSelected = false;
                                _isTestSelected = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                      if (state is HomeInitial) {
                        context.read<HomeBloc>().add(
                              SnackEvent(
                                itemList: snackList,
                              ),
                            );
                        return const CircularProgressIndicator();
                      }
                      if (state is LunchPlateState) {
                        return _selectedBodyList(context, state.itemList);
                      } else if (state is TeaAndCoffeeState) {
                        return _selectedBodyList(context, state.itemList);
                      } else if (state is TestAMinuteState) {
                        return _selectedBodyList(context, state.itemList);
                      } else {
                        return _selectedBodyList(context, snackList);
                      }
                    }),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
              body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animation/no-internet-connection.json',
              ),
            ],
          ));
        }
      }, listener: (context, state) {
        if (state is InternetGainedState) {
          flutterToast('you are online');
        }
      }),
    );
  }

  Container _selectedBodyList(BuildContext context, List<dynamic> dataList) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: dataList.length,
          itemBuilder: (BuildContext ctx, index) {
            return ItemContainerWidget(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  orderScreen,
                  arguments: dataList[index],
                );
              },
              itemData: dataList[index],
            );
          }),
    );
  }

  Container _searchBarWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.black26,
          ),
          hintText: 'Find your food',
          hintStyle: hintTextStyle,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

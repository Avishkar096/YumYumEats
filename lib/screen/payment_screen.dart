import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/bloc/order_bloc/order_bloc.dart';
import 'package:food_order/bloc/user_bloc/user_state.dart';
import 'package:food_order/constant/app_router.dart';
import 'package:food_order/model/item_model.dart';
import 'package:lottie/lottie.dart';
import 'package:pay/pay.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

const TextStyle priceDetailsStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 16,
);

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
      {Key? key, required this.orderData, required this.quantity})
      : super(key: key);

  final ItemModel orderData;
  final int quantity;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  late int totalAmount = widget.orderData.itemPrice * widget.quantity;

  @override
  initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  final List<PaymentItem> _paymentItems = [
    const PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Payment Success')));
    sendData();
    // print('payment success');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment Success'),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('External wallet selected'),
      ),
    );
    print('external wallet was selected');
  }

  String money = '1';

  bool isGooglePaySelected = false;
  bool isMorePaymentSelected = true;

  void openOtherPayment() {
    var options = {
      'key': 'rzp_test_tpxvFQzYjwZ7aY',
      'amount': totalAmount*100,
      'name': 'Saurabh Keskar',
      'description': 'Food Order',
      'prefill': {'contact': '9112916534', 'email': 'saurabh@gmail.com'}
    };

    try {
      _razorpay.open(options);
    } catch (error) {
      print(error);
    }
  }

  void sendData() {
    context.read<OrderBloc>().add(
          PaymentSuccessEvent(
            itemData: widget.orderData,
            quantity: widget.quantity,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        // print(state);
        if (state is OrderLoadingState) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.network('https://assets3.lottiefiles.com/private_files/lf30_2jjm3odf.json'),
                ),
                const Center(
                  child: Text('Loading...'),
                ),
              ],
            ),
          );
        }
        else if (state is OrderConformState) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/animation/your-order-is-conformed.json'),
                InkWell(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Container(
                    width: 140,
                    height: 50,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.redAccent),
                    child: const Center(
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else{
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.black,
                    )),
                title: const Text(
                  'Payment',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // leading: Container(),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      spreadRadius: 10,
                      blurRadius: 5,
                      offset: const Offset(0, 7), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      totalAmount.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    InkWell(
                      onTap: openOtherPayment,
                      child: Container(
                        width: 140,
                        height: 50,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.redAccent),
                        child: const Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                color: Colors.black12,
                // padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Card(
                          child: ListTile(
                            tileColor: Colors.white,
                            leading: Container(
                              height: 25,
                              width: 25,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: isGooglePaySelected
                                      ? Colors.redAccent
                                      : Colors.grey,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: isGooglePaySelected
                                    ? Colors.redAccent
                                    : Colors.grey,
                              ),
                            ),
                            title: const Text(
                              'Google Pay UPI',
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: Image.asset(
                              'assets/google.png',
                              height: 30,
                            ),
                            onTap: () {
                              setState(() {
                                isGooglePaySelected = true;
                                isMorePaymentSelected = false;
                              });
                            },
                          ),
                        ),
                        Card(
                          child: ListTile(
                            tileColor: Colors.white,
                            leading: Container(
                              height: 25,
                              width: 25,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: isMorePaymentSelected
                                      ? Colors.redAccent
                                      : Colors.grey,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: isMorePaymentSelected
                                    ? Colors.redAccent
                                    : Colors.grey,
                              ),
                            ),
                            title: const Text(
                              'More Payment option',
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: const Icon(Icons.smart_button_rounded),
                            onTap: () {
                              setState(() {
                                isGooglePaySelected = false;
                                isMorePaymentSelected = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _priceDetailsWidget(),
                    _validCard(),
                    _securePaymentStatement(),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  _priceDetailsWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Text(
              'PRICE DETAILS',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black54),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            height: 130,
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Price', style: priceDetailsStyle),
                    Text(
                      (widget.orderData.itemPrice * widget.quantity).toString(),
                      style: priceDetailsStyle,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Coupons for you', style: priceDetailsStyle),
                    offerTextWidget(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery Charges',
                      style: priceDetailsStyle,
                    ),
                    offerTextWidget(),
                  ],
                ),
                const Divider(
                  thickness: 1,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Amount Payable',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  (widget.orderData.itemPrice * widget.quantity).toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 40,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Text offerTextWidget() => const Text(
        '-₹0',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      );

  _validCard() {
    return Container(
      color: Colors.white,
      height: 70,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text('Verified by'),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/visa.png',
                width: 40,
              ),
              Image.asset(
                'assets/mastercard.png',
                width: 40,
              ),
              Image.asset(
                'assets/rupay.png',
                width: 40,
              ),
              Image.asset(
                'assets/bit.png',
                width: 40,
              ),
              Image.asset(
                'assets/pci.png',
                width: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

_securePaymentStatement() {
  return Container(
    padding: const EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/secuire.png',
          height: 40,
          width: 40,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 20,
        ),
        const SizedBox(
          width: 250,
          child: Text(
            'Safe and secure payments. 100% Authentic products.',
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ],
    ),
  );
}

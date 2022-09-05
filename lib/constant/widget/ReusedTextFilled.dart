import 'package:flutter/material.dart';
import 'package:food_order/constant/style.dart';

class ReusedTextFilled extends StatelessWidget {
  const ReusedTextFilled({
    Key? key, required this.onChanged, required this.hintText,
  }) : super(key: key);

  final String hintText;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: onChanged,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: hintTextStyle,
        ),
      ),
    );
  }
}

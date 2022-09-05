import 'package:flutter/material.dart';

class ReusedPasswordFilled extends StatefulWidget {
  const ReusedPasswordFilled({
    Key? key,
    required this.onChanged,
  }) : super(key: key);
  final ValueChanged<String> onChanged;

  @override
  State<ReusedPasswordFilled> createState() => _ReusedPasswordFilledState();
}

class _ReusedPasswordFilledState extends State<ReusedPasswordFilled> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: widget.onChanged,
        obscureText: hidePassword,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState((){
                hidePassword = !hidePassword;
              });
            },
            icon: Icon(
              Icons.remove_red_eye,
              color: hidePassword ? Colors.grey : Colors.blueAccent,
            ),
          ),
          border: InputBorder.none,
          hintText: "password",
          hintStyle: TextStyle(
            color: Colors.black26,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

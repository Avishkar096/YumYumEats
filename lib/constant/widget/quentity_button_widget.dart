import 'package:flutter/material.dart';

class QuantityButtonWidget extends StatelessWidget {
  const QuantityButtonWidget({Key? key, required this.quantity, required this.onPressedRemoveButton, required this.onPressedAddButton}) : super(key: key);

  final int quantity;
  final VoidCallback onPressedRemoveButton;
  final VoidCallback onPressedAddButton;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
      decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(30)
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPressedRemoveButton,
            icon: Icon(Icons.remove,color: Colors.redAccent.shade200,),
          ),
          Text('$quantity',style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),),
          IconButton(
            onPressed: onPressedAddButton,
            icon: Icon(Icons.add,color: Colors.redAccent.shade200,),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Ratiobar extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final double screenWidth;
  const Ratiobar({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: (totalIncome / (totalIncome + totalExpense)) * screenWidth,
            child: Container(
              color: Colors.green,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: (totalExpense / (totalIncome + totalExpense)) * screenWidth,
            child: Container(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controller/transaction_controller.dart';

class AddTransactionModal extends StatelessWidget {
  final TransactionController controller = Get.find();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final RxString transactionType = 'Expense'.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Transaction',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<String>(
                value: transactionType.value,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    transactionType.value = newValue;
                  }
                },
                items: <String>['Expense', 'Income']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLength: 40,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Transaction Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              maxLength: 10,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (descriptionController.text.isNotEmpty) {
                      controller.addTransaction(
                        transactionType.value,
                        descriptionController.text,
                        double.parse(amountController.text),
                        DateTime.now(),
                      );
                      Get.back();
                    } else {
                      Get.snackbar(
                        'Error',
                        'Transaction description cannot be empty.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.blueGrey.shade200,
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

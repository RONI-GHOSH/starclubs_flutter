import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BetController extends GetxController {
  static final List<TextEditingController> amountControllers = [];
  static final List<TextEditingController> secondAmountController = [];
  static final RxList<int> amounts = <int>[].obs;
  static final RxInt totalAmount = 0.obs;

  void buildList(int count) {
    amountControllers.addAll(List.generate(count, (index) => TextEditingController()));
    amounts.addAll(List.generate(count, (index) => 0));
    _updateTotalAmount();
  }
  void buildHarufList(int count) {
    amountControllers.addAll(List.generate(count, (index) => TextEditingController()));
    amounts.addAll(List.generate(count, (index) => 0));
    _updateTotalAmount();
    secondAmountController.addAll(List.generate(count, (index) => TextEditingController()));
    amounts.addAll(List.generate(count, (index) => 0));
    _updateTotalAmount();
  }
  void updateAmount(int index, String value) {
    try {
      // Parse the input value and update the amount at the given index
      int amount = int.parse(value);

      // Ensure the amount is non-negative
      if (amount < 0) {
        throw FormatException("Amount cannot be negative");
      }

      amounts[index] = amount;
      _updateTotalAmount();
    } catch (e) {
      // Handle parsing errors gracefully
      print("Error updating amount at index $index: $e");
      amounts[index] = 0; // Set the amount to 0 in case of an error
    }
  }

  void _updateTotalAmount() {
    // Calculate the total amount by summing up all values in the amounts list
    totalAmount.value = amounts.fold(0, (sum, amount) => sum + amount);
    print("Total amount: ${totalAmount.value}");
  }
  //
  //
  // @override
  // void onClose() {
  //   for (var controller in amountControllers) {
  //     controller.dispose();
  //   }
  //   super.onClose();
  // }
// Function to clear all data
  static void clearAllValues() {
    // Clear the text of each TextEditingController
    for (var controller in amountControllers) {
      controller.text = ''; // Clears the text in the controllers
    }

    for(var controller in secondAmountController){
      controller.text = '';
    }

    // Reset the values in the amounts list to 0
    for (int i = 0; i < amounts.length; i++) {
      amounts[i] = 0; // Set each element to 0 or any default value
    }

    // Reset the totalAmount to 0
    totalAmount.value = 0;
  }

}
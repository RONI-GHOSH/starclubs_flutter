import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matka_web/global_functions.dart';
import 'package:matka_web/golbal_controller.dart';

import '../../alerts.dart';
import '../../app_colors.dart';
import '../../constants.dart';
import '../../storage/user_info.dart';

class WithdrawMoneyPage extends StatefulWidget {
  const WithdrawMoneyPage({super.key});

  @override
  State<WithdrawMoneyPage> createState() => _WithdrawMoneyPageState();
}

class _WithdrawMoneyPageState extends State<WithdrawMoneyPage> {
  TextEditingController amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return GlobalFunctions.refreshPage();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            "Withdraw Money",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.all(20),
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Withdrawal Point",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter Withdrawal Points",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Minimum Withdrawal Amount: ₹${GlobalController.adminModel.value?.minWithdrawalRate}",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        if(amount.text.isNotEmpty){
                          if((int.parse(amount.text))>=600){
                            withdrawMoney();
                          } else{
                            CustomAlert.error("Alert", "Amount should be greater than 600.");
                            amount.clear();
                          }
                        } else{
                          CustomAlert.error("Alert", "Amount Field Cannot be empty.");
                          amount.clear();
                        }
                      },
                      child: Text(
                        "Send Request",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black26, width: 1),
                    ),
                    child: Text(
                      "Withdrawal Time: 6:00 AM - 8:00 PM",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black26, width: 1),
                    ),
                    child: Text(
                      "Maximum hold amount: ₹0",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<void> withdrawMoney() async {
    final url = Uri.parse("$baseUrl/withdrawalrequest.php");
    final id = await UserInfo.getUserInfo() ?? '';
    final body = {"member_id": id, "amount": amount.text.toString()};
    print(url);
    final headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      // "X-Requested-With": "XMLHttpRequest",
    };
    try {
      final response = await http.post(
        url,
        body: body,
        headers: headers,
      );
      // print(response);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = {};
        // Successful request, process the response
        try {
          data = jsonDecode(response.body);
          print(data['status'].toString());

          if (data['status'].toString().compareTo("Low Wallet Balance") == 0) {
            CustomAlert.error("Alert", "Low Wallet Balance");
          } else {
            CustomAlert.success("Success", "Successfully Withdrawal.");
            GlobalFunctions.getProfileDetails();
          }
          // Process data
        } catch (e) {
          print('Error decoding JSON: $e');
          amount.clear();
          // Get.snackbar('Error', 'Failed to decode data');
        }
      } else {
        // Handle server errors
        CustomAlert.error("Alert", "Something went wrong");
        // print('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exceptions
      print('Request failed with error: $e');
      amount.clear();
    }
    GlobalFunctions.getProfileDetails();
    amount.clear();
  }
}

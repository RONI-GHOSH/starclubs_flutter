import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../app_colors.dart';
import '../../constants.dart';
import '../../global_functions.dart';
import '../../storage/user_info.dart';

class TransferMoneyPage extends StatefulWidget {
  const TransferMoneyPage({super.key});

  @override
  State<TransferMoneyPage> createState() => _TransferMoneyPageState();
}

class _TransferMoneyPageState extends State<TransferMoneyPage> {
  TextEditingController number = TextEditingController();
  TextEditingController points = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("Transfer Money"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return GlobalFunctions.refreshPage();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            child: Container(
              width: 400,
              child: Column(
                children: [
                  Text("Now you can transfer your point to another number"),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: number,
                    decoration: InputDecoration(
                        hintText: 'Enter Phone Number',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: points,
                    decoration: InputDecoration(
                        hintText: 'Enter Points', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          transferMoney();
                        },
                        child: Text("Transfer Points")),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> transferMoney() async {
    final url = Uri.parse("$baseUrl/moneytransfer.php");
    final id = await UserInfo.getUserInfo() ?? '';
    final body = {
      "member_id": id,
      "mobile": number.text.toString(),
      "amount": points.text.toString()
    };
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
          if (data['status']
                  .toString()
                  .compareTo("Insuficient fund in wallet") ==
              0) {
            Get.snackbar("Alert", "Insuficient fund in wallet",
                backgroundColor: Colors.redAccent);
          } else if (data['status']
                  .toString()
                  .compareTo("Mobile does not exist") ==
              0) {
            Get.snackbar("Alert", "Mobile does not exist",
                backgroundColor: Colors.redAccent);
          } else {
            Get.snackbar("Success", "Successfully transferred",
                backgroundColor: Colors.green);
          }
          // Process data
        } catch (e) {
          print('Error decoding JSON: $e');
          // Get.snackbar('Error', 'Failed to decode data');
        }
      } else {
        // Handle server errors
        Get.snackbar("Alert", "Something went wrong");
        // print('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exceptions
      print('Request failed with error: $e');
    }
  }
}

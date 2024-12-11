import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../app_colors.dart';
import '../../constants.dart';
import '../../global_functions.dart';
import '../../storage/user_info.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  RefreshIndicator(
      onRefresh: () {
        return GlobalFunctions.refreshPage();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text("Reset Password"),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            child: Container(
              width: 400,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: oldPassword,
                      decoration: InputDecoration(
                          hintText: 'Old Password', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Your detail';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: newPassword,
                      decoration: InputDecoration(
                          hintText: 'New Password', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Your detail';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: confirmPassword,
                      decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Your detail';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (newPassword.text
                                      .toString()
                                      .compareTo(confirmPassword.text.toString()) ==
                                  0) {
                                resetPassword();
                              } else {
                                Get.snackbar("Alert",
                                    "New password and confirm password have to be same");
                              }
                              // resetPassword();
                            }
                          },
                          child: Text("Submit")),
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
      ),
    );
  }

  Future<void> resetPassword() async {
    final url = Uri.parse("$baseUrl/change_password.php");
    final id = await UserInfo.getUserInfo() ?? '';
    final body = {
      "member_id": id,
      "member_password_old": oldPassword.text.toString(),
      "new_password": newPassword.text.toString()
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
          //
          // if(data['status'].toString().compareTo("Low Wallet Balance") == 0){
          //   Get.snackbar("Alert", "Low Wallet Balance" , backgroundColor: Colors.redAccent);
          // } else{
          //   Get.snackbar("Success", "Successfully Withdrawal" , backgroundColor: Colors.green);
          // }
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

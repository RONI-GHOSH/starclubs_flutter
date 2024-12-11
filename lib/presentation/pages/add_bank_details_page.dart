import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:matka_web/alerts.dart';
import 'package:matka_web/golbal_controller.dart';

import '../../app_colors.dart';
import '../../constants.dart';
import '../../global_functions.dart';
import '../../storage/user_info.dart';

class AddBankDetailsPage extends StatefulWidget {
  const AddBankDetailsPage({super.key});

  @override
  State<AddBankDetailsPage> createState() => _AddBankDetailsPageState();
}

class _AddBankDetailsPageState extends State<AddBankDetailsPage> {
  TextEditingController userName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController confirmAccountNumber = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController branchAddress = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    userName.dispose();
    accountNumber.dispose();
    confirmAccountNumber.dispose();
    code.dispose();
    bankName.dispose();
    branchAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        // leading: IconButton(onPressed: (){
        //   GoRouter.of(context).backButtonDispatcher;
        // }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: const Text("Add Bank Details"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return GlobalFunctions.refreshPage();
        },
        child: Form(
          key: _formKey,
          child:  Container(
            alignment: Alignment.center,
            child: Container(
              width: 400,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowIndicator();
                  return false;
                },
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: userName,
                      decoration: InputDecoration(
                          hintText: 'Account Holder Name*',
                          border: OutlineInputBorder()),
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
                      controller: accountNumber,
                      decoration: const InputDecoration(
                          hintText: 'Your detail*', border: OutlineInputBorder()),
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
                      controller: confirmAccountNumber,
                      decoration: InputDecoration(
                          hintText: 'Confirm Your detail*',
                          border: OutlineInputBorder()),
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
                      controller: code,
                      decoration: InputDecoration(
                          hintText: 'IFSC CODE*', border: OutlineInputBorder()),
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
                      controller: bankName,
                      decoration: InputDecoration(
                          hintText: 'Bank Name*', border: OutlineInputBorder()),
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
                      controller: branchAddress,
                      decoration: InputDecoration(
                          hintText: 'Branch Address*',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Your detail';
                        }
                        return null;
                      },
                    ),
                    // const Spacer(),
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
                            addBank();
                          },
                          child: const Text("Submit")),
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

  Future<void> addBank() async {
    try {
      if (_formKey.currentState!.validate()) {
        final url = Uri.parse("$baseUrl/updateMemberPaymentDetails.php");
        final id = await UserInfo.getUserInfo() ?? '';
        final body = {
          "member_id": id,
          "status": "bank",
          "ac_holder_name": userName.text,
          "account_no": accountNumber.text,
          "ifsc_code": code.text,
          "bank_name": bankName.text,
          "branch_name": branchAddress.text
        };
        print(url);
        final headers = {
          "Content-Type": "application/x-www-form-urlencoded",
          // "X-Requested-With": "XMLHttpRequest",
        };

        final response = await http.post(
          url,
          body: body,
          headers: headers,
        );

        if (response.statusCode == 200) {
          // Successful request, process the response
          try {
            // Process data
            print(response.body);
            CustomAlert.success('Success', 'Bank Successfully committed');
          } catch (e) {
            print('Error decoding JSON: $e');
            CustomAlert.error("Error", "Failed to decode data");
          }
        } else {
          // Handle server errors
          CustomAlert.error("Alert", "Your detail went wrong");
          // print('Server error: ${response.statusCode} - ${response.reasonPhrase}');
        }
      } else {}
    } catch (e) {
      // Handle exceptions
      print('Request failed with error: $e');
    }
  }
}

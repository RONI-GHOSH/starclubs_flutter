import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matka_web/golbal_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../alerts.dart';
import '../../app_colors.dart';
import '../../constants.dart';
import '../../global_functions.dart';
import '../../storage/user_info.dart';
import '../components/amount_selector.dart';
import 'upi_payment_page.dart';

class AddMoneyPage extends StatefulWidget {
  const AddMoneyPage({super.key});

  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  TextEditingController money = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    money.clear();
    _AddMoneyController.balance.value = 0;
    _AddMoneyController.currBalance.value =
        double.parse(html.window.localStorage['member_wallet_balance']!);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        // leading: IconButton(onPressed: (){
        //   Get.back();
        // }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: const Text("Add Money"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Add your refresh logic here
          return GlobalFunctions.refreshPage();
        },
        child: Container(
          alignment: Alignment.center,
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(10),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return false;
              },
              child: ListView(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: Card(
                      color: Colors.black,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.wallet,
                            color: Colors.white,
                            size: 50,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(() => Text(
                                "${_AddMoneyController.currBalance.value}",
                                style: const TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    ),
                  ),
                  TextField(
                    controller: money,
                    onChanged: (value) {
                      _AddMoneyController.balance.value = double.parse(value);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Enter Points', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AmountSelector(
                    amount: money,

                  ),
                  Obx(() => Text(
                      "Minimum Deposit Amount ₹${GlobalController.adminModel.value?.minDepositRate}")),
                  // GestureDetector(
                  //   onTap: () async {
                  //     addMoney("Google Pay");
                  //   },
                  //   child: Container(
                  //     width: double.infinity,
                  //     child: Card(
                  //       elevation: 5,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(5)),
                  //       color: Colors.white,
                  //       margin: const EdgeInsets.all(10),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Image.asset(
                  //               "assets/googlepay.png",
                  //               width: 20,
                  //               height: 20,
                  //             ),
                  //             const SizedBox(
                  //               width: 15,
                  //             ),
                  //             const Text("Google Pay"),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     addMoney("PhonePay");
                  //   },
                  //   child: Container(
                  //     width: double.infinity,
                  //     child: Card(
                  //       elevation: 5,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(5)),
                  //       color: Colors.white,
                  //       margin: const EdgeInsets.all(10),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Image.asset(
                  //               "assets/phonepe.png",
                  //               width: 20,
                  //               height: 20,
                  //             ),
                  //             const SizedBox(
                  //               width: 15,
                  //             ),
                  //             const Text("Phone pe"),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     addMoney("paytm");
                  //   },
                  //   child: Container(
                  //     width: double.infinity,
                  //     child: Card(
                  //       elevation: 5,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(5)),
                  //       color: Colors.white,
                  //       margin: const EdgeInsets.all(10),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Image.asset(
                  //               "assets/paytm.png",
                  //               width: 20,
                  //               height: 20,
                  //             ),
                  //             const SizedBox(
                  //               width: 15,
                  //             ),
                  //             const Text("Paytm"),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
          GestureDetector(
                    onTap: () async {
                      addMoney("Gateway");
                      // if (money.text.toString().isNotEmpty &&
                      //     int.parse(money.text.toString()) >= 30) {
                      //   final id = await UserInfo.getUserInfo() ?? '';
                      //   await launchUrlString(
                      //       "https://hmroyal.online/betcircle/payment/index2.php?amount=${money.text.toString()}&email=$id");
                      // } else {
                      //   CustomAlert.error(
                      //       "Alert", "Pls Enter Amount Greater than 30!");
                      // }
                    },
                    child: Container(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Colors.white,
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/qr_code.jpg",
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              const Text("Auto payment"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      addMoney("other");
                      // if (money.text.toString().isNotEmpty &&
                      //     int.parse(money.text.toString()) >= 30) {
                      //   final id = await UserInfo.getUserInfo() ?? '';
                      //   await launchUrlString(
                      //       "https://hmroyal.online/betcircle/payment/index2.php?amount=${money.text.toString()}&email=$id");
                      // } else {
                      //   CustomAlert.error(
                      //       "Alert", "Pls Enter Amount Greater than 30!");
                      // }
                    },
                    child: Container(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Colors.white,
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/qr_code.jpg",
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              const Text("Other"),
                            ],
                          ),
                        ),
                      ),
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

  Future<void> addMoney(String paymentType) async {
    try {
      if (money.text.toString().isNotEmpty &&
          int.parse(money.text.toString()) >= 30) {
          

          if(paymentType.toLowerCase().trim() == "gateway"){
            final id = await UserInfo.getUserInfo() ?? '';
            html.window.location.href = 'https://starclubs.in/betcircle/api/pay_here.php?amount=${money.text.toString()}&udf1=${id}';
            // launchUrlString('https://starclubs.in/betcircle/api/pay_here.php?amount=${money.text.toString()}&udf1=${id}');
             return;
          }


        // final url = Uri.parse("$baseUrl/addMoney.php");

        // final tId = await getTransactionId();
        // print(tId);
        // final body = {
        //   "member_id": id,
        //   "amount" : money.text.toString(),
        //   "transection_id" : tId,
        //   "PaymentType" : paymentType
        // };
        // print(url);
        // final headers = {
        //   "Content-Type": "application/x-www-form-urlencoded",
        //   // "X-Requested-With": "XMLHttpRequest",
        // };

        // final response = await http.post(
        //   url,
        //   body: body,
        //   headers: headers,
        // );

        // if (response.statusCode == 200) {
        //   Map<String,dynamic> data = Map();
        //   // Successful request, process the response
        //   try {
        //     // Process data
        //     print(response.body);
        //     data = jsonDecode(response.body);
        //     final status = data['status'];

        //     // Get.snackbar('Status', 'Bank Successfully committed',

        //     if(GlobalFunctions.isSuccessful(status, "success")){
        //       CustomAlert.success("Success", "Amount Successfully added!");
        //       GlobalFunctions.getProfileDetails();
        //       _AddMoneyController.balance.value = html.window.localStorage['member_wallet_balance']!;
        //     } else{
        //       CustomAlert.error("Alert", "Something Went Wrong!");
        //     }
        //     //     backgroundColor: Colors.green);
        //   } catch (e) {
        //     print('Error decoding JSON: $e');
        //     CustomAlert.error("Error", "Failed to decode data");
        //   }
        // } else {
        //   // Handle server errors
        //   CustomAlert.error("Alert", "Your detail went wrong");
        //   // print('Server error: ${response.statusCode} - ${response.reasonPhrase}');
        // }
        final id = await UserInfo.getUserInfo() ?? '';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(
              paymentAmount: money.text.toString(),
              paymentMethod:
                  paymentType.toLowerCase().trim().replaceAll(" ", ""),
              memberId: id,
            ),
          ),
        );
        setState(() {

        });
      } else {
        CustomAlert.error("Alert", "Pls Enter Amount Greater than 30!");
      }
    } catch (e) {
      // Handle exceptions
      print('Request failed with error: $e');
    }
    _AddMoneyController.balance.value = 0;
  }

  Future<String> getTransactionId() async {
    String transactionId = "";
    try {
      final url = Uri.parse("$baseUrl/transectionId.php");
      final id = await UserInfo.getUserInfo() ?? '';
      final body = {
        "member_id": id,
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
        Map<String, dynamic> data = Map();
        // Successful request, process the response
        try {
          // Process data
          print(response.body);
          data = jsonDecode(response.body);
          transactionId = data['transection_id'];

          // Get.snackbar('Status', 'Bank Successfully committed',
          //     backgroundColor: Colors.green);
        } catch (e) {
          print('Error decoding JSON: $e');
          CustomAlert.error("Error", "Failed to decode data");
        }
      } else {
        // Handle server errors
        CustomAlert.error("Alert", "Your detail went wrong");
        // print('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exceptions
      print('Request failed with error: $e');
    }
    return transactionId;
  }
}

class _AddMoneyController extends GetxController {
  static RxDouble balance = 0.0.obs;
  static RxDouble currBalance = 0.0.obs;

}

class AmountSelector extends StatefulWidget {
  final TextEditingController amount;
  // final Function(int) onAmountSelected;

  const AmountSelector({
    super.key,
    required this.amount
  });

  @override
  _AmountSelectorState createState() => _AmountSelectorState();
}

class _AmountSelectorState extends State<AmountSelector> {
  final List<int> amounts = [100, 200, 500, 1000, 2000, 5000];

  @override
  void initState() {
    super.initState();
    // Initialize _selectedAmount with the current value from the controller if valid
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2, // Adjust this to control height of each button
          ),
          itemCount: amounts.length,
          itemBuilder: (context, index) {
            return Obx(()=> ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: _AddMoneyController.balance.value == amounts[index]
                      ? AppColors.primary
                      : Colors.white,
                  foregroundColor: _AddMoneyController.balance.value == amounts[index]
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _AddMoneyController.balance.value = amounts[index].toDouble();
                    widget.amount.text = _AddMoneyController.balance.value.toString();
                  });
                  // widget.onAmountSelected(_selectedAmount);
                },
                child: Text('₹${amounts[index]}'),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Obx(()=> Text('Selected amount: ₹${_AddMoneyController.balance.value}')),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matka_web/alerts.dart';

import '../../app_colors.dart';
import '../../constants.dart';
import '../../global_functions.dart';
import '../../storage/user_info.dart';

class ManagePaymentPage extends StatefulWidget {
  const ManagePaymentPage({super.key});

  @override
  State<ManagePaymentPage> createState() => _ManagePaymentPageState();
}

class _ManagePaymentPageState extends State<ManagePaymentPage> {
  TextEditingController paytmNumber = TextEditingController();
  TextEditingController googleNumber = TextEditingController();
  TextEditingController phonePeNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  RefreshIndicator(
      onRefresh: () {
        return GlobalFunctions.refreshPage();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text("Manage Payment"),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Container(
              width: 400,
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _customCard(
                    paytmNumber,
                    "Manage Paytm",
                    "paytm",
                    () {
                      addNumber(paytmNumber.text, "paytmNo", "paytm_no");
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _customCard(
                    googleNumber,
                    "Manage Google Pay",
                    "googlepay",
                    () {
                      addNumber(googleNumber.text, "googlePay", "google_pay_no");
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _customCard(
                    phonePeNumber,
                    "Manage Phone Pe",
                    "phonepe",
                    () {
                      addNumber(phonePeNumber.text, "phonepeNo", "phone_pay_no");
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customCard(TextEditingController controller, String title, String img,
      VoidCallback onPressed) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.all(10),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: Image.asset(
          "assets/$img.png",
          width: 30,
        ),
        backgroundColor: Colors.blueGrey.shade50,
        expandedAlignment: Alignment.centerLeft,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: 'Mobile Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder()),
              style: TextStyle(fontSize: 16),
            ),
          ),
          // Add additional widgets here if needed

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white),
                onPressed: onPressed,
                child: const Text("Submit")),
          ),
        ],
      ),
    );
  }

  Future<void> addNumber(String number, String status, String key) async {
    final url = Uri.parse("$baseUrl/updateMemberPaymentDetails.php");
    final id = await UserInfo.getUserInfo() ?? '';
    final body = {"member_id": id, "status": status, key: number};
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

      if (response.statusCode == 200) {
        // Successful request, process the response
        try {
          // Process data
          print(response.body);
          CustomAlert.success("Success", "Successfully uploaded");
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
  }
}

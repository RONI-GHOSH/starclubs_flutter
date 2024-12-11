import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../alerts.dart';
import '../../app_colors.dart';
import '../../constants.dart';
import '../../global_functions.dart';
import '../../storage/user_info.dart';

class WinningHistoryPage extends StatefulWidget {
  const WinningHistoryPage({super.key});

  @override
  State<WinningHistoryPage> createState() => _BetHistoryPageState();
}

class _BetHistoryPageState extends State<WinningHistoryPage> {
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startDate.text =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    endDate.text =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return GlobalFunctions.refreshPage();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text("Winning History", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(16.0), // Add padding around the container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                children: [
                  const SizedBox(height: 16),
                  _buildDatePickerRow("From:", startDate, context),
                  const SizedBox(height: 16),
                  _buildDatePickerRow("To:", endDate, context),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                      ),
                      onPressed: transactionHistory,
                      child: Text("Submit", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    return DateController.historyList.isEmpty
                        ? Center(
                      child: Text(
                        DateController.empty.value,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                        : Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        DateController.historyList.length,
                            (index) => _transactionCard(DateController.historyList[index]),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerRow(String label, TextEditingController controller, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: TextStyle(fontSize: 16)),
        ),
        Expanded(
          flex: 5,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Select a date",
              prefixIcon: Icon(Icons.calendar_month, color: Colors.red),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Rounded borders
              ),
            ),
            readOnly: true,
            onTap: () {
              selectDate(controller, context);
            },
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }


  Widget _transactionCard(TransactionHistory item) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      color: Colors.white, // Equivalent to android:background="@color/white"
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                item.transactionTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                item.transactionAmount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                item.batNumber,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(item.transactionId),
            ],
          ),
          SizedBox(height: 5.0),
          Text(item.transactionUpdateDate),
        ],
      ),
    );
  }

  Future<void> transactionHistory() async {
    final url = Uri.parse("$baseUrl/GetWinningTransactionDetails.php");
    final id = await UserInfo.getUserInfo() ?? '';
    final body = {
      "member_id": id,
      "date_from": startDate.text.toString(),
      "date_to": endDate.text.toString()
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
          print(data);
          print(data['status'].toString());
          //
          if (data['status'].toString().compareTo("success") == 0) {
            TransactionHistoryResponse historyResponse =
                TransactionHistoryResponse.fromJson(data);
            DateController.historyList
                .addAll(historyResponse.transectionHistoryList);
          } else{
            CustomAlert.error("Alert", "No Winning History.");
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

  Future<void> selectDate(
      TextEditingController controller, BuildContext context) async {
    // final Widget? child;
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // A specific date from history
      firstDate: DateTime(1900, 1, 1), // Allow dates starting from 1900
      lastDate: DateTime.now(),
    ).then(
      (value) {
        if (value != null) {
          DateFormat formatter = DateFormat('yyyy-MM-dd');
          DateController.date.value = formatter.format(value);
          controller.text = DateController.date.value;
          print(controller.text);
        }
      },
    );
  }
}

class DateController extends GetxController {
  static RxString date = "".obs;
  static RxList historyList = [].obs;
  static RxString empty = "No Any Transaction".obs;
}

class TransactionHistoryResponse {
  final String status;
  final List<TransactionHistory> transectionHistoryList;

  TransactionHistoryResponse(
      {required this.status, required this.transectionHistoryList});

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponse(
      status: json['status'],
      transectionHistoryList: json['TransectionHistoryList'] != null
          ? List<TransactionHistory>.from(json['TransectionHistoryList']
              .map((item) => TransactionHistory.fromJson(item)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'TransectionHistoryList':
          transectionHistoryList.map((item) => item.toJson()).toList(),
    };
  }
}

class TransactionHistory {
  final String transactionTitle;
  final String senderName;
  final String receiverName;
  final String transactionId;
  final String transactionAmount;
  final String transactionUpdateDate;
  final String transactionType;
  final String marketName;
  final String batNumber;
  final String gameName;
  final String betType;

  TransactionHistory({
    required this.transactionTitle,
    required this.senderName,
    required this.receiverName,
    required this.transactionId,
    required this.transactionAmount,
    required this.transactionUpdateDate,
    required this.transactionType,
    required this.marketName,
    required this.batNumber,
    required this.gameName,
    required this.betType,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
      transactionTitle: json['transaction_title'],
      senderName: json['SenderName'],
      receiverName: json['ReciverName'],
      transactionId: json['transaction_id'],
      transactionAmount: json['transaction_amount'],
      transactionUpdateDate: json['transaction_update_date'],
      transactionType: json['transaction_type'],
      marketName: json['market_name'],
      batNumber: json['bat_number'],
      gameName: json['game_name'],
      betType: json['bet_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_title': transactionTitle,
      'SenderName': senderName,
      'ReciverName': receiverName,
      'transaction_id': transactionId,
      'transaction_amount': transactionAmount,
      'transaction_update_date': transactionUpdateDate,
      'transaction_type': transactionType,
      'market_name': marketName,
      'bat_number': batNumber,
      'game_name': gameName,
      'bet_type': betType,
    };
  }
}

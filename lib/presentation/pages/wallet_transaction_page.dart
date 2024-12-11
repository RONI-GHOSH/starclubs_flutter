import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../app_colors.dart';
import '../../constants.dart';
import '../../global_functions.dart';
import '../../storage/user_info.dart';

class WalletTransactionPage extends StatefulWidget {
  const WalletTransactionPage({super.key});

  @override
  State<WalletTransactionPage> createState() => _WalletTransactionPageState();
}

class _WalletTransactionPageState extends State<WalletTransactionPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTransaction();
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
          title: Text("Wallet Transaction Page"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Container(
              width: 400,
              child: Column(
                children: [
                  Obx(() => _WalletController.walletHistory.isEmpty
                      ? Container(
                          width: 400,
                          child: Center(
                            child: Text("No Any Transactions"),
                          ),
                        )
                      : Wrap(
                          children: List.generate(
                            _WalletController.walletHistory.length,
                            (index) {
                              return walletTransactionCard(
                                  _WalletController.walletHistory[index]);
                            },
                          ),
                        ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getTransaction() async {
    try {
      final url = Uri.parse("$baseUrl/GetWalletTransactionHistory.php");
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
          final list = data['TransectionHistoryList'] as List;
          final transactionList =
              list.map((e) => TransactionModel.fromJson(e)).toList();
          _WalletController.walletHistory.assignAll(transactionList);
          print(_WalletController.walletHistory);
          // _WalletController.walletHistory.addAll(iterable)
          // Get.snackbar('Status', 'Bank Successfully committed',
          //     backgroundColor: Colors.green);
        } catch (e) {
          print('Error decoding JSON: $e');
          Get.snackbar('Error', 'Failed to decode data');
        }
      } else {
        // Handle server errors
        Get.snackbar("Alert", "Your detail went wrong");
        // print('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exceptions
      print('Request failed with error: $e');
    }
  }

  Widget walletTransactionCard(TransactionModel item) {
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
                " ₹ ${item.transactionAmount}",
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
                "Transaction Id:",
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
}

class _WalletController extends GetxController {
  static RxList walletHistory = [].obs;
}

class TransactionModel {
  final String transactionTitle;
  final String senderName;
  final String receiverName;
  final String transactionId;
  final String transactionAmount;
  final String transactionUpdateDate;
  final String transactionType;
  final String transferTo;
  final String marketName;
  final String batNumber;
  final String gameName;
  final String betType;

  TransactionModel({
    required this.transactionTitle,
    required this.senderName,
    required this.receiverName,
    required this.transactionId,
    required this.transactionAmount,
    required this.transactionUpdateDate,
    required this.transactionType,
    required this.transferTo,
    required this.marketName,
    required this.batNumber,
    required this.gameName,
    required this.betType,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionTitle: json['transaction_title'] ?? '',
      senderName: json['SenderName'] ?? '',
      receiverName: json['ReciverName'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      transactionAmount: json['transaction_amount'] ?? '',
      transactionUpdateDate: json['transaction_update_date'] ?? '',
      transactionType: json['transaction_type'] ?? '',
      transferTo: json['transferTo'] ?? '',
      marketName: json['market_name'] ?? '',
      batNumber: json['bat_number'] ?? '',
      gameName: json['game_name'] ?? '',
      betType: json['bet_type'] ?? '',
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
      'transferTo': transferTo,
      'market_name': marketName,
      'bat_number': batNumber,
      'game_name': gameName,
      'bet_type': betType,
    };
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../alerts.dart';
import '../../app_colors.dart';
import '../../constants.dart';
import '../../global_functions.dart';
import '../../storage/user_info.dart';

class GameRatePage extends StatefulWidget {
  const GameRatePage({super.key});

  @override
  State<GameRatePage> createState() => _GameRatePageState();
}

class _GameRatePageState extends State<GameRatePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGameRate();
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
          title: Text("Game Rate Page"),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            width: 400,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(() => GameRateController.isFail.value
                      ? Text(GameRateController.empty.value)
                      : CircularProgressIndicator())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getGameRate() async {
    try {
      final url = Uri.parse("$baseUrl/gameRate.php");
      final id = await UserInfo.getUserInfo() ?? '';
      final body = {
        "member_id": id,
      };
      print(url);
      final headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        // "X-Requested-With": "XMLHttpRequest",
      };

      final response = await http.get(
        url,
        headers: headers,
      );
      // print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = Map();
        // Successful request, process the response
        try {
          // Process data
          print(response.body);
          data = jsonDecode(response.body);
          if (data['status'].toString().compareTo("failure") == 0) {
            GameRateController.isFail.value = true;
          }
          // data = jsonDecode(response.body);
          // _WalletController.walletHistory.addAll(iterable)
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
  }
}

class GameRateController extends GetxController {
  static RxBool isFail = false.obs;
  static RxString empty = "No Any List".obs;
}

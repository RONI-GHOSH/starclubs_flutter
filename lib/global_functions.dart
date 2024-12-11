import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../../alerts.dart';
import '../../constants.dart';
import '../../storage/user_info.dart';
import 'golbal_controller.dart';
import 'models/set_bet_model.dart';
import 'models/user_profile_model.dart';
import 'dart:html' as html;
class GlobalFunctions {
  static bool isSuccessful(String first, String second) {
    if (first.compareTo(second) == 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> getProfileDetails() async {
    final url = Uri.parse("$baseUrl/membeProfileDetails.php");
    final id = await UserInfo.getUserInfo() ?? '';
    print(id);
    final body = {"member_id": id};
    final headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      // "X-Requested-With": "XMLHttpRequest",
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Parse the response
        final data = jsonDecode(response.body);

        print(data);
        if (data['status'].toString() == "success") {
          // Successfully retrieved data
          UserProfileModel model =
              UserProfileModel.fromJson(data['profile_details'][0]);
          model.updateUserDetails();
        } else {
          // Handle unexpected status
          CustomAlert.error("Error", "Failed to load data");
        }
      } else {
        // Handle non-200 responses
        CustomAlert.error("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
      CustomAlert.error("Error", "Failed to decode data");
    }
  }

  static Future<void> setBet(SetBetModel model) async {
    try {
      final url = Uri.parse("$baseUrl/jantari_betting.php");

      // Convert SetBetModel to JSON string
      final body = {"jantari_bet_details": jsonEncode(model.toJson())};
      print(url);

      final headers = {
        // Use application/json for JSON body
        // "Content-Type": "application/json",
        // "X-Requested-With": "XMLHttpRequest",
      };

      final response = await http.post(
        url,
        body: body,
        // headers: headers,
      );

      // print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = {};
        // Successful request, process the response
        try {
          // Process data
          print(response.body);
          data = jsonDecode(response.body);
          if (data['status'].toString().compareTo("success") == 0) {
            CustomAlert.success("Success", "Bet Successfully!");
            // GlobalFunctions.getProfileDetails();
            GlobalController.walletMoney.value =
            data['get_new_wallet_amt_jantari'];
          } else {
            CustomAlert.error("Alert", data['status']);
          }

          // data = jsonDecode(response.body);
          // Assuming you have a TabGamesModel class and a controller to update
          // _GameViewController.tabGames.value = TabGamesModel.fromJson(data);
          // Optionally, display success message
          // Get.snackbar('Status', 'Bet successfully placed', backgroundColor: Colors.green);
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

  static Future<void> refreshPage() async{
    return Future.delayed(
      const Duration(seconds: 1),
          () {
        return html.window.location.reload();
      },
    );


  }
  static Future<void> refreshPageUsingWidget(Widget widget) async{
    return Future.delayed(
      const Duration(seconds: 0),
          () {
        return Get.off(widget);
      },
    );


  }
}

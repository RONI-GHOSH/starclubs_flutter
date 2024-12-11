import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

import '../../../../alerts.dart';
import '../../../../constants.dart';
import '../../../../global_functions.dart';
import '../../../../golbal_controller.dart';
import '../../../../models/admin_model.dart';
import '../../../../models/color_bet_market_model.dart';
import '../../../../models/delhi_market_model.dart';
import '../../../../models/star_line_market_model.dart';

class HomePageController extends GetxController {
  static RxList marketList = [].obs;
  static RxList sliderImages = [].obs;
  static RxString marketType = "".obs;

  static getAdminDetails() async {
    // GlobalController.adminModel.value = (null as AdminModel); // ignore: unnecessary_cast
    final url = Uri.parse("$baseUrl/admin_details.php");
    final headers = {
      "Content-Type": "application/json",
      // "X-Requested-With": "XMLHttpRequest",
    };
    // Successful request, process the response
    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        // Successful request
        final data = jsonDecode(response.body);
        // //
        print(response.body);
        final result = data['admin Details'][0];
        AdminModel model = AdminModel.fromJson(result);
        GlobalController.updateAdminModel(model);
        marketType.value = model.frontGameStatus;
        print(marketType.value);
      } else {
        // Handle non-200 responses
        CustomAlert.error("Error", "Failed to load admin details");
      }
    } catch (e) {
      // Handle errors like network issues, JSON decoding errors, etc.

      CustomAlert.error("Error", "Failed to decode admin details");
    }
  }

  static getImages() async {
    sliderImages.clear();
    final url =
        Uri.parse("https://starclubs.in/betcircle/api/getSliderImages.php");
    final headers = {
      "Content-Type": "application/json",
      // "X-Requested-With": "XMLHttpRequest",
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        // Parse the response
        final data = jsonDecode(response.body);

        if (data['status'].toString() == "200") {
          // Successfully retrieved data
          final imagesList = data['sliderImagesList'] as List<dynamic>;
          if (imagesList.isNotEmpty) {
            sliderImages
                .addAll(imagesList.map((url) => url.toString()).toList());
          } else {
            // Default images if the list is empty
            sliderImages.addAll([
              "https://picsum.photos/1080/720",
              "https://picsum.photos/1080/720"
            ]);
          }
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

      CustomAlert.error("Error", "Failed to decode data");
    }
  }

  static Future<void> getMarketList() async {
    HomePageController.marketList.clear();
    final url = Uri.parse("$baseUrl/getDelhiMarket.php");
    final headers = {
      "Content-Type": "application/json",
      // "X-Requested-With": "XMLHttpRequest",
    };
    // Successful request, process the response

    final response = await http.post(url, headers: headers);
    try {
      if (response.statusCode == 200) {
        // Successful request

        final data = jsonDecode(response.body);
        //
        print(data);
        final list = data['marketList'];
        for (var data in list) {
          HomePageController.marketList.add(DelhiMarketModel.fromJson(data));
        }
        print("gali market fetch successfully");
        //
        //
      } else {
        // Handle non-200 responses
        CustomAlert.error("Error", "Failed to load market list");
      }
    } catch (e) {
      // Handle errors like network issues, JSON decoding errors, etc.
      // Handle errors like network issues, JSON decoding errors, etc.

      CustomAlert.error("Error", "Failed to decode market list");
    }
  }

  static Future<void> getColorMarketList() async {
    HomePageController.marketList.clear();
    final url = Uri.parse("$baseUrl/colorMarketList.php");
    final headers = {
      "Content-Type": "application/json",
      // "X-Requested-With": "XMLHttpRequest",
    };
    // Successful request, process the response

    final response = await http.post(url, headers: headers);
    try {
      if (response.statusCode == 200) {
        // Successful request

        final data = jsonDecode(response.body);
        //
        print(response.body);
        final list = data['starLineMarketList'];
        for (var data in list) {
          HomePageController.marketList.add(ColorBetMarketModel.fromJson(data));
        }
        print("Color market fetch successfully");
        //
        //
      } else {
        // Handle non-200 responses
        CustomAlert.error("Error", "Failed to load Color Market list");
      }
    } catch (e) {
      // Handle errors like network issues, JSON decoding errors, etc.
      // Handle errors like network issues, JSON decoding errors, etc.

      CustomAlert.error("Error", "Failed to decode market list");
    }
  }

  static Future<void> getStarLineMarketList() async {
    HomePageController.marketList.clear();
    final url = Uri.parse("$baseUrl/starLineMarketList.php");
    final headers = {
      "Content-Type": "application/json",
      // "X-Requested-With": "XMLHttpRequest",
    };
    // Successful request, process the response

    final response = await http.post(url, headers: headers);
    try {
      if (response.statusCode == 200) {
        // Successful request

        final data = jsonDecode(response.body);
        //
        print(response.body);
        final list = data['starLineMarketList'];
        for (var data in list) {
          HomePageController.marketList.add(StarLineMarketModel.fromJson(data));
        }
        print("starline market fetch successfully");
        //
        //
      } else {
        // Handle non-200 responses
        CustomAlert.error("Error", "Failed to load Star Line Market list");
      }
    } catch (e) {
      // Handle errors like network issues, JSON decoding errors, etc.
      // Handle errors like network issues, JSON decoding errors, etc.

      CustomAlert.error("Error", "Failed to decode market list");
    }
  }
}

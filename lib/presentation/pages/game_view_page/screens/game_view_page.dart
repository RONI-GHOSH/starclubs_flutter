import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matka_web/app_colors.dart';
import 'package:matka_web/models/tab_games_model.dart';
import 'package:matka_web/presentation/pages/game_view_page/screens/haruf_page.dart';

import '../../../../alerts.dart';
import '../../../../constants.dart';
import '../../../../global_functions.dart';
import '../../../../models/delhi_market_model.dart';
import '../../../../storage/user_info.dart';
import '../data/game_view_controller.dart';
import 'crossing_content.dart';
import 'first_tab_content.dart';

class GameViewPage extends StatefulWidget {
  final DelhiMarketModel model;
  const GameViewPage({super.key, required this.model});

  @override
  State<GameViewPage> createState() => _GameViewPageState();
}

class _GameViewPageState extends State<GameViewPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offers();
    _gameViewList();
  }

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Game View",style: TextStyle(color: Colors.white),),
          backgroundColor:
              AppColors.primary, // Replace with AppColors.primary if defined
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Container(
              color: Colors.black,
              child: TabBar(
                labelColor: Colors.white,
                isScrollable: true,
                tabs: [
                  Tab(text: 'DELHI JODI'),
                  Tab(text: 'HARUF'),
                  Tab(text: 'CROSSING'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            FirstTabContent(
                count: 100, model: GameViewController.tabGames.value),
            HarufPage(model: GameViewController.tabGames.value, count1: 10, count2: 10),
            CrossingContent(),
          ],
        ),
      ),
    );
  }

  Future<void> _gameViewList() async {
    // String transactionId ="";
    try {
      final url = Uri.parse("$baseUrl/selectGame.php");
      final id = widget.model.marketId;
      final name = widget.model.marketName;
      print(id);
      final body = {"market_id": id, "market_name": name};
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
          GameViewController.tabGames.value = TabGamesModel.fromJson(data);
          print(
              "${GameViewController.tabGames.value.marketName.isEmpty} 0000000000000000000000000000000000");
          // print(marketChartLists);
          // for (var chartList in marketChartLists) {
          //   final list = chartList as List;
          //   final result = list.map((e) => ChartListItem.fromJson(e)).toList();
          //   ChartController.results.addAll(result);
          // }
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

  Future<void> _userPaymentDetails() async {
    // String transactionId ="";
    try {
      final url = Uri.parse("$baseUrl/fetchMemberPaymentDetails.php");
      final id = await UserInfo.getUserInfo() ?? '';
      final name = widget.model.marketName;
      print(id);
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
          // final marketChartLists = data['MarketChartList'] as List;
          // print(marketChartLists);
          // for (var chartList in marketChartLists) {
          //   final list = chartList as List;
          //   final result = list.map((e) => ChartListItem.fromJson(e)).toList();
          //   ChartController.results.addAll(result);
          // }
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

  Future<void> _offers() async {
    // String transactionId ="";
    try {
      final url = Uri.parse("$baseUrl/offers.php");
      final id = await UserInfo.getUserInfo() ?? '';
      final name = widget.model.marketName;
      print(id);
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
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = Map();
        // Successful request, process the response
        try {
          // Process data
          print(response.body);
          data = jsonDecode(response.body);
          // final marketChartLists = data['MarketChartList'] as List;
          // print(marketChartLists);
          // for (var chartList in marketChartLists) {
          //   final list = chartList as List;
          //   final result = list.map((e) => ChartListItem.fromJson(e)).toList();
          //   ChartController.results.addAll(result);
          // }
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

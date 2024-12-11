import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../alerts.dart';
import '../../app_colors.dart';
import '../../constants.dart';
import '../../global_functions.dart';

class ChartPage extends StatefulWidget {
  final String mId;
  const ChartPage({super.key, required this.mId});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChartList();
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
          title: Text("Chart Page"),
        ),
        body: Obx(() {
          if (ChartController.results.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            // Reverse the list to start showing from the last item
            final reversedList = ChartController.results.reversed.toList();

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: reversedList.map((item) {
                  return Container(
                    width: 60,
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          item.date,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Divider(
                          thickness: 2,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.panelSecond,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
        }),
      ),
    );
  }

  Future<void> getChartList() async {
    // String transactionId ="";
    try {
      final url = Uri.parse("$baseUrl/getMarketChartList.php");
      final id = widget.mId;
      print(id);
      final body = {
        "market_id": id,
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
          final marketChartLists = data['MarketChartList'] as List;
          print(marketChartLists);
          for (var chartList in marketChartLists) {
            final list = chartList as List;
            final result = list.map((e) => ChartListItem.fromJson(e)).toList();
            ChartController.results.addAll(result);
          }
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

class ChartController extends GetxController {
  static RxList results = [].obs;
}

class ChartListItem {
  final String panelSecond;
  final String date;

  ChartListItem({
    required this.panelSecond,
    required this.date,
  });

  // Factory method to create a PreviousWinningsModel from a JSON map
  factory ChartListItem.fromJson(Map<String, dynamic> json) {
    return ChartListItem(
      panelSecond: json['panelsecond'],
      date: json['Date'],
    );
  }

  // Method to convert a PreviousWinningsModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'panelsecond': panelSecond,
      'Date': date,
    };
  }
}

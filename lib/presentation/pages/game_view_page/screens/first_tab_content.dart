import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../alerts.dart';
import '../../../../app_colors.dart';
import '../../../../global_functions.dart';
import '../../../../models/lottry_model.dart';
import '../../../../models/set_bet_model.dart';
import '../../../../models/tab_games_model.dart';
import '../../../../storage/user_info.dart';
import '../../../components/bet_card.dart';
import '../data/bet_controller.dart';
import '../data/game_view_controller.dart';

class FirstTabContent extends StatefulWidget {
  final int count;
  final TabGamesModel model;
  FirstTabContent({super.key, required this.count, required this.model});

  @override
  State<FirstTabContent> createState() => _FirstTabContentState();
}

class _FirstTabContentState extends State<FirstTabContent> {
  bool isLoading = true; // Flag to track loading state
  // final BetController controller = BetController();
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 1), fetchData);
  }

  Future<void> fetchData() async {
    try {
      BetController.amountControllers.clear();
      BetController.totalAmount.value = 0;
      BetController.amounts.clear();
      // BetController(widget.count);
      BetController().buildList(widget.count);

      // Simulate loading delay (remove this if real data loading)
      // await Future.delayed(const Duration(seconds: 1)); // Adjust delay as needed

      setState(() {
        isLoading = false; // Data has finished loading
      });
    } catch (e) {
      print("something is wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    // BetController controller = Get.put(BetController(widget.count));

    if (isLoading) {
      // controller = Get.put(BetController(widget.count));
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        return GlobalFunctions.refreshPage();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: Get.height * 0.03,
            ),
            Wrap(
              spacing: 8.0, // Adjust spacing between items as needed
              runSpacing: 8.0, // Adjust spacing between lines as needed
              children: List.generate(widget.count, (index) {
                return BetCard(
                  title: index.toString().padLeft(2, '0'),
                  amount: BetController.amountControllers[index],
                  onChanged: (value) {
                    BetController().updateAmount(index, value);
                  },
                );
              }),
            ),
            SizedBox(
              height: Get.height * 0.06,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text("Total Amount"),
                      Obx(
                        () => Text(
                          BetController.totalAmount.value
                              .toStringAsFixed(2), // Format total amount
                          style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                      AppColors.primary,
                    )),
                    onPressed: () {
                      _handleContinue();
                    },
                    child: Text("Continue", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleContinue() async {
    // Prepare the SetBetModel
    print(
        "20% Completed ------------------------------------------------------");
    final id = await UserInfo.getUserInfo();

    final lotteries;
    try {
      lotteries = BetController.amountControllers
          .asMap()
          .entries
          .map((entry) {
            if (entry.value.text != 0) {
              LotteryModel model =
                  LotteryModel(lotteryAmount: 0, lotteryNumber: "");
              final number = entry.key.toString();
              print(number);
              final amount = int.tryParse(entry.value.text) ?? 0;
              // Only return a LotteryModel if the amount is greater than 0
              if (amount > 0) {
                print("Processing Lottery: Number=$number, Amount=$amount");
                model = LotteryModel(
                  lotteryNumber: number.padLeft(2,'0'),
                  lotteryAmount: amount,
                );
                print(model.toJson());
                return model;
              }
              return null;
            }
          })
          .whereType<LotteryModel>()
          .toList();
      print(
          "30% Completed ------------------------------------------------------");
    } catch (e) {
      print("Error processing amount controllers: $e");
      CustomAlert.error("Error", "Failed to process amounts");
      return; // Exit early if there's an error
    }

    try {
      TabGamesModel model = GameViewController.tabGames.value;
      SetBetModel betModel = SetBetModel(
        lotteries: lotteries,
        memberId: id, // Replace with actual member ID
        marketId: model.marketId.toString(), // Replace with actual market ID
        gameId: model.list[0].marketGameId
            .toString(), // Replace with actual game ID
        status: 'Active',
        marketName: model.marketName.toString(),
        gameName: model.list[0].gameName.toString(),
        totalAmount: BetController.totalAmount.value.toInt().toString(),
      );
      print(
          "50% Completed ------------------------------------------------------");
      await GlobalFunctions.setBet(betModel);
      BetController.clearAllValues();
    } catch (e) {
      CustomAlert.error("Error", "Failed to place bet");
    }
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../alerts.dart';
import '../../../../app_colors.dart';
import '../../../../global_functions.dart';
import '../../../../models/lottry_model.dart';
import '../../../../models/set_bet_model.dart';
import '../../../../models/tab_games_model.dart';
import '../../../../storage/user_info.dart';
import '../data/bet_controller.dart';
import '../data/game_view_controller.dart';

class CrossingContent extends StatefulWidget {
  const CrossingContent({super.key});

  @override
  State<CrossingContent> createState() => _CrossingContentState();
}

class _CrossingContentState extends State<CrossingContent> {
  TextEditingController firstNum = TextEditingController();
  TextEditingController secondNum = TextEditingController();
  TextEditingController amount = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), fetchData);
  }

  void fetchData() async {
     // Simulate loading delay
    GameViewController.updateDate();
    GameViewController.lotteries.clear();
    BetController.totalAmount.value = 0;
    // await Future.delayed(const Duration(seconds: 1));
     // Update after fetching data
    setState(() {
      isLoading = false;
    }); // Trigger UI rebuild after data is loaded
  }
  @override
  void dispose() {
    // TODO: implement dispose
    firstNum.dispose();
    secondNum.dispose();
    amount.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return  RefreshIndicator(
        onRefresh: () {
      return GlobalFunctions.refreshPage(); // Refresh logic here
    },
    child: SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        alignment: Alignment.topCenter,
        child: Container(
          color: Colors.white,
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/crossing.png",
                width: 150,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: Colors.black,
                    size: 30,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Obx(() => Text("${GameViewController.crossingDate.value}")),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("First Number"),
                        TextField(
                          controller: firstNum,
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text("❌"),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text("Second Number"),
                        TextField(
                          controller: secondNum,
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Enter Amount"),
                        TextField(
                          controller: amount,
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(AppColors.primary),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                          onPressed: () {
                            GameViewController.updateLotteries(
                                firstNum.text, secondNum.text, amount.text);
                          },
                          child: Text("Add")))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Obx(
                () => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(GameViewController.lotteries.length,
                      (index) {
                    return GestureDetector(
                      // onTap: () {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AlertDialog(
                      //         title: Text("Remove Bet"),
                      //         content: Text(
                      //             "Are you sure you want to remove this bet?"),
                      //         actions: [
                      //           TextButton(onPressed: () {}, child: Text("No")),
                      //           TextButton(
                      //               onPressed: () {}, child: Text("Yes")),
                      //         ],
                      //       );
                      //     },
                      //   );
                      // },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 90, // Adjust width as needed
                            height: 40, // Adjust height as needed
                            color: Colors
                                .orange, // Set the color to orange as shown in the image
                            child: Text(
                              GameViewController.lotteries[index].lotteryNumber,
                              style: TextStyle(
                                  color: Colors
                                      .white), // White text color for contrast
                            ),
                          ), // Small space between the two containers
                          Container(
                            alignment: Alignment.center,
                            width: 90, // Adjust width as needed
                            height: 40, // Adjust height as needed
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors
                                      .black), // Border color to match the first container
                              color: Colors
                                  .white, // White background color as shown in the image
                            ),
                            child: Text(
                              GameViewController.lotteries[index].lotteryAmount
                                  .toString(),
                              style: TextStyle(
                                  color: Colors
                                      .black), // Black text color for contrast
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
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
                                .toInt()
                                .toString(), // Format total amount
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                          child: Text("Continue"))),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> _handleContinue() async {
    // List<LotteryModel> lotteries = [];
    final id = await UserInfo.getUserInfo();
    // Prepare the SetBetModel
    try {
      print(
          "20% Completed ------------------------------------------------------");
      print(
          "30% Completed ------------------------------------------------------");
    } catch (e) {
      print("Error processing amount controllers: $e");
      CustomAlert.error("Error", "Failed to process amounts");
      return; // Exit early if there's an error
    }

    print(BetController.totalAmount.value.toInt().toString());
    try {
      TabGamesModel model = GameViewController.tabGames.value;
      //
      SetBetModel betModel = SetBetModel(
        lotteries: GameViewController.lotteries.value as List<LotteryModel>,
        memberId: id, // Replace with actual member ID
        marketId: model.marketId.toString(), // Replace with actual market ID
        gameId: model.list[0].marketGameId
            .toString(), // Replace with actual game ID
        status: 'Active',
        marketName: model.marketName.toString(),
        gameName: model.list[0].gameName.toString(),
        totalAmount: BetController.totalAmount.value.toInt().toString(),
      );
      //
      //   // print(betModel.toJson());

      print(
          "50% Completed ------------------------------------------------------");
      // Call the _setBet function
      await GlobalFunctions.setBet(betModel);
      GlobalFunctions.getProfileDetails();
    } catch (e) {
      CustomAlert.error("Error", "Failed to place bet");
    }
    GameViewController.lotteries.clear();
    firstNum.clear();
    secondNum.clear();
    amount.clear();
    BetController.totalAmount.value = 0;
  }
}

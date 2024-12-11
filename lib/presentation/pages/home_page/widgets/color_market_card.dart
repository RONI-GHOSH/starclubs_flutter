import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:matka_web/alerts.dart';
import 'package:matka_web/app_colors.dart';
import 'package:matka_web/models/color_bet_market_model.dart';
import 'package:matka_web/models/star_line_market_model.dart';
import 'package:matka_web/presentation/pages/chart_page.dart';
import 'package:matka_web/presentation/pages/game_view_page/screens/game_view_page.dart';

import '../../../../models/delhi_market_model.dart';

class ColorMarketCard extends StatefulWidget {
  final ColorBetMarketModel model;

  const ColorMarketCard({
    required this.model,
  });

  @override
  State<ColorMarketCard> createState() => _ColorMarketCardState();
}

class _ColorMarketCardState extends State<ColorMarketCard> {
  // @override
  // Widget build(BuildContext context) {
  //   return SizedBox(
  //     width: 400,
  //     child: Card(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(8.0),
  //         side: const BorderSide(color: Colors.orange, width: 2.0),
  //       ),
  //       margin: const EdgeInsets.symmetric(vertical: 8.0),
  //       child: Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(children: [
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     widget.model.marketName,
  //                     style: const TextStyle(
  //                         fontSize: 20.0,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.orange),
  //                   ),
  //                   const SizedBox(height: 8.0),
  //                   const Text(
  //                     "**",
  //                     style: TextStyle(fontSize: 18.0),
  //                   ),
  //                   const SizedBox(height: 4.0),
  //                   Text(
  //                     "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
  //                     style: const TextStyle(fontSize: 16.0),
  //                   ),
  //                   const Divider(),
  //                 ],
  //               ),
  //               const Spacer(),
  //               IconButton(
  //                 icon: Image.asset(
  //                   "assets/chart_icon.png",
  //                   width: 45,
  //                 ),
  //                 onPressed: () {
  //                    Get.to(() => ChartPage(mId: widget.model.marketId));
  //                 },
  //               ),
  //               CircleAvatar(
  //                 backgroundColor: AppColors.primary,
  //                 child: IconButton(
  //                   icon: const Icon(Icons.play_arrow, color: Colors.white),
  //                   onPressed: () {
  //                   },
  //                 ),
  //               ),
  //             ]),
  //             const SizedBox(height: 3.0),
  //             const Divider(
  //               thickness: 2,
  //             ),
  //             const SizedBox(height: 3.0),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 widget.model.activeStatus.compareTo("close") == 0
  //                     ? const Text(
  //                   "Market Closed!",
  //                   style: TextStyle(
  //                       fontSize: 18.0,
  //                       color: Colors.red,
  //                       fontWeight: FontWeight.bold),
  //                 )
  //                     : const Text(
  //                   "Bet Run Today!",
  //                   style: TextStyle(
  //                       fontSize: 18.0,
  //                       color: Colors.green,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //                 const Spacer(),
  //                 Text(
  //                   'CLOSE BET: ${widget.model.marketTime}',
  //                   style:
  //                   const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 400,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: Colors.orange, width: 2.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
              ),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.model.marketTime,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/calender.svg",
                      width: 40,
                    ),
                    onPressed: () {
                      Get.to(() => ChartPage(mId: widget.model.marketId));
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.model.marketName,
                        style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        "${widget.model.winningNumberLotteryNumber}",
                        style: const TextStyle(fontSize: 20.0,color: Colors.green),
                      ),
                      widget.model.activeStatus.compareTo("Market Closed!") == 0
                          ? const Text(
                        "Market Closed!",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      )
                          : const Text(
                        "Bet Run Today!",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // if (!(widget.model.activeStatus.compareTo("Market Closed!") ==
                      //     0)) {
                      //   Get.to(() => GameViewPage(
                      //     model: widget.model,
                      //   ));
                      // } else {
                      //   CustomAlert.error(
                      //       "Market Closed", "The market is already closed.");
                      // }
                    },
                    child: Image.asset(
                      "assets/play.png",
                      height: 100,
                    ),
                  )
                ]),
          ],
        ),
      ),
    );
  }
}


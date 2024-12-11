import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:matka_web/alerts.dart';
import 'package:matka_web/app_colors.dart';
import 'package:matka_web/presentation/pages/chart_page.dart';
import 'package:matka_web/presentation/pages/game_view_page/screens/game_view_page.dart';

import '../../../../models/delhi_market_model.dart';

class DelhiMarketCard extends StatefulWidget {
  final DelhiMarketModel model;

  const DelhiMarketCard({
    required this.model,
  });

  @override
  State<DelhiMarketCard> createState() => _DelhiMarketCardState();
}

class _DelhiMarketCardState extends State<DelhiMarketCard> {
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
                    widget.model.marketCloseTime,
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
                    "${widget.model.delhiNumber}",
                    style: const TextStyle(fontSize: 25.0,color: Colors.green),
                  ),
                  widget.model.message.compareTo("Market Closed!") == 0
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
                  if (!(widget.model.message.compareTo("Market Closed!") ==
                      0)) {
                    Get.to(() => GameViewPage(
                          model: widget.model,
                        ));
                  } else {
                    CustomAlert.error(
                        "Market Closed", "The market is already closed.");
                  }
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

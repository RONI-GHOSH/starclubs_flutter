import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:matka_web/alerts.dart';
import 'package:matka_web/app_colors.dart';
import 'package:matka_web/presentation/pages/chart_page.dart';
import 'package:matka_web/presentation/pages/game_view_page/screens/game_view_page.dart';

import '../../models/delhi_market_model.dart';
import '../pages/home_page/screens/home_page.dart';

class MarketCard extends StatefulWidget {
  final DelhiMarketModel model;

  const MarketCard({
    required this.model,
  });

  @override
  State<MarketCard> createState() => _MarketCardState();
}

class _MarketCardState extends State<MarketCard> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Card(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.orange, width: 2.0),
        ),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.marketName,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "**",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                     "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Divider(),
                  ],
                ),
                Spacer(),
                 IconButton(
                  icon: Image.asset("assets/chart_icon.png",width: 45,),
                  onPressed: () { Get.to(()=>ChartPage(mId: widget.model.marketId));
                  },
                ),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: Icon(Icons.play_arrow, color: Colors.white),
                    onPressed: () {
                      if(!(widget.model.message.compareTo("Next Day Bet Running!") == 0)){
                        Get.to(()=>GameViewPage(model: widget.model,));
                      } else{
                        CustomAlert.error("Market Closed", "The market is already closed.");
                      }
                    },
                  ),
                ),

              ]),
              SizedBox(height: 3.0),
              Divider(thickness: 2,),
              SizedBox(height: 3.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.model.message.compareTo("Next Day Bet Running!") == 0 ?
                  Text(
                     "Market Closed!",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ) :  Text(
                    "Bet Run Today!",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ) ,
                  Spacer(),
                  Text(
                    'CLOSE BET: ${widget.model.marketCloseTime}',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


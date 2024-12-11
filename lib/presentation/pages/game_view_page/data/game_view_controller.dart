import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:matka_web/presentation/pages/game_view_page/data/bet_controller.dart';

import '../../../../models/lottry_model.dart';
import '../../../../models/tab_games_model.dart';

class GameViewController{
  static Rx<TabGamesModel> tabGames = TabGamesModel(marketId: '', marketName: '', list: [], status: '').obs;
  static RxString crossingDate = "".obs;

  static updateDate(){
    crossingDate.value = '';
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMMM d yyyy').format(now);
    crossingDate.value = formattedDate; // Output: Friday, August 16 2024
  }

  static RxList<dynamic> lotteries = [].obs;

  static updateLotteries(String first, String second, String amount) {
    Set<String> hashSet = <String>{};

    // Add single-digit numbers from `first` after normalizing (remove leading zeros)
    // for (int i = 0; i < first.length; i++) {
    //   String bet = first[i] == "0" ? "0" :first[i].replaceAll(RegExp(r'^0+'), ''); // Remove leading zeros
    //   hashSet.add(bet);
    // }

    // Generate two-digit combinations from `first` and `second` after normalizing
    for (int i = 0; i < first.length; i++) {
      for (int j = 0; j < second.length; j++) {
        String bet = '${first[i]}${second[j]}'; // Remove leading zeros
        hashSet.add(bet);
      }
    }

    print(hashSet);

    // Convert the HashSet to a list of LotteryModel instances
    lotteries.value = hashSet.map((e) {
      // print(e);
      return LotteryModel(
        lotteryNumber: e,
        lotteryAmount: int.parse(amount), // Ensure lotteryAmount is not missing
      );
    }).toList();

    // Update total amount
    BetController.totalAmount.value = lotteries.length * int.parse(amount);

    // Sort the list by lottery number
    lotteries.sort((a, b) => int.parse(a.lotteryNumber).compareTo(int.parse(b.lotteryNumber)));

    print(lotteries);
  }

}

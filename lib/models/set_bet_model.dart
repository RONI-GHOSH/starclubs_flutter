import 'lottry_model.dart';

class SetBetModel {
  final List<LotteryModel> lotteries;
  final String memberId;
  final String marketId;
  final String gameId;
  final String status;
  final String marketName;
  final String gameName;
  final String totalAmount;

  SetBetModel({
    required this.lotteries,
    required this.memberId,
    required this.marketId,
    required this.gameId,
    required this.status,
    required this.marketName,
    required this.gameName,
    required this.totalAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'Lottries': lotteries.map((lottery) => lottery.toJson()).toList(),
      'Memberid': memberId,
      'MarketId': marketId,
      'GameId': gameId,
      'status': status, // Should use the provided status instead of hardcoding "Active"
      'MarketName': marketName,
      'GameName': gameName,
      'totalLotteriesAmount': totalAmount,
    };
  }
}
class ColorBetMarketModel {
  final String marketId;
  final String marketTime;
  final String marketDate;
  final String marketName;
  final String winningNumberLotteryNumber;
  final String winningNumberColor;
  final String colorCode;
  final String colorName;
  final String activeStatus;

  ColorBetMarketModel({
    required this.marketId,
    required this.marketTime,
    required this.marketDate,
    required this.marketName,
    required this.winningNumberLotteryNumber,
    required this.winningNumberColor,
    required this.colorCode,
    required this.colorName,
    required this.activeStatus,
  });

  // Factory constructor to create an instance from a JSON map
  factory ColorBetMarketModel.fromJson(Map<String, dynamic> json) {
    return ColorBetMarketModel(
      marketId: json['market_id'] as String,
      marketTime: json['market_time'] as String,
      marketDate: json['market_date'] as String,
      marketName: json['market_name'] as String,
      winningNumberLotteryNumber: json['winningNumberLottery_number'] as String,
      winningNumberColor: json['winningNumberColor'] as String,
      colorCode: json['color_code'] as String,
      colorName: json['color_name'] as String,
      activeStatus: json['active_status'] as String,
    );
  }

  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'market_time': marketTime,
      'market_date': marketDate,
      'market_name': marketName,
      'winningNumberLottery_number': winningNumberLotteryNumber,
      'winningNumberColor': winningNumberColor,
      'color_code': colorCode,
      'color_name': colorName,
      'active_status': activeStatus,
    };
  }
}

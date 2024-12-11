class StarLineMarketModel {
  final String marketId;
  final String marketTime;
  final String marketDate;
  final String marketName;
  final String winningNumberStarLine;
  final String activeStatus;

  StarLineMarketModel({
    required this.marketId,
    required this.marketTime,
    required this.marketDate,
    required this.marketName,
    required this.winningNumberStarLine,
    required this.activeStatus,
  });

  // Factory constructor to create an instance from a JSON map
  factory StarLineMarketModel.fromJson(Map<String, dynamic> json) {
    return StarLineMarketModel(
      marketId: json['market_id'] as String,
      marketTime: json['market_time'] as String,
      marketDate: json['market_date'] as String,
      marketName: json['market_name'] as String,
      winningNumberStarLine: json['winningNumberStarLine'] as String,
      activeStatus: json['active_status'] as String,
    );
  }

  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'market_time': marketTime,
      'market_date': marketDate,
      'market_name': marketName,
      'winningNumberStarLine': winningNumberStarLine,
      'active_status': activeStatus,
    };
  }
}

class DelhiMarketModel {
  final String marketId;
  final String marketName;
  final String marketCloseTime;
  final String marketActiveStatus;
  final String message;
  final String marketTodayOpenNumber;
  final String delhiNumber;

  DelhiMarketModel({
    required this.marketId,
    required this.marketName,
    required this.marketCloseTime,
    required this.marketActiveStatus,
    required this.message,
    required this.marketTodayOpenNumber,
    required this.delhiNumber,
  });

  // Factory method to create a DelhiMarketModel from a JSON map
  factory DelhiMarketModel.fromJson(Map<String, dynamic> json) {
    return DelhiMarketModel(
      marketId: json['marketId'],
      marketName: json['marketName'],
      marketCloseTime: json['marketCloseTime'],
      marketActiveStatus: json['marketActiveStatus'],
      message: json['message'],
      marketTodayOpenNumber: json['marketTodayOpenNumber'],
      delhiNumber: json['delhiNumber'],
    );
  }

  // Method to convert a DelhiMarketModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'marketId': marketId,
      'marketName': marketName,
      'marketCloseTime': marketCloseTime,
      'marketActiveStatus': marketActiveStatus,
      'message': message,
      'marketTodayOpenNumber': marketTodayOpenNumber,
      'delhiNumber': delhiNumber,
    };
  }
}

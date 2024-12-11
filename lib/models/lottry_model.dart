class LotteryModel{
  final String lotteryNumber;
  final int lotteryAmount;

  LotteryModel({
    required this.lotteryAmount,
    required this.lotteryNumber,

});

  Map<String,dynamic> toJson(){
    return {
      "LottryNumber": lotteryNumber,
      "Lottryamount": lotteryAmount
    };
  }
  @override
  String toString() {
    return 'LotteryModel(lotteryNumber: $lotteryNumber, lotteryAmount: $lotteryAmount)';
  }

}


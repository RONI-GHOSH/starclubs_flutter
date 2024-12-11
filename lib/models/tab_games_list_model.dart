class TabGamesListModel{
  final String marketGameId;
  final String gameName;

  TabGamesListModel({
    required this.gameName,
    required this.marketGameId,
});
  factory TabGamesListModel.fromJson(Map<String,dynamic> json){
    return TabGamesListModel(gameName: json['game_name'], marketGameId: json['market_game_id']);
  }
}
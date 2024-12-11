import 'package:matka_web/models/tab_games_list_model.dart';

class TabGamesModel{
  final String status;
  final String marketId;
  final String marketName;
  final List<TabGamesListModel> list;

  TabGamesModel({
    required this.marketId,
    required this.marketName,
    required this.list,
    required this.status
});

  factory TabGamesModel.fromJson(Map<String,dynamic> json){
    final response = json['tab_game_list'] as List;
    List<TabGamesListModel> gamesList = response.map((e) => TabGamesListModel.fromJson(e)).toList();
    print(gamesList.toList());
    return TabGamesModel(marketId: json['market_id'], marketName: json['market_name'], list: gamesList, status: json['status']);
  }
}
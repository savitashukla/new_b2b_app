import 'package:gmng/model/HomeModel/Game.dart';

class GameCategories {
  String id;
  String name;
  int order;
  List<Games> games;

  GameCategories({this.id, this.name, this.order, this.games});

  GameCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    order = json['order'];
    if (json['games'] != null) {
      games = new List<Games>();
      json['games'].forEach((v) {
        games.add(new Games.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['order'] = this.order;
    if (this.games != null) {
      data['games'] = this.games.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

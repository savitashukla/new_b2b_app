class FavoriteGameModel {
  List<Data> data;

  FavoriteGameModel({this.data});

  FavoriteGameModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String userId;
  GameId gameId;
  String suggestion;

  Data({this.id, this.userId, this.gameId, this.suggestion});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    gameId =
    json['gameId'] != null ? new GameId.fromJson(json['gameId']) : null;

    suggestion = json['suggestion']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    if (this.gameId != null) {
      data['gameId'] = this.gameId.toJson();
    }
    data['suggestion'] = this.suggestion;
    return data;
  }
}

class GameId {
  String id;
  String name;
  Banner banner;
  String gameCategoryId;
  bool isClickable;
  String howToPlayUrl;
  bool isUnity;
  String status;

  GameId(
      {this.id,
        this.name,
        this.banner,
        this.gameCategoryId,
        this.isClickable,
        this.howToPlayUrl,
        this.isUnity,
        this.status});

  GameId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    banner =
    json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    gameCategoryId = json['gameCategoryId'];
    isClickable = json['isClickable'];
    howToPlayUrl = json['howToPlayUrl'];
    isUnity = json['isUnity'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    data['gameCategoryId'] = this.gameCategoryId;
    data['isClickable'] = this.isClickable;
    data['howToPlayUrl'] = this.howToPlayUrl;
    data['isUnity'] = this.isUnity;
    data['status'] = this.status;
    return data;
  }
}

class Banner {
  String id;
  String url;

  Banner({this.id, this.url});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}
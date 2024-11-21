import 'package:gmng/res/AppString.dart';

import '../../webservices/ApiUrl.dart';

class HomePageListModel {
  List<TrendingEvents> trendingEvents;
  List<GameCategories> gameCategories;
  List<BannersDashBoard> banners;
  List<BannersDashBoard> bannersZero;
  List<Games> gamesMyFav;

  HomePageListModel({this.trendingEvents, this.gameCategories, this.banners});

  HomePageListModel.fromJson(Map<String, dynamic> json) {
    if (json['trendingEvents'] != null) {
      trendingEvents = new List<TrendingEvents>();
      json['trendingEvents'].forEach((v) {
        trendingEvents.add(new TrendingEvents.fromJson(v));
      });
    }
    if (json['gameCategories'] != null) {
      gameCategories = new List<GameCategories>();
      json['gameCategories'].forEach((v) {
        if (v['games'] != null && v['games'].length > 0) {
          if (ApiUrl().isbb) {
            if (v['name'].compareTo('GMNG Originals') == 0) {
            } else {
              gameCategories.add(new GameCategories.fromJson(v));
            }
          } else {
            gameCategories.add(new GameCategories.fromJson(v));
          }
        }
      });
    }

    // gameCategories.sort((a, b) => b.order.compareTo(a.order));

    if (json['banners'] != null) {
      banners = new List<BannersDashBoard>();
      json['banners'].forEach((v) {
        if (v["isPopUp"]) {
        } else {
          banners.add(new BannersDashBoard.fromJson(v));
        }
      });
    }
    /* if (json['banners'] != null) {
      banners = new List<BannersDashBoard>();
      json['banners'].forEach((v) {



        banners.add(new BannersDashBoard.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trendingEvents != null) {
      data['trendingEvents'] =
          this.trendingEvents.map((v) => v.toJson()).toList();
    }
    if (this.gameCategories != null) {
      data['gameCategories'] =
          this.gameCategories.map((v) => v.toJson()).toList();
    }
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrendingEvents {
  String id;
  Entry entry;
  Winner winner;
  JoiningDate joiningDate;
  EventDate eventDate;
  Banner banner;
  String name;
  String description;
  String type;
  int totalTeams;
  int maxPlayers;
  String displayDate;
  List<RankAmount> rankAmount;
  List<Rounds> rounds;
  bool isTrendingEvent;

  ClanId clanId;
  TeamTypeId teamTypeId;
  TeamTypeId gameId;
  TeamTypeId gameModeId;
  TeamTypeId gamePerspectiveId;
  TeamTypeId gameMapId;

  TrendingEvents(
      {this.id,
      this.entry,
      this.winner,
      this.joiningDate,
      this.eventDate,
      this.banner,
      this.name,
      this.description,
      this.type,
      this.totalTeams,
      this.maxPlayers,
      this.displayDate,
      this.rankAmount,
      this.rounds,
      this.isTrendingEvent,
      this.clanId,
      this.teamTypeId,
      this.gameId,
      this.gameModeId,
      this.gamePerspectiveId,
      this.gameMapId});

  TrendingEvents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entry = json['entry'] != null ? new Entry.fromJson(json['entry']) : null;
    winner =
        json['winner'] != null ? new Winner.fromJson(json['winner']) : null;
    joiningDate = json['joiningDate'] != null
        ? new JoiningDate.fromJson(json['joiningDate'])
        : null;
    eventDate = json['eventDate'] != null
        ? new EventDate.fromJson(json['eventDate'])
        : null;
    banner =
        json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    name = json['name'];
    description = json['description'];
    type = json['type'];
    totalTeams = json['totalTeams'];
    maxPlayers = json['maxPlayers'];
    displayDate = json['displayDate'];
    if (json['rankAmount'] != null) {
      rankAmount = new List<RankAmount>();
      json['rankAmount'].forEach((v) {
        rankAmount.add(new RankAmount.fromJson(v));
      });
    }
    if (json['rounds'] != null) {
      rounds = new List<Rounds>();
      json['rounds'].forEach((v) {
        rounds.add(new Rounds.fromJson(v));
      });
    }
    isTrendingEvent = json['isTrendingEvent'];
    clanId =
        json['clanId'] != null ? new ClanId.fromJson(json['clanId']) : null;
    teamTypeId = json['teamTypeId'] != null
        ? new TeamTypeId.fromJson(json['teamTypeId'])
        : null;
    gameId =
        json['gameId'] != null ? new TeamTypeId.fromJson(json['gameId']) : null;
    gameModeId = json['gameModeId'] != null
        ? new TeamTypeId.fromJson(json['gameModeId'])
        : null;
    gamePerspectiveId = json['gamePerspectiveId'] != null
        ? new TeamTypeId.fromJson(json['gamePerspectiveId'])
        : null;
    gameMapId = json['gameMapId'] != null
        ? new TeamTypeId.fromJson(json['gameMapId'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.entry != null) {
      data['entry'] = this.entry.toJson();
    }
    if (this.winner != null) {
      data['winner'] = this.winner.toJson();
    }
    if (this.joiningDate != null) {
      data['joiningDate'] = this.joiningDate.toJson();
    }
    if (this.eventDate != null) {
      data['eventDate'] = this.eventDate.toJson();
    }
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type;
    data['totalTeams'] = this.totalTeams;
    data['maxPlayers'] = this.maxPlayers;
    data['displayDate'] = this.displayDate;
    if (this.rankAmount != null) {
      data['rankAmount'] = this.rankAmount.map((v) => v.toJson()).toList();
    }
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    data['isTrendingEvent'] = this.isTrendingEvent;
    /*if (this.rules != null) {
     // data['rules'] = this.rules.map((v) => v.toJson()).toList();
    }*/
    /* if (this.rankPoints != null) {
      data['rankPoints'] = this.rankPoints.map((v) => v.toJson()).toList();
    }*/
    data['clanId'] = this.clanId;
    if (this.teamTypeId != null) {
      data['teamTypeId'] = this.teamTypeId.toJson();
    }
    if (this.gameId != null) {
      data['gameId'] = this.gameId.toJson();
    }
    if (this.clanId != null) {
      data['clanId'] = this.clanId.toJson();
    }
    if (this.gameModeId != null) {
      data['gameModeId'] = this.gameModeId.toJson();
    }
    if (this.gamePerspectiveId != null) {
      data['gamePerspectiveId'] = this.gamePerspectiveId.toJson();
    }
    if (this.gameMapId != null) {
      data['gameMapId'] = this.gameMapId.toJson();
    }
    return data;
  }
}

class Entry {
  Fee fee;
  int feeBonusPercentage;

  Entry({this.fee, this.feeBonusPercentage});

  Entry.fromJson(Map<String, dynamic> json) {
    fee = json['fee'] != null ? new Fee.fromJson(json['fee']) : null;
    feeBonusPercentage = json['feeBonusPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fee != null) {
      data['fee'] = this.fee.toJson();
    }
    data['feeBonusPercentage'] = this.feeBonusPercentage;
    return data;
  }
}

class Fee {
  int value;
  String type;

  Fee({this.value, this.type});

  Fee.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}

class Winner {
  Fee prizeAmount;
  String type;

  Winner({this.prizeAmount, this.type});

  Winner.fromJson(Map<String, dynamic> json) {
    prizeAmount = json['prizeAmount'] != null
        ? new Fee.fromJson(json['prizeAmount'])
        : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.prizeAmount != null) {
      data['prizeAmount'] = this.prizeAmount.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class JoiningDate {
  String start;
  String end;

  JoiningDate({this.start, this.end});

  JoiningDate.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}

class EventDate {
  String start;

  EventDate({this.start});

  EventDate.fromJson(Map<String, dynamic> json) {
    start = json['start'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
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

class RankAmount {
  String id;
  Fee amount;
  int serialNumber;
  int rankFrom;

  RankAmount({this.id, this.amount, this.serialNumber, this.rankFrom});

  RankAmount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'] != null ? new Fee.fromJson(json['amount']) : null;
    serialNumber = json['serialNumber'];
    rankFrom = json['rankFrom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.amount != null) {
      data['amount'] = this.amount.toJson();
    }
    data['serialNumber'] = this.serialNumber;
    data['rankFrom'] = this.rankFrom;
    return data;
  }
}

class Rounds {
  String id;
  int serialNumber;
  String name;
  String status;
  bool isResultDeclared;
  bool isFinalRound;

  Rounds(
      {this.id,
      this.serialNumber,
      this.name,
      this.status,
      this.isResultDeclared,
      this.isFinalRound});

  Rounds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serialNumber = json['serialNumber'];
    name = json['name'];
    status = json['status'];
    isResultDeclared = json['isResultDeclared'];
    isFinalRound = json['isFinalRound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serialNumber'] = this.serialNumber;
    data['name'] = this.name;
    data['status'] = this.status;
    data['isResultDeclared'] = this.isResultDeclared;
    data['isFinalRound'] = this.isFinalRound;
    return data;
  }
}

class TeamTypeId {
  String id;
  String name;

  TeamTypeId({this.id, this.name});

  TeamTypeId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class GameCategories {
  String id;
  String name;
  int order;
  bool isRMG;
  List<Games> games;

  GameCategories({this.id, this.name, this.order, this.games, this.isRMG});

  GameCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    order = json['order'];
    isRMG = json['isRMG'];
    if (json['games'] != null) {
      games = new List<Games>();
      json['games'].forEach((v) {
        if (ApiUrl().isbb) {
          if (v['thirdParty'] != null) {
            if (v['name'].compareTo('FANTASY') == 0) {
              games.add(new Games.fromJson(v));
            } else {}
          } else {
            games.add(new Games.fromJson(v));
          }
        } else {
          games.add(new Games.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['order'] = this.order;
    data['isRMG'] = this.isRMG;
    if (this.games != null) {
      data['games'] = this.games.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Games {
  String id;
  Banner banner;
  ThirdParty thirdParty;
  bool isUnity;
  String name;
  int order;
  bool isRMG = true;
  bool isClickable;
  String howToPlayUrl;
  bool isSelect;

  Games(
      {this.id,
      this.banner,
      this.thirdParty,
      this.isUnity,
      this.name,
      this.order,
      this.isClickable,
      this.howToPlayUrl,
      this.isSelect});

  Games.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    banner =
        json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    thirdParty = json['thirdParty'] != null
        ? new ThirdParty.fromJson(json['thirdParty'])
        : null;
    isUnity = json['isUnity'];
    name = json['name'];
    order = json['order'];
    isClickable = json['isClickable'];
    howToPlayUrl = json['howToPlayUrl'];

    if (this.id.compareTo("62e7d76654628211b0e49d25") == 0) {
      if (this.isClickable) {
      } else {
        AppString.rummyisClickable = false;
      }
    }
    isSelect = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    if (this.thirdParty != null) {
      data['thirdParty'] = this.thirdParty.toJson();
    }
    data['isUnity'] = this.isUnity;
    data['name'] = this.name;
    data['order'] = this.order;
    data['isClickable'] = this.isClickable;
    data['howToPlayUrl'] = this.howToPlayUrl;
    return data;
  }
}

class ThirdParty {
  String name;
  String url;

  ThirdParty({this.name, this.url});

  ThirdParty.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class BannersDashBoard {
  String id;
  Banner image;
  String category;
  String type;
  String name;
  String externalUrl;
  String gameId;
  String eventId;
  String screen;

  BannersDashBoard(
      {this.id,
      this.image,
      this.category,
      this.type,
      this.name,
      this.externalUrl,
      this.gameId,
      this.screen,
      this.eventId});

  BannersDashBoard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'] != null ? new Banner.fromJson(json['image']) : null;
    category = json['category'];
    type = json['type'];
    name = json['name'];
    externalUrl = json['externalUrl'];
    gameId = json[
        'gameId']; //json['gameId'] != null ? new BannerGame.fromJson(json['gameId']) : null;
    eventId = json['eventId'];
    screen = json['screen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    data['category'] = this.category;
    data['type'] = this.type;
    data['name'] = this.name;
    data['externalUrl'] = this.externalUrl;
    data['gameId'] = this.gameId;
    /*if (this.gameId != null) {
      data['gameId'] = this.gameId.toJson();
    }*/
    data['eventId'] = this.eventId;
    data['screen'] = this.screen;
    return data;
  }
}

class ClanId {
  String id;
  String name;

  ClanId({this.id, this.name});

  ClanId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

//game id object in for banners
class BannerGame {
  String id;
  String name;

  BannerGame({this.id, this.name});

  BannerGame.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

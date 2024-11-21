import 'package:gmng/model/HomeModel/HomePageListModel.dart';

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
  List<Null> rules;
  List<Null> rankPoints;
  Null clanId;
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
        this.rules,
        this.rankPoints,
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
    banner = json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
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
    if (json['rules'] != null) {
      rules = new List<Null>();
      json['rules'].forEach((v) {
       /// rules.add(new Null.fromJson(v));
      });
    }
    if (json['rankPoints'] != null) {
      rankPoints = new List<Null>();
      json['rankPoints'].forEach((v) {
       // rankPoints.add(new Null.fromJson(v));
      });
    }
    clanId = json['clanId'];
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
    if (this.rules != null) {
     // data['rules'] = this.rules.map((v) => v.toJson()).toList();
    }
    if (this.rankPoints != null) {
    //  data['rankPoints'] = this.rankPoints.map((v) => v.toJson()).toList();
    }
    data['clanId'] = this.clanId;
    if (this.teamTypeId != null) {
      data['teamTypeId'] = this.teamTypeId.toJson();
    }
    if (this.gameId != null) {
      data['gameId'] = this.gameId.toJson();
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
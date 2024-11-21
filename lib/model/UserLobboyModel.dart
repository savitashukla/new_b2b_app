import 'package:intl/intl.dart';

import 'PrizeAmount.dart';
import 'basemodel/AppBaseModel.dart';

class UserRegistrations {
  String id;
  List<Rounds> rounds;
  String eventId;
  String userId;
  bool isWinner;
  bool winningCredited;
  String teamId;
  String status;
  PrizeAmount prizeAmount;

  UserRegistrations(
      {this.id,
      this.rounds,
      this.eventId,
      this.userId,
      this.isWinner,
      this.winningCredited,
      this.teamId,
      this.status,
      this.prizeAmount});

  UserRegistrations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['rounds'] != null) {
      rounds = new List<Rounds>();
      json['rounds'].forEach((v) {
        rounds.add(new Rounds.fromJson(v));
      });
    }
    eventId = json['eventId'];
    userId = json['userId'];
    isWinner = json['isWinner'];
    winningCredited = json['winningCredited'];
    teamId = json['teamId'];
    status = json['status'];
    prizeAmount = json['prizeAmount'] != null
        ? new PrizeAmount.fromJson(json['prizeAmount'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    data['eventId'] = this.eventId;
    data['userId'] = this.userId;
    data['isWinner'] = this.isWinner;
    data['winningCredited'] = this.winningCredited;
    data['teamId'] = this.teamId;
    data['status'] = this.status;
    if (this.prizeAmount != null) {
      data['prizeAmount'] = this.prizeAmount.toJson();
    }
    return data;
  }
}

class Rounds {
  String id;
  String roundId;
  LobbyId lobbyId;
  var slot;
  bool isWinner;
  var gmngRank;
  var gmngTeamRank;
  var result;

  Rounds(
      {this.id,
      this.roundId,
      this.lobbyId,
      this.slot,
      this.isWinner,
      this.gmngRank,
      this.gmngTeamRank,
      this.result});

  Rounds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roundId = json['roundId'];
    lobbyId =
        json['lobbyId'] != null ? new LobbyId.fromJson(json['lobbyId']) : null;
    slot = json['slot'];
    isWinner = json['isWinner'];
    gmngRank = json['gmngRank'];
    gmngTeamRank = json['gmngTeamRank'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roundId'] = this.roundId;
    if (this.lobbyId != null) {
      data['lobbyId'] = this.lobbyId.toJson();
    }
    data['slot'] = this.slot;
    data['isWinner'] = this.isWinner;
    data['gmngRank'] = this.gmngRank;
    data['gmngTeamRank'] = this.gmngTeamRank;
    data['result'] = this.result;
    return data;
  }
}

class LobbyId extends AppBaseModel {
  String id;
  String eventId;
  String roundId;
  int serialNumber;
  int totalWinners;
  int totalTeams;
  String roomId;
  String roomPassword;
  String completedStatus;
  String status;
  String createdAt;
  String updatedAt;
  String startDate;
  GameMapId gameMapId;

  String getStartTimeHHMMSS() {
    return DateFormat("hh:mm aa").format(DateFormat("yyyy-MM-ddTHH:mm:ssZ")
        .parse(this.startDate, true)
        .toLocal());
  }

  String getRoomid() {
    return getValidString(this.roomId);
  }

  String getRoomPassword() {
    return getValidString(this.roomPassword);
  }

  LobbyId(
      {this.id,
      this.eventId,
      this.roundId,
      this.serialNumber,
      this.totalWinners,
      this.totalTeams,
      this.gameMapId,
      this.roomId,
      this.roomPassword,
      this.completedStatus,
      this.status,
      this.startDate,
      this.createdAt,
      this.updatedAt});

  LobbyId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['eventId'];
    roundId = json['roundId'];
    serialNumber = json['serialNumber'];
    totalWinners = json['totalWinners'];
    totalTeams = json['totalTeams'];
    gameMapId = (json['gameMapId']  is String)?null:json['gameMapId'] != null ? new GameMapId.fromJson(json['gameMapId']) : null ;
    roomId = json['roomId'];
    roomPassword = json['roomPassword'];
    completedStatus = json['completedStatus'];
    status = json['status'];
    startDate = json['startDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eventId'] = this.eventId;
    data['roundId'] = this.roundId;
    data['serialNumber'] = this.serialNumber;
    data['totalWinners'] = this.totalWinners;
    data['totalTeams'] = this.totalTeams;
    if (this.gameMapId != null) {
      data['gameMapId'] = this.gameMapId.toJson();
    }
    data['roomId'] = this.roomId;
    data['roomPassword'] = this.roomPassword;
    data['completedStatus'] = this.completedStatus;
    data['status'] = this.status;
    data['startDate'] = this.startDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class GameMapId {
  String _id;
  String name;

  GameMapId.fromJson(Map<String, dynamic> json) {
    _id = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this.name;
    return data;
  }
}

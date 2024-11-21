import 'package:gmng/model/basemodel/AppBaseModel.dart';
import 'package:gmng/utills/Utils.dart';
import 'package:intl/intl.dart';

import 'UserLobboyModel.dart';

class ESportEventListModel {
  List<ContestModel> data;
  List<ContestModel> champaiship;
  List<ContestModel> affiliate;
  List<UserRegistrations> userRegistrations;
  Meta meta;

  ESportEventListModel({this.data, this.meta});

  ESportEventListModel.fromJson(
      Map<String, dynamic> json, String event_id, bool needfliter, bool unity) {
    if (json['data'] != null) {
      champaiship = new List<ContestModel>();
      data = new List<ContestModel>();
      affiliate = new List<ContestModel>();
      json['data'].forEach((event) {
        if (needfliter) {
          if (event['affiliate'] != null) {
            if (event_id.isNotEmpty) {
              if (event['id'] == event_id) {
                affiliate.add(new ContestModel.fromJson(event));
              }
            } else {
              affiliate.add(new ContestModel.fromJson(event));
            }
          }
          /*else if (
              event['type'].compareTo("championship") == 0) {
            if (event['affiliate'] != null) {
              affiliate.add(new ContestModel.fromJson(event));
            }
          }*/
          else {
            if (event['type'].compareTo("championship") == 0) {
              if (event_id.isNotEmpty) {
                if (event['id'] == event_id) {
                  champaiship.add(new ContestModel.fromJson(event));
                }
              } else {
                champaiship.add(new ContestModel.fromJson(event));
              }
            } else {
              if (event_id.isNotEmpty) {
                if (event['id'] == event_id) {
                  data.add(new ContestModel.fromJson(event));
                }
              } else {
                data.add(new ContestModel.fromJson(event));
              }
            }
          }
        } else {
          /* if (event_id.isNotEmpty) {
            if (event['id'] == event_id) {*/
          data.add(new ContestModel.fromJson(event));
          // }
          /*} else {
            data.add(new ContestModel.fromJson(event));
          }*/
        }
      });

      data.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      affiliate.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      champaiship.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }

    if (json['userRegistrations'] != null) {
      userRegistrations = new List<UserRegistrations>();
      json['userRegistrations'].forEach((v) {
        userRegistrations.add(new UserRegistrations.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
      data['champaiship'] = this.champaiship.map((v) => v.toJson()).toList();
    }
    if (this.userRegistrations != null) {
      data['userRegistrations'] =
          this.userRegistrations.map((v) => v.toJson()).toList();
    }
    data['meta'] = this.meta;
    return data;
  }
}

class Meta {
  String serverTime;

  Meta({this.serverTime});

  Meta.fromJson(Map<String, dynamic> json) {
    serverTime = json['serverTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serverTime'] = this.serverTime;
    return data;
  }
}

class ContestModel extends AppBaseModel {
  String id;
  Entry entry;
  Winner winner;
  JoiningDate joiningDate;
  EventDate eventDate;
  Banner banner;
  bool isTrendingEvent;
  String name;
  String description;
  String type;
  int totalTeams;
  int maxPlayers;
  String displayDate;
  List<Rounds> rounds;
  String status;
  String affiliateUrl;
  String createdBy;
  String updatedBy;
  String rules;
  List<Null> rankPoints;
  List<RankAmount> rankAmount;
  String createdAt;
  String updatedAt;
  GameId gameId;
  GameId gameModeId;
  JoinSummary joinSummary;
  GameId gamePerspectiveId;
  TeamType teamTypeId;
  GameId gameMapId;
  Affiliate affiliate;
  String clanUrl;
  String streamUrl;
  String password;
  bool lootBoxEvent;

  String getUserRoundRoomId(List<UserRegistrations> data) {
    String roomid = "";
    Rounds selected_round;
    if (this.rounds != null && this.rounds.length > 0) {
      for (var i = 0; i < this.rounds.length; i++) {
        if (!this.rounds[i].isResultDeclared) {
          selected_round = this.rounds[i];
          break;
        }
      }
    }
    // print ("selected_round==> ${selected_round.id}");
    if (selected_round != null && data != null && data.length > 0) {
      for (var i = 0; i < data.length; i++) {
        for (var j = 0; j < data[i].rounds.length; j++) {
          if (selected_round.id == data[i].rounds[j].roundId) {
            if (data[i].rounds[j].lobbyId != null) {
              roomid = data[i].rounds[j].lobbyId.roomId;
            }

            break;
          }
        }
      }
    }

    print(" room id get ${getValidString(roomid)}");
    return getValidString(roomid);
  }

  String getRoomName(List<UserRegistrations> data) {
    String roomid = "";
    Rounds selected_round;
    if (this.rounds != null && this.rounds.length > 0) {
      for (var i = 0; i < this.rounds.length; i++) {
        if (!this.rounds[i].isResultDeclared) {
          selected_round = this.rounds[i];
          break;
        }
      }
    }
    if (selected_round != null && data != null && data.length > 0) {
      for (var i = 0; i < data.length; i++) {
        for (var j = 0; j < data[i].rounds.length; j++) {
          if (selected_round.id == data[i].rounds[j].roundId) {
            if (data[i].rounds[j].lobbyId != null) {
              roomid = data[i].rounds[j].lobbyId.roomPassword;
            }
            break;
          }
        }
      }
    }
    return getValidString(roomid);
  }

  String getUserWinningAmount(List<UserRegistrations> data, String eventid) {
    String winning_amount = "0.0";
    for (var i = 0; i < data.length; i++) {
      if (data[i].eventId == eventid && data[i].prizeAmount != null) {
        winning_amount = (data[i].prizeAmount.value ~/ 100).toString();
        break;
      }
    }
    return winning_amount;
  }

  bool isCompletedJoined(String eventid, List<UserRegistrations> data) {
    Utils().customPrint("eventid===>${eventid}");
    bool is_joined = false;
    for (int i = 0; i < data.length; i++) {
      if (data[i].eventId == eventid) {
        Utils().customPrint("eventid===>found==>${data[i].status}");
        if (data[i].status == 'active') {
          is_joined = true;
        }
        break;
      }
    }
    return is_joined;
  }

  String getPassword() {
    return getValidString(this.password);
  }

  String getClanLink() {
    return getValidString(this.clanUrl);
  }

  String getStreamUrl() {
    return getValidString(this.streamUrl);
  }

  String getTotalWinner() {
    String number_winner = "0";
    if (this.rankAmount != null && this.rankAmount.length > 0) {
      if (this.rankAmount[this.rankAmount.length - 1].rankTo != null) {
        number_winner =
            this.rankAmount[this.rankAmount.length - 1].rankTo.toString();
      } else {
        number_winner =
            this.rankAmount[this.rankAmount.length - 1].rankFrom.toString();
      }
      // print("number_winner==>" + number_winner);
    }
    return number_winner;
  }

  ContestModel(
      {this.id,
      this.entry,
      this.winner,
      this.joiningDate,
      this.eventDate,
      this.banner,
      this.isTrendingEvent,
      this.name,
      this.description,
      this.type,
      this.totalTeams,
      this.maxPlayers,
      this.displayDate,
      this.rounds,
      this.status,
      this.affiliateUrl,
      this.createdBy,
      this.updatedBy,
      this.rules,
      this.rankPoints,
      this.rankAmount,
      this.createdAt,
      this.updatedAt,
      this.gameId,
      this.joinSummary,
      this.gameModeId,
      this.gamePerspectiveId,
      this.teamTypeId,
      this.gameMapId,
      this.affiliate,
      this.clanUrl,
      this.streamUrl,
      this.password});

  ContestModel.fromJson(Map<String, dynamic> json) {
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
    isTrendingEvent = json['isTrendingEvent'];
    name = json['name'];
    description = json['description'];
    type = json['type'];
    totalTeams = json['totalTeams'];
    maxPlayers = json['maxPlayers'];
    displayDate = json['displayDate'];
    if (json['rounds'] != null) {
      rounds = new List<Rounds>();
      json['rounds'].forEach((v) {
        rounds.add(new Rounds.fromJson(v));
      });
    }
    status = json['status'];
    affiliateUrl = json['affiliateUrl'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    streamUrl = json['streamUrl'];
    clanUrl = json['clanUrl'];
    rules = json['rules'];
    password = json['password'];
    if (json['rankPoints'] != null) {
      rankPoints = new List<Null>();
      json['rankPoints'].forEach((v) {
        //rankPoints.add(new Null.fromJson(v));
      });
    }
    if (json['rankAmount'] != null) {
      rankAmount = new List<RankAmount>();
      json['rankAmount'].forEach((v) {
        rankAmount.add(new RankAmount.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    gameId =
        json['gameId'] != null ? new GameId.fromJson(json['gameId']) : null;
    this.joinSummary = json['joinSummary'] != null
        ? new JoinSummary.fromJson(json['joinSummary'])
        : null;
    gameModeId = json['gameModeId'] != null
        ? new GameId.fromJson(json['gameModeId'])
        : null;
    gamePerspectiveId = json['gamePerspectiveId'] != null
        ? new GameId.fromJson(json['gamePerspectiveId'])
        : null;
    teamTypeId = json['teamTypeId'] != null
        ? new TeamType.fromJson(json['teamTypeId'])
        : null;
    gameMapId = json['gameMapId'] != null
        ? new GameId.fromJson(json['gameMapId'])
        : null;

    affiliate = json['affiliate'] != null
        ? new Affiliate.fromJson(json['affiliate'])
        : null;
    lootBoxEvent = json['lootBoxEvent'] != null ? json['lootBoxEvent'] : false;
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
      data['eventDatetime'] = DateFormat("hh:mm aa").format(
          DateFormat("yyyy-MM-ddTHH:mm:ssZ")
              .parse(this.eventDate.toString(), true));
    }
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    data['isTrendingEvent'] = this.isTrendingEvent;
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type;
    data['totalTeams'] = this.totalTeams;
    data['maxPlayers'] = this.maxPlayers;
    data['displayDate'] = this.displayDate;
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['affiliateUrl'] = this.affiliateUrl;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['rules'] = this.rules;
    if (this.rankPoints != null) {
      //data['rankPoints'] = this.rankPoints.map((v) => v.toJson()).toList();
    }
    if (this.rankAmount != null) {
      data['rankAmount'] = this.rankAmount.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.gameId != null) {
      data['gameId'] = this.gameId.toJson();
    }
    if (this.gameModeId != null) {
      data['gameModeId'] = this.gameModeId.toJson();
    }
    if (this.joinSummary != null) {
      data['joinSummary'] = this.joinSummary.toJson();
    }

    if (this.gamePerspectiveId != null) {
      data['gamePerspectiveId'] = this.gamePerspectiveId.toJson();
    }
    if (this.teamTypeId != null) {
      data['teamTypeId'] = this.teamTypeId.toJson();
    }
    if (this.gameMapId != null) {
      data['gameMapId'] = this.gameMapId.toJson();
    }

    if (this.affiliate != null) {
      data['affiliate'] = this.affiliate.toJson();
    }
    data['clanUrl'] = this.clanUrl;
    data['streamUrl'] = this.streamUrl;
    data['password'] = this.password;
    return data;
  }

  String getRules() {
    return getValidString(this.rules);
  }

  bool isChampainShip() {
    bool is_champainship = false;
    if (this.type.compareTo("championship") == 0) {
      is_champainship = true;
    }
    return is_champainship;
  }

  String getRemaningPlayer() {
    String remaningPlayer = "";
    String remaningPlayer1 = "0";
    if (this.joinSummary != null) {
      remaningPlayer1 = isSoloContest()
          ? '${(this.maxPlayers - this.joinSummary.users) - 1}'
          : '${(this.totalTeams - this.joinSummary.teams) - 1}';
    }
    try {
      int a = int.parse(remaningPlayer1);
      if (a > 0) {
        remaningPlayer =
            isSoloContest() ? '${a} Players remaining' : '${a} Teams remaining';
      } else {
        remaningPlayer =
            isSoloContest() ? '${0} Players remaining' : '${0} Teams remaining';
      }
      //  Fluttertoast.showToast(msg: "call rem $a");
    } catch (E) {
      //Fluttertoast.showToast(msg: "exception $E");
    }

    /*   remaningPlayer = isSoloContest()
        ? '${(this.maxPlayers - this.joinSummary.users) - 1} Players remaining'
        : '${(this.totalTeams - this.joinSummary.teams) - 1} Teams remaining';*/
    return remaningPlayer;
  }

  int getRemaningPlayerLudoKing() {
    int remaningPlayer = 0;
    print("have remaningPlayer $remaningPlayer");
    String remaningPlayer1 = '${(this.maxPlayers - this.joinSummary.users)}';

    print("have data1 $remaningPlayer1");

    try {
      remaningPlayer = int.parse(remaningPlayer1);

      print("have data1 $remaningPlayer");
    } catch (E) {}
    return remaningPlayer;
  }

  int getRemaningPlayerCount() {
    int remaningPlayer = 0;
    String remaningPlayer1 = '0';
    if (this.joinSummary != null) {
      remaningPlayer1 = (isSoloContest()
          ? '${this.maxPlayers - this.joinSummary.users}'
          : '${this.totalTeams - this.joinSummary.teams}');
    }

    remaningPlayer = int.parse(remaningPlayer1);
    return remaningPlayer - 1;
  }

  int getRemaningPlayerCountLudoKing() {
    int remaningPlayer = 0;

    String remaningPlayer1 = '${this.joinSummary.users - this.maxPlayers}';
    remaningPlayer = int.parse(remaningPlayer1);

    return remaningPlayer;
  }

  String getEventJoinedPlayer() {
    String remaningPlayer = "";
    if (this.joinSummary != null) {
      remaningPlayer = isSoloContest()
          ? '${this.joinSummary.users} Players Joined'
          : ""
              "${this.joinSummary.teams} Teams Joined";
    }
    return remaningPlayer;
  }

  int getEventJoinedPlayerLudoKing() {
    int remaningPlayer1 = 0;
    String remaningPlayer = '${this.joinSummary.users}';
    print("have data1 $remaningPlayer");
    return remaningPlayer1 = int.parse(remaningPlayer);
  }

  bool isSoloContest() {
    bool is_solo = false;
    if (this.teamTypeId != null) {
      if (this.teamTypeId.size == 1) {
        return true;
      }
    }

    return is_solo;
  }

  double getProgresBar() {
    double value = 0;
    if (isSoloContest()) {
      value = (this.joinSummary.users / maxPlayers);
    } else {
      if (this.joinSummary != null)
        value = (this.joinSummary.teams / totalTeams);
    }
    Utils().customPrint("total player progress bar$value");

    if (this.getRemaningPlayerCount() > 0) {
      return value;
    } else {
      value = 1;
      return value;
    }
  }
}

class Entry {
  Fee fee;
  int feeBonusPercentage;

  num getBonuse() {
    num value = 0;
    value = ((fee.value / 100 * feeBonusPercentage) / 100);
    return value;
  }

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

  bool isBonuseType() {
    bool is_bonuse_type = false;
    Utils().customPrint(this.type);
    if (this.type == "bonus") {
      is_bonuse_type = true;
    }
    Utils().customPrint("is_bonuse_type==>${is_bonuse_type}");
    return is_bonuse_type;
  }

  int getEnteryFree() {}

  Fee({this.value, this.type});

  Fee.fromJson(Map<String, dynamic> json) {
    try {
      value = json['value'] as int;
    } catch (E) {
      double valueD = json['value'];
      value = valueD.toInt();
    }

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
  Fee perKillAmount;
  Fee prizeAmount;
  String type;
  String customPrize;

  //kill rank
  bool isKillType() {
    bool is_kill_type = false;
    if (this.type == "kill") {
      is_kill_type = true;
    }
    return is_kill_type;
  }

  Winner({this.perKillAmount, this.prizeAmount, this.type, this.customPrize});

  Winner.fromJson(Map<String, dynamic> json) {
    perKillAmount = json['perKillAmount'] != null
        ? new Fee.fromJson(json['perKillAmount'])
        : null;
    prizeAmount = json['prizeAmount'] != null
        ? new Fee.fromJson(json['prizeAmount'])
        : null;
    type = json['type'];
    customPrize = json['customPrize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.perKillAmount != null) {
      data['perKillAmount'] = this.perKillAmount.toJson();
    }
    if (this.prizeAmount != null) {
      data['prizeAmount'] = this.prizeAmount.toJson();
    }
    data['type'] = this.type;
    data['customPrize'] = this.customPrize;
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

  String getStartTime() {
    return DateTime.parse(this.start).hour.toString() + ":";
  }

  String getStartTimeHHMMSS() {
    return DateFormat("hh:mm aa").format(
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(this.start, true).toLocal());
  }

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

class Rounds extends AppBaseModel {
  String id;
  int serialNumber;
  String name;
  String status;
  String roomId;
  String roomPassword;
  bool isResultDeclared;
  bool isFinalRound;

  Rounds(
      {this.id,
      this.serialNumber,
      this.name,
      this.status,
      this.roomPassword,
      this.roomId,
      this.isResultDeclared,
      this.isFinalRound});

  Rounds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serialNumber = json['serialNumber'];
    name = json['name'];
    status = json['status'];
    roomId = json['roomId'];
    roomPassword = json['roomPassword'];
    isResultDeclared = json['isResultDeclared'];
    isFinalRound = json['isFinalRound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serialNumber'] = this.serialNumber;
    data['name'] = this.name;
    data['status'] = this.status;
    data['roomId'] = this.roomId;
    data['roomPassword'] = this.roomPassword;
    data['isResultDeclared'] = this.isResultDeclared;
    data['isFinalRound'] = this.isFinalRound;
    return data;
  }

  String getRoomId() {
    return getValidString(this.roomId);
  }

  String getRoomPassword() {
    return getValidString(this.roomPassword);
  }
}

class RulesModel extends AppBaseModel {
  var id, description, serialNumber;

  RulesModel({this.id, this.description, this.serialNumber});

  RulesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    serialNumber = json['serialNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['serialNumber'] = this.serialNumber;
    return data;
  }
}

class RankAmount {
  String id;
  Fee amount;
  int serialNumber;
  int rankFrom;
  int rankTo;
  String custom;

  String getRank() {
    if (this.rankTo == null && this.rankFrom == null) {
    } else if (this.rankFrom == null) {
      return "Rank " + this.rankTo.toString();
    } else if (this.rankTo == null) {
      return "Rank " + this.rankFrom.toString();
    } else {
      int differ = this.rankTo - this.rankFrom;
      if (differ > 0) {
        return "Rank " +
            rankFrom.toString() +
            " - " +
            "Rank " +
            rankTo.toString();
      } else {
        return "Rank " + rankFrom.toString();
      }
    }
  }

  RankAmount(
      {this.id, this.amount, this.serialNumber, this.rankFrom, this.custom});

  RankAmount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'] != null ? new Fee.fromJson(json['amount']) : null;
    serialNumber = json['serialNumber'];
    rankFrom = json['rankFrom'];
    rankTo = json['rankTo'];
    custom = json['custom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.amount != null) {
      data['amount'] = this.amount.toJson();
    }
    data['serialNumber'] = this.serialNumber;
    data['rankFrom'] = this.rankFrom;
    data['rankTo'] = this.rankTo;
    data['custom'] = this.custom;
    return data;
  }
}

class TeamType {
  String id;
  String name;
  int size;

  TeamType({this.id, this.name});

  TeamType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['size'] = this.size;
    return data;
  }
}

class GameId extends AppBaseModel {
  String id;
  String name;

  GameId({this.id, this.name});

  GameId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = getValidString(json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = getValidString(this.name);
    return data;
  }
}

class JoinSummary {
  var users;
  var teams;

  JoinSummary({this.users, this.teams});

  JoinSummary.fromJson(Map<String, dynamic> json) {
    users = json['users'];
    teams = json['teams'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['users'] = this.users;
    data['teams'] = this.teams;
    return data;
  }
}

class Affiliate {
  AffiBanner banner;
  String name;
  String url;
  String rules;

  Affiliate({this.banner, this.name, this.url, this.rules});

  Affiliate.fromJson(Map<String, dynamic> json) {
    banner =
        json['banner'] != null ? new AffiBanner.fromJson(json['banner']) : null;
    name = json['name'];
    url = json['url'];
    rules = json['rules'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    data['name'] = this.name;
    data['url'] = this.url;
    data['rules'] = this.rules;
    return data;
  }
}

class AffiBanner {
  String id;
  String url;

  AffiBanner({this.id, this.url});

  AffiBanner.fromJson(Map<String, dynamic> json) {
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

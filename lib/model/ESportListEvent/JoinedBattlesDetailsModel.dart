class JoinedBattlesDetailsModel {
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
  List<Rules> rules;
  List<RankAmount> rankAmount;
  List<Rounds> rounds;
  bool isTrendingEvent;
  String status;
  String createdBy;
  String updatedBy;
  List<Null> rankPoints;
  String createdAt;
  String updatedAt;
  GameId gameId;
  TeamTypeId teamTypeId;
  GameId gameMapId;
  GameId gamePerspectiveId;
  GameId gameModeId;
  JoinSummary joinSummary;

  JoinedBattlesDetailsModel(
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
        this.rules,
        this.rankAmount,
        this.rounds,
        this.isTrendingEvent,
        this.status,
        this.createdBy,
        this.updatedBy,
        this.rankPoints,
        this.createdAt,
        this.updatedAt,
        this.gameId,
        this.teamTypeId,
        this.gameMapId,
        this.gamePerspectiveId,
        this.gameModeId,
        this.joinSummary});

  JoinedBattlesDetailsModel.fromJson(Map<String, dynamic> json) {
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
    if (json['rules'] != null) {
      rules = new List<Rules>();
      json['rules'].forEach((v) {
        rules.add(new Rules.fromJson(v));
      });
    }
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
    status = json['status'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    if (json['rankPoints'] != null) {
      rankPoints = new List<Null>();
      json['rankPoints'].forEach((v) {
        //rankPoints.add(new Null.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    gameId =
    json['gameId'] != null ? new GameId.fromJson(json['gameId']) : null;
    teamTypeId = json['teamTypeId'] != null
        ? new TeamTypeId.fromJson(json['teamTypeId'])
        : null;
    gameMapId = json['gameMapId'] != null
        ? new GameId.fromJson(json['gameMapId'])
        : null;
    gamePerspectiveId = json['gamePerspectiveId'] != null
        ? new GameId.fromJson(json['gamePerspectiveId'])
        : null;
    gameModeId = json['gameModeId'] != null
        ? new GameId.fromJson(json['gameModeId'])
        : null;
    joinSummary = json['joinSummary'] != null
        ? new JoinSummary.fromJson(json['joinSummary'])
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
    if (this.rules != null) {
      data['rules'] = this.rules.map((v) => v.toJson()).toList();
    }
    if (this.rankAmount != null) {
      data['rankAmount'] = this.rankAmount.map((v) => v.toJson()).toList();
    }
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    data['isTrendingEvent'] = this.isTrendingEvent;
    data['status'] = this.status;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    if (this.rankPoints != null) {
     // data['rankPoints'] = this.rankPoints.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.gameId != null) {
      data['gameId'] = this.gameId.toJson();
    }
    if (this.teamTypeId != null) {
      data['teamTypeId'] = this.teamTypeId.toJson();
    }
    if (this.gameMapId != null) {
      data['gameMapId'] = this.gameMapId.toJson();
    }
    if (this.gamePerspectiveId != null) {
      data['gamePerspectiveId'] = this.gamePerspectiveId.toJson();
    }
    if (this.gameModeId != null) {
      data['gameModeId'] = this.gameModeId.toJson();
    }
    if (this.joinSummary != null) {
      data['joinSummary'] = this.joinSummary.toJson();
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
  Null end;

  EventDate({this.start, this.end});

  EventDate.fromJson(Map<String, dynamic> json) {
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

class Rules {
  String id;
  String description;
  int serialNumber;

  Rules({this.id, this.description, this.serialNumber});

  Rules.fromJson(Map<String, dynamic> json) {
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
  Null roomId;
  Null roomPassword;
  bool isResultDeclared;
  bool isFinalRound;

  Rounds(
      {this.id,
        this.serialNumber,
        this.name,
        this.status,
        this.roomId,
        this.roomPassword,
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
}

class GameId {
  String id;
  String name;

  GameId({this.id, this.name});

  GameId.fromJson(Map<String, dynamic> json) {
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

class TeamTypeId {
  String id;
  String name;
  int size;

  TeamTypeId({this.id, this.name, this.size});

  TeamTypeId.fromJson(Map<String, dynamic> json) {
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

class JoinSummary {
  int users;
  int teams;

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

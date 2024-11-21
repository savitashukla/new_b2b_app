class OnlyUnityHistoryModel {
  List<HistoryData> data;
  Pagination pagination;

  OnlyUnityHistoryModel({this.data, this.pagination});

  OnlyUnityHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<HistoryData>();
      json['data'].forEach((v) {
        data.add(new HistoryData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    return data;
  }
}

class HistoryData {
  String id;
  String userId;
  String housePlayerName;
  EventId eventId;
  bool isWinner;
  bool winningCredited;
  List<Rounds> rounds;
  Null teamId;
  TransactionIds transactionIds;
  PrizeAmount1 prizeAmount;

  String status;
  bool skipWinningCredit;
  String createdAt;
  String updatedAt;
  List<OpponentsAll> opponents;

  HistoryData(
      {this.id,
      this.userId,
      this.housePlayerName,
      this.eventId,
      this.transactionIds,
        this.prizeAmount,
      this.isWinner,
      this.winningCredited,
      this.rounds,
      this.teamId,
      this.status,
      this.skipWinningCredit,
      this.createdAt,
      this.updatedAt,
      this.opponents});

  HistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    housePlayerName = json['housePlayerName'];
    eventId =
        json['eventId'] != null ? new EventId.fromJson(json['eventId']) : null;
    transactionIds = json['transactionIds'] != null
        ? new TransactionIds.fromJson(json['transactionIds'])
        : null;

    prizeAmount = json['prizeAmount'] != null
        ? new PrizeAmount1.fromJson(json['prizeAmount'])
        : null;
    isWinner = json['isWinner'];
    winningCredited = json['winningCredited'];
    if (json['rounds'] != null) {
      rounds = new List<Rounds>();
      json['rounds'].forEach((v) {
        rounds.add(new Rounds.fromJson(v));
      });
    }
    teamId = json['teamId'];
    status = json['status'];
    skipWinningCredit = json['skipWinningCredit'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['opponents'] != null) {
      opponents = new List<OpponentsAll>();
      json['opponents'].forEach((v) {
        opponents.add(new OpponentsAll.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['housePlayerName'] = this.housePlayerName;
    if (this.eventId != null) {
      data['eventId'] = this.eventId.toJson();
    }

    if (this.transactionIds != null) {
      data['transactionIds'] = this.transactionIds.toJson();
    }
    if (this.prizeAmount != null) {
      data['prizeAmount'] = this.prizeAmount.toJson();
    }
    data['isWinner'] = this.isWinner;
    data['winningCredited'] = this.winningCredited;
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    data['teamId'] = this.teamId;
    data['status'] = this.status;
    data['skipWinningCredit'] = this.skipWinningCredit;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.opponents != null) {
      data['opponents'] = this.opponents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrizeAmount1 {
  int value;
  String type;

  PrizeAmount1(
      {this.value,
        this.type});

  PrizeAmount1.fromJson(Map<String, dynamic> json) {
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

class EventId {
  Entry entry;
  Winner winner;
  JoiningDate joiningDate;
  EventDate eventDate;
  CustomPrize customPrize;
  String sId;
  String name;
  String description;
  String type;
  bool isRMG;
  String teamTypeId;
  String gameId;
  int totalTeams;
  int maxPlayers;
  Fee platformFee;
  String displayDate;
  String password;
  String streamUrl;
  String clanUrl;
  String rules;
  int perKillPoints;
  List<RankAmount> rankAmount;
  List<EventIdrounds> rounds;
  bool isTrendingEvent;
  String status;
  Null affiliate;
  String updatedAt;
  String createdAt;
  int iV;
  int oldId;
  String updatedBy;

  EventId(
      {this.entry,
      this.winner,
      this.joiningDate,
      this.eventDate,
      this.customPrize,
      this.sId,
      this.name,
      this.description,
      this.type,
      this.isRMG,
      this.teamTypeId,
      this.gameId,
      this.totalTeams,
      this.maxPlayers,
      this.platformFee,
      this.displayDate,
      this.password,
      this.streamUrl,
      this.clanUrl,
      this.rules,
      this.perKillPoints,
      this.rankAmount,
      this.rounds,
      this.isTrendingEvent,
      this.status,
      this.affiliate,
      this.updatedAt,
      this.createdAt,
      this.iV,
      this.oldId,
      this.updatedBy});

  EventId.fromJson(Map<String, dynamic> json) {
    entry = json['entry'] != null ? new Entry.fromJson(json['entry']) : null;
    winner =
        json['winner'] != null ? new Winner.fromJson(json['winner']) : null;
    joiningDate = json['joiningDate'] != null
        ? new JoiningDate.fromJson(json['joiningDate'])
        : null;
    eventDate = json['eventDate'] != null
        ? new EventDate.fromJson(json['eventDate'])
        : null;
    customPrize = json['customPrize'] != null
        ? new CustomPrize.fromJson(json['customPrize'])
        : null;
    sId = json['_id'];
    name = json['name'];
    description = json['description'] ?? "";
    type = json['type'];
    isRMG = json['isRMG'];
    teamTypeId = json['teamTypeId'];
    gameId = json['gameId'];
    totalTeams = json['totalTeams'];
    maxPlayers = json['maxPlayers'];
    platformFee = json['platformFee'] != null
        ? new Fee.fromJson(json['platformFee'])
        : null;
    displayDate = json['displayDate'] ?? "";
    password = json['password'] ?? "";
    streamUrl = json['streamUrl'] ?? "";
    clanUrl = json['clanUrl'] ?? "";
    rules = json['rules'];
    perKillPoints = json['perKillPoints'];
    if (json['rankAmount'] != null) {
      rankAmount = new List<RankAmount>();
      json['rankAmount'].forEach((v) {
        rankAmount.add(new RankAmount.fromJson(v));
      });
    }
    if (json['rounds'] != null) {
      rounds = new List<EventIdrounds>();
      json['rounds'].forEach((v) {
        rounds.add(new EventIdrounds.fromJson(v));
      });
    }
    isTrendingEvent = json['isTrendingEvent'];
    status = json['status'];
    affiliate = json['affiliate'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    oldId = json['oldId'];
    updatedBy = json['updatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    if (this.customPrize != null) {
      data['customPrize'] = this.customPrize.toJson();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type;
    data['isRMG'] = this.isRMG;
    data['teamTypeId'] = this.teamTypeId;
    data['gameId'] = this.gameId;
    data['totalTeams'] = this.totalTeams;
    data['maxPlayers'] = this.maxPlayers;
    if (this.platformFee != null) {
      data['platformFee'] = this.platformFee.toJson();
    }
    data['displayDate'] = this.displayDate;
    data['password'] = this.password;
    data['streamUrl'] = this.streamUrl;
    data['clanUrl'] = this.clanUrl;
    data['rules'] = this.rules;
    data['perKillPoints'] = this.perKillPoints;
    if (this.rankAmount != null) {
      data['rankAmount'] = this.rankAmount.map((v) => v.toJson()).toList();
    }
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    data['isTrendingEvent'] = this.isTrendingEvent;
    data['status'] = this.status;
    data['affiliate'] = this.affiliate;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['oldId'] = this.oldId;
    data['updatedBy'] = this.updatedBy;
    return data;
  }
}

class Entry {
  Fee fee;
  String type;
  int feeBonusPercentage;

  Entry({this.fee, this.type, this.feeBonusPercentage});

  Entry.fromJson(Map<String, dynamic> json) {
    fee = json['fee'] != null ? new Fee.fromJson(json['fee']) : null;
    type = json['type'];
    feeBonusPercentage = json['feeBonusPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fee != null) {
      data['fee'] = this.fee.toJson();
    }
    data['type'] = this.type;
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
  Fee perKillAmount;
  Fee prizeAmount;
  String type;

  Winner({this.perKillAmount, this.prizeAmount, this.type});

  Winner.fromJson(Map<String, dynamic> json) {
    perKillAmount = json['perKillAmount'] != null
        ? new Fee.fromJson(json['perKillAmount'])
        : null;
    prizeAmount = json['prizeAmount'] != null
        ? new Fee.fromJson(json['prizeAmount'])
        : null;
    type = json['type'];
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
  int startTime;
  String end;
  int endTime;

  EventDate({this.start, this.startTime, this.end, this.endTime});

  EventDate.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    startTime = json['startTime'];
    end = json['end'] ?? "";
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['startTime'] = this.startTime;
    data['end'] = this.end;
    data['endTime'] = this.endTime;
    return data;
  }
}

class CustomPrize {
  String name;

  CustomPrize({this.name});

  CustomPrize.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class RankAmount {
  Fee amount;
  int serialNumber;
  int rankFrom;
  int rankTo;
  String sId;

  RankAmount(
      {this.amount, this.serialNumber, this.rankFrom, this.rankTo, this.sId});

  RankAmount.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] != null ? new Fee.fromJson(json['amount']) : null;
    serialNumber = json['serialNumber'];
    rankFrom = json['rankFrom'];
    rankTo = json['rankTo'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.amount != null) {
      data['amount'] = this.amount.toJson();
    }
    data['serialNumber'] = this.serialNumber;
    data['rankFrom'] = this.rankFrom;
    data['rankTo'] = this.rankTo;
    data['_id'] = this.sId;
    return data;
  }
}

class EventIdrounds {
  int serialNumber;
  String name;
  String status;
  Null roomId;
  Null roomPassword;
  bool isResultDeclared;
  bool isFinalRound;
  String sId;

  EventIdrounds(
      {this.serialNumber,
      this.name,
      this.status,
      this.roomId,
      this.roomPassword,
      this.isResultDeclared,
      this.isFinalRound,
      this.sId});

  EventIdrounds.fromJson(Map<String, dynamic> json) {
    serialNumber = json['serialNumber'];
    name = json['name'];
    status = json['status'];
    roomId = json['roomId'];
    roomPassword = json['roomPassword'];
    isResultDeclared = json['isResultDeclared'];
    isFinalRound = json['isFinalRound'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serialNumber'] = this.serialNumber;
    data['name'] = this.name;
    data['status'] = this.status;
    data['roomId'] = this.roomId;
    data['roomPassword'] = this.roomPassword;
    data['isResultDeclared'] = this.isResultDeclared;
    data['isFinalRound'] = this.isFinalRound;
    data['_id'] = this.sId;
    return data;
  }
}

class Rounds {
  String id;
  String roundId;
  String lobbyId;
  String roomId;
  int slot;
  bool isWinner;

  Result result;

  Rounds(
      {this.id,
      this.roundId,
      this.lobbyId,
      this.roomId,
      this.slot,
      this.isWinner,
      this.result});

  Rounds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roundId = json['roundId'];
    lobbyId = json['lobbyId'];
    roomId = json['roomId'];
    slot = json['slot'];
    isWinner = json['isWinner'];

    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roundId'] = this.roundId;
    data['lobbyId'] = this.lobbyId;
    data['roomId'] = this.roomId;
    data['slot'] = this.slot;
    data['isWinner'] = this.isWinner;

    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String score;
  int rank;

  Result({this.score, this.rank});

  Result.fromJson(Map<String, dynamic> json) {
    score = "${json['score']}";
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['rank'] = this.rank;
    return data;
  }
}

class OpponentsAll {
  String id;
  Fee prizeAmount;
  String housePlayerName;
  String eventId;
  bool isWinner;
  bool winningCredited;
  List<Opponentsrounds> rounds;
  Null teamId;
  String status;
  bool skipWinningCredit;
  String createdAt;
  String updatedAt;
  UserId userId;

  OpponentsAll(
      {this.id,
      this.prizeAmount,
      this.housePlayerName,
      this.eventId,
      this.isWinner,
      this.winningCredited,
      this.rounds,
      this.teamId,
      this.status,
      this.skipWinningCredit,
      this.createdAt,
      this.updatedAt,
      this.userId});

  OpponentsAll.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prizeAmount = json['prizeAmount'] != null
        ? new Fee.fromJson(json['prizeAmount'])
        : null;
    housePlayerName = json['housePlayerName'];
    eventId = json['eventId'];
    isWinner = json['isWinner'];
    winningCredited = json['winningCredited'];
    if (json['rounds'] != null) {
      rounds = new List<Opponentsrounds>();
      json['rounds'].forEach((v) {
        rounds.add(new Opponentsrounds.fromJson(v));
      });
    }
    teamId = json['teamId'];
    status = json['status'];
    skipWinningCredit = json['skipWinningCredit'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId =
        json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.prizeAmount != null) {
      data['prizeAmount'] = this.prizeAmount.toJson();
    }
    data['housePlayerName'] = this.housePlayerName;
    data['eventId'] = this.eventId;
    data['isWinner'] = this.isWinner;
    data['winningCredited'] = this.winningCredited;
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    data['teamId'] = this.teamId;
    data['status'] = this.status;
    data['skipWinningCredit'] = this.skipWinningCredit;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.userId != null) {
      data['userId'] = this.userId.toJson();
    }
    return data;
  }
}

class TransactionIds {
  String depositTransactionId;
  String winningTransactionId;
  String bonusTransactionId;

  TransactionIds(
      {this.depositTransactionId,
      this.winningTransactionId,
      this.bonusTransactionId});

  TransactionIds.fromJson(Map<String, dynamic> json) {
    depositTransactionId = json['depositTransactionId'];
    winningTransactionId = json['winningTransactionId'];
    bonusTransactionId = json['bonusTransactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['depositTransactionId'] = this.depositTransactionId;
    data['winningTransactionId'] = this.winningTransactionId;
    data['bonusTransactionId'] = this.bonusTransactionId;
    return data;
  }
}

class Opponentsrounds {
  String roundId;
  String lobbyId;
  String roomId;
  int slot;
  bool isWinner;

  Result result;
  String sId;

  Opponentsrounds(
      {this.roundId,
      this.lobbyId,
      this.roomId,
      this.slot,
      this.isWinner,
      this.result,
      this.sId});

  Opponentsrounds.fromJson(Map<String, dynamic> json) {
    roundId = json['roundId'];
    lobbyId = json['lobbyId'];
    roomId = json['roomId'];
    slot = json['slot'] ?? 0;
    isWinner = json['isWinner'];

    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roundId'] = this.roundId;
    data['lobbyId'] = this.lobbyId;
    data['roomId'] = this.roomId;
    data['slot'] = this.slot;
    data['isWinner'] = this.isWinner;

    if (this.result != null) {
      // data['result'] = null;
      data['result'] = this.result.toJson();
    }
    data['_id'] = this.sId;
    return data;
  }
}

class UserId {
  String id;
  String username;
  Mobile mobile;
  Photo photo;

  //Null photo;

  UserId({this.id, this.username, this.mobile});

  UserId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    mobile =
        json['mobile'] != null ? new Mobile.fromJson(json['mobile']) : null;

    photo = json['photo'] != null ? Photo.fromJson(json['photo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    if (this.mobile != null) {
      data['mobile'] = this.mobile.toJson();
    }

    if (this.photo != null) {
      data['photo'] = this.photo;
    }
    return data;
  }
}

class Photo {
  String id;
  String url;

  Photo({this.id, this.url});

  Photo.fromJson(Map<String, dynamic> json) {
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

class Mobile {
  int countryCode;
  int number;
  bool isVerified;

  Mobile({this.countryCode, this.number, this.isVerified});

  Mobile.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    number = json['number'];
    isVerified = json['isVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryCode'] = this.countryCode;
    data['number'] = this.number;
    data['isVerified'] = this.isVerified;
    return data;
  }
}

class Pagination {
  int offset;
  int total;
  int count;
  int limit;

  Pagination({this.offset, this.total, this.count, this.limit});

  Pagination.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    total = json['total'];
    count = json['count'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = this.offset;
    data['total'] = this.total;
    data['count'] = this.count;
    data['limit'] = this.limit;
    return data;
  }
}

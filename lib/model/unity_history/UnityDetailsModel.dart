class UnityDetailsModel {
  List<Users> users;
  Pagination pagination;

  UnityDetailsModel({this.users, this.pagination});

  UnityDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) { users.add(new Users.fromJson(v)); });
    }
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    return data;
  }
}

class Users {
  String id;
  PrizeAmount prizeAmount;
  bool skipWinningCredit;
  String userId;
  String eventId;
  bool isWinner;
  bool winningCredited;
  List<Rounds> rounds;
  Null teamId;
  String status;
  TransactionIds transactionIds;
  String createdAt;
  String updatedAt;
  List<Opponents> opponents;

  Users({this.id, this.prizeAmount, this.skipWinningCredit, this.userId, this.eventId, this.isWinner, this.winningCredited, this.rounds, this.teamId, this.status, this.transactionIds, this.createdAt, this.updatedAt, this.opponents});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prizeAmount = json['prizeAmount'] != null ? new PrizeAmount.fromJson(json['prizeAmount']) : null;
    skipWinningCredit = json['skipWinningCredit'];
    userId = json['userId'];
    eventId = json['eventId'];
    isWinner = json['isWinner'];
    winningCredited = json['winningCredited'];
    if (json['rounds'] != null) {
      rounds = new List<Rounds>();
      json['rounds'].forEach((v) { rounds.add(new Rounds.fromJson(v)); });
    }
    teamId = json['teamId'];
    status = json['status'];
    transactionIds = json['transactionIds'] != null ? new TransactionIds.fromJson(json['transactionIds']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['opponents'] != null) {
      opponents = new List<Opponents>();
      json['opponents'].forEach((v) { opponents.add(new Opponents.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.prizeAmount != null) {
      data['prizeAmount'] = this.prizeAmount.toJson();
    }
    data['skipWinningCredit'] = this.skipWinningCredit;
    data['userId'] = this.userId;
    data['eventId'] = this.eventId;
    data['isWinner'] = this.isWinner;
    data['winningCredited'] = this.winningCredited;
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    data['teamId'] = this.teamId;
    data['status'] = this.status;
    if (this.transactionIds != null) {
      data['transactionIds'] = this.transactionIds.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;

    if (this.opponents != null) {
      data['opponents'] = this.opponents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrizeAmount {
  int value;
  String type;

  PrizeAmount({this.value, this.type});

  PrizeAmount.fromJson(Map<String, dynamic> json) {
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

class Rounds {
  String id;
  String roundId;
  LobbyId lobbyId;
  String roomId;
  Null slot;
  bool isWinner;
  Null gmngRank;
  Null gmngTeamRank;
  Result result;

  Rounds({this.id, this.roundId, this.lobbyId, this.roomId, this.slot, this.isWinner, this.gmngRank, this.gmngTeamRank, this.result});

  Rounds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roundId = json['roundId'];
    lobbyId = json['lobbyId'] != null ? new LobbyId.fromJson(json['lobbyId']) : null;
    roomId = json['roomId'];
    slot = json['slot'];
    isWinner = json['isWinner'];
    gmngRank = json['gmngRank'];
    gmngTeamRank = json['gmngTeamRank'];
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roundId'] = this.roundId;
    if (this.lobbyId != null) {
      data['lobbyId'] = this.lobbyId.toJson();
    }
    data['roomId'] = this.roomId;
    data['slot'] = this.slot;
    data['isWinner'] = this.isWinner;
    data['gmngRank'] = this.gmngRank;
    data['gmngTeamRank'] = this.gmngTeamRank;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class LobbyId {
  String sId;
  String eventId;
  String roundId;
  int serialNumber;
  int totalWinners;
  int totalTeams;
  Null gameMapId;
  Null startDate;
  Null roomId;
  Null roomPassword;
  String completedStatus;
  String status;
  String createdAt;
  String updatedAt;
  int iV;

  LobbyId({this.sId, this.eventId, this.roundId, this.serialNumber, this.totalWinners, this.totalTeams, this.gameMapId, this.startDate, this.roomId, this.roomPassword, this.completedStatus, this.status, this.createdAt, this.updatedAt, this.iV});

  LobbyId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    eventId = json['eventId'];
    roundId = json['roundId'];
    serialNumber = json['serialNumber'];
    totalWinners = json['totalWinners'];
    totalTeams = json['totalTeams'];
    gameMapId = json['gameMapId'];
    startDate = json['startDate'];
    roomId = json['roomId'];
    roomPassword = json['roomPassword'];
    completedStatus = json['completedStatus'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['eventId'] = this.eventId;
    data['roundId'] = this.roundId;
    data['serialNumber'] = this.serialNumber;
    data['totalWinners'] = this.totalWinners;
    data['totalTeams'] = this.totalTeams;
    data['gameMapId'] = this.gameMapId;
    data['startDate'] = this.startDate;
    data['roomId'] = this.roomId;
    data['roomPassword'] = this.roomPassword;
    data['completedStatus'] = this.completedStatus;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Result {
  int score;
  int rank;

  Result({this.score, this.rank});

  Result.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['rank'] = this.rank;
    return data;
  }
}

class TransactionIds {
  String depositTransactionId;
  String winningTransactionId;
  String bonusTransactionId;

  TransactionIds({this.depositTransactionId, this.winningTransactionId, this.bonusTransactionId});

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



class Opponents {
  String id;
  PrizeAmount prizeAmount;
  bool skipWinningCredit;
  String eventId;
  bool isWinner;
  bool winningCredited;
  List<RoundsO> rounds;
  Null teamId;
  String status;
  TransactionIds transactionIds;
  String createdAt;
  String updatedAt;
  UserId userId;

  Opponents({this.id, this.prizeAmount, this.skipWinningCredit, this.eventId, this.isWinner, this.winningCredited, this.rounds, this.teamId, this.status, this.transactionIds, this.createdAt, this.updatedAt, this.userId});

  Opponents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prizeAmount = json['prizeAmount'] != null ? new PrizeAmount.fromJson(json['prizeAmount']) : null;
    skipWinningCredit = json['skipWinningCredit'];
    eventId = json['eventId'];
    isWinner = json['isWinner'];
    winningCredited = json['winningCredited'];
    if (json['rounds'] != null) {
      rounds = new List<RoundsO>();
      json['rounds'].forEach((v) { rounds.add(new RoundsO.fromJson(v)); });
    }
    teamId = json['teamId'];
    status = json['status'];
    transactionIds = json['transactionIds'] != null ? new TransactionIds.fromJson(json['transactionIds']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.prizeAmount != null) {
      data['prizeAmount'] = this.prizeAmount.toJson();
    }
    data['skipWinningCredit'] = this.skipWinningCredit;
    data['eventId'] = this.eventId;
    data['isWinner'] = this.isWinner;
    data['winningCredited'] = this.winningCredited;
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    data['teamId'] = this.teamId;
    data['status'] = this.status;
    if (this.transactionIds != null) {
      data['transactionIds'] = this.transactionIds.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.userId != null) {
      data['userId'] = this.userId.toJson();
    }
    return data;
  }
}

class RoundsO {
  String roundId;
  String lobbyId;
  String roomId;
  Null slot;
  bool isWinner;
  Null gmngRank;
  Null gmngTeamRank;
  Result result;
  String sId;

  RoundsO({this.roundId, this.lobbyId, this.roomId, this.slot, this.isWinner, this.gmngRank, this.gmngTeamRank, this.result, this.sId});

  RoundsO.fromJson(Map<String, dynamic> json) {
    roundId = json['roundId'];
    lobbyId = json['lobbyId'];
    roomId = json['roomId'];
    slot = json['slot'];
    isWinner = json['isWinner'];
    gmngRank = json['gmngRank'];
    gmngTeamRank = json['gmngTeamRank'];
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roundId'] = this.roundId;
    data['lobbyId'] = this.lobbyId;
    data['roomId'] = this.roomId;
    data['slot'] = this.slot;
    data['isWinner'] = this.isWinner;
    data['gmngRank'] = this.gmngRank;
    data['gmngTeamRank'] = this.gmngTeamRank;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['_id'] = this.sId;
    return data;
  }
}

class UserId {
  String id;
  Null name;
  String username;
  Mobile mobile;
  Null photo;

  UserId({this.id, this.name, this.username, this.mobile, this.photo});

  UserId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    mobile = json['mobile'] != null ? new Mobile.fromJson(json['mobile']) : null;
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    if (this.mobile != null) {
      data['mobile'] = this.mobile.toJson();
    }
    data['photo'] = this.photo;
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

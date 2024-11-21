import '../basemodel/AppBaseModel.dart';

class Data {
  String id;
  List<RoundsU> rounds;
  String eventId;
  String userId;
  bool isWinner;
  bool winningCredited;
  String status;
  List<Opponents> opponents;

  Data(
      {this.id,
      this.rounds,
      this.eventId,
      this.userId,
      this.isWinner,
      this.winningCredited,
      this.status,
      this.opponents});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['rounds'] != null) {
      rounds = new List<RoundsU>();
      json['rounds'].forEach((v) {
        rounds.add(new RoundsU.fromJson(v));
      });
    }
    eventId = json['eventId'];
    userId = json['userId'];
    isWinner = json['isWinner'];
    winningCredited = json['winningCredited'];
    status = json['status'];
    if (json['opponents'] != null) {
      opponents = new List<Opponents>();
      json['opponents'].forEach((v) {
        opponents.add(new Opponents.fromJson(v));
      });
     // opponents.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    }


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
    data['status'] = this.status;
    if (this.opponents != null) {
      data['opponents'] = this.opponents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoundsU {
  String id;
  String roundId;
  LobbyId lobbyId;
  String roomId;
  bool isWinner;

  Result result;

  RoundsU(
      {this.id,
      this.roundId,
      this.lobbyId,
      this.roomId,
      this.isWinner,
      this.result});

  RoundsU.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roundId = json['roundId'];
    lobbyId =
        json['lobbyId'] != null ? new LobbyId.fromJson(json['lobbyId']) : null;
    roomId = json['roomId'];

    isWinner = json['isWinner'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roundId'] = this.roundId;
    if (this.lobbyId != null) {
      data['lobbyId'] = this.lobbyId.toJson();
    }
    data['roomId'] = this.roomId;
    data['isWinner'] = this.isWinner;

    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class LobbyId {
  String id;
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

  LobbyId(
      {this.id,
      this.eventId,
      this.roundId,
      this.serialNumber,
      this.totalWinners,
      this.totalTeams,
      this.gameMapId,
      this.startDate,
      this.roomId,
      this.roomPassword,
      this.completedStatus,
      this.status,
      this.createdAt,
      this.updatedAt});

  LobbyId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    return data;
  }
}

class Result {
  var score;
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

class Opponents {
  String id;
  PrizeAmount prizeAmount;
  bool skipWinningCredit;
  String eventId;
  bool isWinner;
  bool winningCredited;
  List<Rounds> rounds;
  String status;
  String housePlayerName;
  TransactionIds transactionIds;
  String createdAt;
  String updatedAt;
  UserId userId;

  Opponents(
      {this.id,
      this.prizeAmount,
      this.skipWinningCredit,
      this.eventId,
      this.isWinner,
      this.winningCredited,
      this.rounds,
      this.status,
      this.housePlayerName,
      this.transactionIds,
      this.createdAt,
      this.updatedAt,
      this.userId});

  Opponents.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    prizeAmount = json['prizeAmount'] != null
        ? new PrizeAmount.fromJson(json['prizeAmount'])
        : null;
    skipWinningCredit = json['skipWinningCredit'];
    eventId = json['eventId'];
    isWinner = json['isWinner'];
    winningCredited = json['winningCredited'];
    if (json['rounds'] != null) {
      rounds = new List<Rounds>();
      json['rounds'].forEach((v) {
        rounds.add(new Rounds.fromJson(v));
      });
    }
    status = json['status'];
    housePlayerName = json['housePlayerName'];
    transactionIds = json['transactionIds'] != null
        ? new TransactionIds.fromJson(json['transactionIds'])
        : null;
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
    data['skipWinningCredit'] = this.skipWinningCredit;
    data['eventId'] = this.eventId;
    data['housePlayerName'] = this.housePlayerName;
    data['isWinner'] = this.isWinner;
    data['winningCredited'] = this.winningCredited;
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    if (this.transactionIds != null) {
      data['transactionIds'] = this.transactionIds;
    }

    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.userId != null) {
      data['userId'] = this.userId.toJson();
    }
    return data;
  }
}

class TransactionIds {
  String depositTransactionId, winningTransactionId, bonusTransactionId;

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
  String roundId;
  String lobbyId;
  String roomId;
  bool isWinner;

  Result result;
  String sId;

  Rounds(
      {this.roundId,
      this.lobbyId,
      this.roomId,
      this.isWinner,
      this.result,
      this.sId});

  Rounds.fromJson(Map<String, dynamic> json) {
    roundId = json['roundId'];
    lobbyId = json['lobbyId'];
    roomId = json['roomId'];
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
    data['isWinner'] = this.isWinner;

    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['_id'] = this.sId;
    return data;
  }
}

class UserId {
  String id;
  UserName name;
  String username;
  Mobile mobile;
  Photo photo;

  UserId({this.id, this.name, this.username, this.mobile, this.photo});

  UserId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] != null ? new UserName.fromJson(json['name']) : null;
    username = json['username'];
    mobile =
        json['mobile'] != null ? new Mobile.fromJson(json['mobile']) : null;
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
    ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name;
    }
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

class UserName extends AppBaseModel {
  String first, last;

  UserName({this.first, this.last});

  UserName.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
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

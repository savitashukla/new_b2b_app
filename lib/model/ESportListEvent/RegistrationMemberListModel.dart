class RegistrationMemberListModel {
  String id;
  Null housePlayerName;
  String eventId;
  bool isWinner;
  bool winningCredited;
  Null customPrize;
  List<Rounds> rounds;
  String status;
  bool skipWinningCredit;
  TransactionIds transactionIds;
  String createdAt;
  String updatedAt;
  Null teamId;
  UserId userId;

  RegistrationMemberListModel({this.id, this.housePlayerName, this.eventId, this.isWinner, this.winningCredited, this.customPrize, this.rounds, this.status, this.skipWinningCredit, this.transactionIds, this.createdAt, this.updatedAt, this.teamId, this.userId});

  RegistrationMemberListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    housePlayerName = json['housePlayerName'];
    eventId = json['eventId'];
    isWinner = json['isWinner'];
    winningCredited = json['winningCredited'];
    customPrize = json['customPrize'];
    if (json['rounds'] != null) {
      rounds = new List<Rounds>();
      json['rounds'].forEach((v) { rounds.add(new Rounds.fromJson(v)); });
    }
    status = json['status'];
    skipWinningCredit = json['skipWinningCredit'];
    transactionIds = json['transactionIds'] != null ? new TransactionIds.fromJson(json['transactionIds']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    teamId = json['teamId'];
    userId = json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['housePlayerName'] = this.housePlayerName;
    data['eventId'] = this.eventId;
    data['isWinner'] = this.isWinner;
    data['winningCredited'] = this.winningCredited;
    data['customPrize'] = this.customPrize;
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['skipWinningCredit'] = this.skipWinningCredit;
    if (this.transactionIds != null) {
      data['transactionIds'] = this.transactionIds.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['teamId'] = this.teamId;
    if (this.userId != null) {
      data['userId'] = this.userId.toJson();
    }

    return data;
  }
}

class Rounds {
  String id;
  String roundId;
  Null lobbyId;
  Null roomId;
  Null slot;
  bool isWinner;
  Null gmngRank;
  Null gmngTeamRank;
  Null result;

  Rounds({this.id, this.roundId, this.lobbyId, this.roomId, this.slot, this.isWinner, this.gmngRank, this.gmngTeamRank, this.result});

  Rounds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roundId = json['roundId'];
    lobbyId = json['lobbyId'];
    roomId = json['roomId'];
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
    data['lobbyId'] = this.lobbyId;
    data['roomId'] = this.roomId;
    data['slot'] = this.slot;
    data['isWinner'] = this.isWinner;
    data['gmngRank'] = this.gmngRank;
    data['gmngTeamRank'] = this.gmngTeamRank;
    data['result'] = this.result;
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

class UserId {
  String id;
  Name name;
  String username;
  Mobile mobile;
  Photo photo;

  UserId({this.id, this.name, this.username, this.mobile, this.photo});

  UserId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    username = json['username'];
    mobile = json['mobile'] != null ? new Mobile.fromJson(json['mobile']) : null;
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['username'] = this.username;
    if (this.mobile != null) {
      data['mobile'] = this.mobile.toJson();
    }
    if (this.photo != null) {
      data['photo'] = this.photo.toJson();
    }
    return data;
  }
}

class Name {
  String first;
  String last;

  Name({this.first, this.last});

  Name.fromJson(Map<String, dynamic> json) {
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






/*
class RegistrationMemberListModel {
  List<Users> users;
  Pagination pagination;

  RegistrationMemberListModel({this.users, this.pagination});

  RegistrationMemberListModel.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
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
  String eventId;
  bool isWinner;
  bool winningCredited;
  List<Rounds> rounds;
  String status;
  String createdAt;
  String updatedAt;
  UserId userId;
  String teamId;

  Users(
      {this.id,
        this.eventId,
        this.isWinner,
        this.winningCredited,
        this.rounds,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.teamId});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId =
    json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    if(json['teamId']!=null)
      {
        teamId = json['teamId'];
      }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eventId'] = this.eventId;
    data['isWinner'] = this.isWinner;
    data['winningCredited'] = this.winningCredited;
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.userId != null) {
      data['userId'] = this.userId.toJson();
    }
    data['teamId'] = this.teamId;
    return data;
  }
}

class Rounds {
  String id;
  Null slot;
  String roundId;
  String lobbyId;
  bool isWinner;
  Null gmngRank;
  Null gmngTeamRank;
  Null result;

  Rounds(
      {this.id,
        this.slot,
        this.roundId,
        this.lobbyId,
        this.isWinner,
        this.gmngRank,
        this.gmngTeamRank,
        this.result});

  Rounds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slot = json['slot'];
    roundId = json['roundId'];
    lobbyId = json['lobbyId'];
    isWinner = json['isWinner'];
    gmngRank = json['gmngRank'];
    gmngTeamRank = json['gmngTeamRank'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slot'] = this.slot;
    data['roundId'] = this.roundId;
    data['lobbyId'] = this.lobbyId;
    data['isWinner'] = this.isWinner;
    data['gmngRank'] = this.gmngRank;
    data['gmngTeamRank'] = this.gmngTeamRank;
    data['result'] = this.result;
    return data;
  }
}

class UserId {
  String id;
  Name name;
  String username;
  Mobile mobile;

  UserId({this.id, this.name, this.username, this.mobile});

  UserId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    username = json['username'];
    mobile =
    json['mobile'] != null ? new Mobile.fromJson(json['mobile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['username'] = this.username;
    if (this.mobile != null) {
      data['mobile'] = this.mobile.toJson();
    }
    return data;
  }
}

class Name {
  String first;
  String last;

  Name({this.first, this.last});

  Name.fromJson(Map<String, dynamic> json) {
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
*/

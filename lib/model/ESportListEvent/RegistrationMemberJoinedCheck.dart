class RegistrationMemberJoinedCheckM {
  String id;
  String eventId;
  bool isWinner;
  bool winningCredited;
  List<Rounds> rounds;
  String status;
  String createdAt;
  String updatedAt;
  UserId userId;

  RegistrationMemberJoinedCheckM(
      {this.id,
      this.eventId,
      this.isWinner,
      this.winningCredited,
      this.rounds,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.userId});

  RegistrationMemberJoinedCheckM.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class Rounds {
  String id;
  String roundId;
  String lobbyId;
  bool isWinner;
  int gmngRank;
  Result result;

  Rounds(
      {this.id,
      this.roundId,
      this.lobbyId,
      this.isWinner,
      this.gmngRank,
      this.result});

  Rounds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roundId = json['roundId'];
    lobbyId = json['lobbyId'];
    isWinner = json['isWinner'];
    gmngRank = json['gmngRank'];

    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roundId'] = this.roundId;
    data['lobbyId'] = this.lobbyId;
    data['isWinner'] = this.isWinner;
    data['gmngRank'] = this.gmngRank;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  int score;
  int rank;
  int kill;

  Result({this.score, this.rank, this.kill});

  Result.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    rank = json['rank'];
    kill = json['kill'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['rank'] = this.rank;
    data['kill'] = this.kill;
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

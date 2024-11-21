class UserJoinedSoloResult {
  String id;
  String eventId;
  bool isWinner;
  bool winningCredited;
  List<Rounds> rounds;
  String status;
  String createdAt;
  String updatedAt;
  UserId userId;
  PrizeAmount prizeAmount;
  UserJoinedSoloResult(
      {this.id,
        this.eventId,
        this.isWinner,
        this.winningCredited,
        this.rounds,
        this.prizeAmount,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.userId});

  UserJoinedSoloResult.fromJson(Map<String, dynamic> json) {
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
    userId = json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    prizeAmount = json['prizeAmount'] != null ? new PrizeAmount.fromJson(json['prizeAmount']) : null;
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
    if (this.prizeAmount != null) {
      data['prizeAmount'] = this.prizeAmount.toJson();
    }

    return data;
  }
}
class PrizeAmount{
  var value;
  var type;
  PrizeAmount.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'] ;
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
  var slot;
  var gmngRank;
  var gmngTeamRank;
  Result result;
  String roundId;
  String lobbyId;
  bool isWinner;
  var rank;
  var teamRank;

  Rounds(
      {this.id,
        this.slot,
        this.gmngRank,
        this.gmngTeamRank,
        this.result,
        this.roundId,
        this.lobbyId,
        this.isWinner,
        this.rank,
        this.teamRank});

  Rounds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slot = json['slot'];
    gmngRank = json['gmngRank'];
    gmngTeamRank = json['gmngTeamRank'];
    result=json['result'] != null ? new Result.fromJson(json['result']) : null;
    roundId = json['roundId'];
    lobbyId = json['lobbyId'];
    isWinner = json['isWinner'];
    rank = json['rank'];
    teamRank = json['teamRank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slot'] = this.slot;
    data['gmngRank'] = this.gmngRank;
    data['gmngTeamRank'] = this.gmngTeamRank;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['roundId'] = this.roundId;
    data['lobbyId'] = this.lobbyId;
    data['isWinner'] = this.isWinner;
    data['rank'] = this.rank;
    data['teamRank'] = this.teamRank;
    return data;
  }
}

class Result{
  int score;
  int rank;
  int kill;
  int getRank(){
    if(this.rank==null){
      return 0;
    }
    return this.rank;

  }
  Result.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    rank = json['rank'] ;
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
  String getMoblieNumber(){
    String number=this.number.toString();
    return "***"+number.substring(3, number.length - 1);
  }
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
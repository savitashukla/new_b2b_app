class UserJoinedResult {
  List<Members> members;
  TeamId teamId;
  bool isWinner;
  bool winningCredited;

  UserJoinedResult(
      {this.members, this.teamId, this.isWinner, this.winningCredited});

  UserJoinedResult.fromJson(Map<String, dynamic> json) {
    if (json['members'] != null) {
      members = new List<Members>();
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
    teamId =
    json['teamId'] != null ? new TeamId.fromJson(json['teamId']) : null;
    isWinner = json['isWinner'];
    winningCredited = json['winningCredited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    if (this.teamId != null) {
      data['teamId'] = this.teamId.toJson();
    }
    data['isWinner'] = this.isWinner;
    data['winningCredited'] = this.winningCredited;
    return data;
  }
}

class Members {
  EventRegistration eventRegistration;
  UserId userId;

  Members({this.eventRegistration, this.userId});

  Members.fromJson(Map<String, dynamic> json) {
    eventRegistration = json['eventRegistration'] != null
        ? new EventRegistration.fromJson(json['eventRegistration'])
        : null;
    userId =
    json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eventRegistration != null) {
      data['eventRegistration'] = this.eventRegistration.toJson();
    }
    if (this.userId != null) {
      data['userId'] = this.userId.toJson();
    }
    return data;
  }
}

class EventRegistration {
  String id;
  String userId;
  String eventId;
  bool isWinner;
  bool winningCredited;
  List<Rounds> rounds;
  String teamId;
  String status;
  String createdAt;
  String updatedAt;
  PrizeAmount prizeAmount;

  EventRegistration(
      {this.id,
        this.userId,
        this.eventId,
        this.isWinner,
        this.winningCredited,
        this.rounds,
        this.prizeAmount,
        this.teamId,
        this.status,
        this.createdAt,
        this.updatedAt});

  EventRegistration.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    eventId = json['eventId'];
    isWinner = json['isWinner'];
    winningCredited = json['winningCredited'];
    if (json['rounds'] != null) {
      rounds = new List<Rounds>();
      json['rounds'].forEach((v) {
        rounds.add(new Rounds.fromJson(v));
      });
    }
    prizeAmount = json['prizeAmount'] != null ? new PrizeAmount.fromJson(json['prizeAmount']) : null;
    teamId = json['teamId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['eventId'] = this.eventId;
    data['isWinner'] = this.isWinner;
    data['winningCredited'] = this.winningCredited;
    if (this.rounds != null) {
      data['rounds'] = this.rounds.map((v) => v.toJson()).toList();
    }
    if (this.prizeAmount != null) {
      data['prizeAmount'] = this.prizeAmount.toJson();
    }
    data['teamId'] = this.teamId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
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
  String roundId;
  String lobbyId;
  bool isWinner;
  int rank;
  int slot;
  int teamRank;
  String sId;
  Result result;

  Rounds(
      {this.roundId,
        this.lobbyId,
        this.isWinner,
        this.rank,
        this.slot,
        this.teamRank,
        this.sId});

  Rounds.fromJson(Map<String, dynamic> json) {
    roundId = json['roundId'];
    lobbyId = json['lobbyId'];
    isWinner = json['isWinner'];
    rank = json['rank'];
    slot = json['slot'];
    teamRank = json['teamRank'];
    result=json['result'] != null ? new Result.fromJson(json['result']) : null;
    sId = json['_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roundId'] = this.roundId;
    data['lobbyId'] = this.lobbyId;
    data['isWinner'] = this.isWinner;
    data['rank'] = this.rank;
    data['slot'] = this.slot;
    data['teamRank'] = this.teamRank;
    data['_id'] = this.sId;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
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
  String username;
  Name name;
  Mobile mobile;

  UserId({this.id, this.username, this.name, this.mobile});

  UserId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    mobile =
    json['mobile'] != null ? new Mobile.fromJson(json['mobile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
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
  String getMoblieNumber(){
    String number=this.number.toString();
    return "***"+number.substring(3, number.length - 1);
  }

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

class TeamId {
  String id;
  String name;

  TeamId({this.id, this.name});

  TeamId.fromJson(Map<String, dynamic> json) {
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
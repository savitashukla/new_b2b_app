class RegistrationMemberListModelTeamType {
  List<Teams> teams;
  Pagination pagination;

  RegistrationMemberListModelTeamType({this.teams, this.pagination});

  RegistrationMemberListModelTeamType.fromJson(Map<String, dynamic> json) {
    if (json['teams'] != null) {
      teams = new List<Teams>();
      json['teams'].forEach((v) {
        teams.add(new Teams.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teams != null) {
      data['teams'] = this.teams.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    return data;
  }
}

class Teams {
  List<Members> members;
  TeamId teamId;
  bool isWinner;
  bool winningCredited;

  Teams({this.members, this.teamId, this.isWinner, this.winningCredited});

  Teams.fromJson(Map<String, dynamic> json) {
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

  EventRegistration(
      {this.id,
        this.userId,
        this.eventId,
        this.isWinner,
        this.winningCredited,
        this.rounds,
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
    data['teamId'] = this.teamId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Rounds {
  String roundId;
  String lobbyId;
  Null slot;
  bool isWinner;
  Null gmngRank;
  Null gmngTeamRank;
  Null result;
  String sId;

  Rounds(
      {this.roundId,
        this.lobbyId,
        this.slot,
        this.isWinner,
        this.gmngRank,
        this.gmngTeamRank,
        this.result,
        this.sId});

  Rounds.fromJson(Map<String, dynamic> json) {
    roundId = json['roundId'];
    lobbyId = json['lobbyId'];
    slot = json['slot'];
    isWinner = json['isWinner'];
    gmngRank = json['gmngRank'];
    gmngTeamRank = json['gmngTeamRank'];
    result = json['result'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roundId'] = this.roundId;
    data['lobbyId'] = this.lobbyId;
    data['slot'] = this.slot;
    data['isWinner'] = this.isWinner;
    data['gmngRank'] = this.gmngRank;
    data['gmngTeamRank'] = this.gmngTeamRank;
    data['result'] = this.result;
    data['_id'] = this.sId;
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

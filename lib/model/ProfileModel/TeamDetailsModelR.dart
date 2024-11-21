class
TeamDetailsModelR {
  String id;
  String name;
  GameId gameId;
  TeamTypeId teamTypeId;
  List<Members> members;
  String status;
  int totalMembers;
  String createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;

  TeamDetailsModelR(
      {this.id,
      this.name,
      this.gameId,
      this.teamTypeId,
      this.members,
      this.status,
      this.totalMembers,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt});

  TeamDetailsModelR.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gameId =
        json['gameId'] != null ? new GameId.fromJson(json['gameId']) : null;
    teamTypeId = json['teamTypeId'] != null
        ? new TeamTypeId.fromJson(json['teamTypeId'])
        : null;
    if (json['members'] != null) {
      members = new List<Members>();
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
    status = json['status'];
    totalMembers = json['totalMembers'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.gameId != null) {
      data['gameId'] = this.gameId.toJson();
    }
    if (this.teamTypeId != null) {
      data['teamTypeId'] = this.teamTypeId.toJson();
    }
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['totalMembers'] = this.totalMembers;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
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

class Members {
  String id;
  UserId userId;
  String name;
  String mobileNumber;
  bool isCaptain;
  String status;


  Members(
      {this.id,
        this.userId,
        this.name,
        this.mobileNumber,
        this.isCaptain,

        this.status});

  Members.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId =
    json['userId'] != null ? new UserId.fromJson(json['userId']) : null;

    name = json['name'];
    mobileNumber = json['mobileNumber'];
    isCaptain = json['isCaptain'];
    status = json['status'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.userId != null) {
      data['userId'] = this.userId.toJson();
    }



    data['name'] = this.name;
    data['mobileNumber'] = this.mobileNumber;
    data['isCaptain'] = this.isCaptain;
    data['status'] = this.status;
    return data;
  }
}





class UserId {
  String id;
  Name name;
  String username;
  Photo photo;
  UserId({this.id, this.name, this.username,this.photo});

  UserId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    username = json['username'];
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.photo != null) {
      data['photo'] = this.photo.toJson();
    }
    data['username'] = this.username;
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


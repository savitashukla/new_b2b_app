class TamashaEventListD {
  List<Data> data;
  Pagination pagination;

  TamashaEventListD({this.data, this.pagination});

  TamashaEventListD.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  String id;
  String contestId;
  String startDate;
  String contestName;
  String endDate;
  String gameId;
  EntryFee entryFee;
  String entryFeeType;
  String contestImage;
  String contestStatus;
  String contestType;
  String masterContestIcon;
  Reward reward;
  bool createdByTamasha;
  double winningPercentage;
  int tableSize;
  int bonusPercentage;
  bool isAutomated;
  Null workSpaceId;
  Null workSpaceChannelId;
  bool isTournament;
  bool isRegistered;
  int totalRegisteredPlayers;
  String notifyCount;
  int onlinePlayers;
  Null workSpaceChannelCategory;
  bool ludoNew;
  bool lootBoxEvent;

  Data(
      {this.contestId,
      this.startDate,
      this.contestName,
      this.endDate,
      this.gameId,
      this.entryFee,
      this.entryFeeType,
      this.contestImage,
      this.contestStatus,
      this.contestType,
      this.masterContestIcon,
      this.reward,
      this.createdByTamasha,
      this.winningPercentage,
      this.tableSize,
      this.bonusPercentage,
      this.isAutomated,
      this.workSpaceId,
      this.workSpaceChannelId,
      this.isTournament,
      this.isRegistered,
      this.totalRegisteredPlayers,
      this.notifyCount,
      this.onlinePlayers,
      this.workSpaceChannelCategory,
      this.ludoNew});

  Data.fromJson(Map<String, dynamic> json) {
    contestId = json['contestId'];
    startDate = json['startDate'];
    contestName = json['contestName'];
    endDate = json['endDate'];
    gameId = json['gameId'];
    entryFee = json['entryFee'] != null
        ? new EntryFee.fromJson(json['entryFee'])
        : null;
    entryFeeType = json['entryFeeType'];
    contestImage = json['contestImage'];
    contestStatus = json['contestStatus'];
    contestType = json['contestType'];
    masterContestIcon = json['masterContestIcon'];
    reward =
        json['reward'] != null ? new Reward.fromJson(json['reward']) : null;
    createdByTamasha = json['createdByTamasha'];
    winningPercentage = json['winningPercentage'];
    tableSize = json['tableSize'];
    bonusPercentage = json['bonusPercentage'];
    isAutomated = json['isAutomated'];
    workSpaceId = json['workSpaceId'];
    workSpaceChannelId = json['workSpaceChannelId'];
    isTournament = json['isTournament'];
    isRegistered = json['isRegistered'];
    totalRegisteredPlayers = json['totalRegisteredPlayers'];
    notifyCount = json['notifyCount'];
    onlinePlayers = json['onlinePlayers'];
    workSpaceChannelCategory = json['workSpaceChannelCategory'];
    ludoNew = json['ludoNew'];
    lootBoxEvent = json['lootBoxEvent'] != null ? json['lootBoxEvent'] : false;
    id = json['id'] != null ? json['id'] : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contestId'] = this.contestId;
    data['startDate'] = this.startDate;
    data['contestName'] = this.contestName;
    data['endDate'] = this.endDate;
    data['gameId'] = this.gameId;
    if (this.entryFee != null) {
      data['entryFee'] = this.entryFee.toJson();
    }
    data['entryFeeType'] = this.entryFeeType;
    data['contestImage'] = this.contestImage;
    data['contestStatus'] = this.contestStatus;
    data['contestType'] = this.contestType;
    data['masterContestIcon'] = this.masterContestIcon;
    if (this.reward != null) {
      data['reward'] = this.reward.toJson();
    }
    data['createdByTamasha'] = this.createdByTamasha;
    data['winningPercentage'] = this.winningPercentage;
    data['tableSize'] = this.tableSize;
    data['bonusPercentage'] = this.bonusPercentage;
    data['isAutomated'] = this.isAutomated;
    data['workSpaceId'] = this.workSpaceId;
    data['workSpaceChannelId'] = this.workSpaceChannelId;
    data['isTournament'] = this.isTournament;
    data['isRegistered'] = this.isRegistered;
    data['totalRegisteredPlayers'] = this.totalRegisteredPlayers;
    data['notifyCount'] = this.notifyCount;
    data['onlinePlayers'] = this.onlinePlayers;
    data['workSpaceChannelCategory'] = this.workSpaceChannelCategory;
    data['ludoNew'] = this.ludoNew;
    return data;
  }
}

class EntryFee {
  var value;
  String type;

  EntryFee({this.value, this.type});

  EntryFee.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
    if (value != null) {
      if (type.compareTo("currency") == 0) {
        value = value / 100;
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}

class Reward {
  EntryFee amount;
  String rewardName;

  Reward({this.amount, this.rewardName});

  Reward.fromJson(Map<String, dynamic> json) {
    amount =
        json['amount'] != null ? new EntryFee.fromJson(json['amount']) : null;
    rewardName = json['rewardName'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.amount != null) {
      data['amount'] = this.amount.toJson();
    }
    data['rewardName'] = this.rewardName;
    return data;
  }
}

class Pagination {
  int page;
  int total;
  int count;
  int offset;
  int limit;

  Pagination({this.page, this.total, this.count, this.offset, this.limit});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'] ?? 0;
    total = json['total'] ?? 0;
    count = json['count'] ?? 0;
    offset = json['offset'] ?? 0;
    limit = json['limit'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['total'] = this.total;
    data['count'] = this.count;
    data['offset'] = this.offset;
    data['limit'] = this.limit;
    return data;
  }
}

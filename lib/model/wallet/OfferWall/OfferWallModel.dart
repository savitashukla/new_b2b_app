class OfferWallModel {
  List<Data> data;
  List<Data> dataT;
  List<Data> dataP;
  List<Data> dataC;

  OfferWallModel({this.data});

  OfferWallModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      dataT = new List<Data>();
      dataP = new List<Data>();
      json['data'].forEach((v) {
        print("offer data check");
        print(v);
        if (v["userDeal"] != null) {
          if (v["userDeal"]['status'] == 'pending') {
            dataP.add(new Data.fromJson(v));
          } else {
            dataT.add(new Data.fromJson(v));
          }
        } else {
          dataT.add(new Data.fromJson(v));
        }
      });

      data.addAll(dataP);
      data.addAll(dataT);
    }
  }
}

class Data {
  String id;
  String advertiserId;
  String name;
  String description;
  String details;
  String terms;
  String buttonText;
  String logoUrl;
  String activeFromDate;
  String activeToDate;
  int startTime;
  int endTime;
  int dealTimeoutMinutes;
  GmngEarning gmngEarning;
  GmngEarning userEarning;
  Limits limits;
  Stats stats;
  String url;
  int order;
  String status;
  String createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;
  UserDeal userDeal;
  Banner banner;
  AppPackage appPackage;

  Data(
      {this.id,
      this.advertiserId,
      this.name,
      this.description,
      this.details,
      this.terms,
      this.buttonText,
      this.logoUrl,
      this.activeFromDate,
      this.activeToDate,
      this.startTime,
      this.endTime,
      this.dealTimeoutMinutes,
      this.gmngEarning,
      this.userEarning,
      this.limits,
      this.stats,
      this.url,
      this.order,
      this.status,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.userDeal,
      this.banner,
      this.appPackage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    advertiserId = json['advertiserId'];
    name = json['name'];
    description = json['description'];
    details = json['details'];
    terms = json['terms'];
    buttonText = json['buttonText'];
    logoUrl = json['logoUrl'];
    activeFromDate = json['activeFromDate'];
    activeToDate = json['activeToDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    dealTimeoutMinutes = json['dealTimeoutMinutes'];
    gmngEarning = json['gmngEarning'] != null
        ? new GmngEarning.fromJson(json['gmngEarning'])
        : null;
    userEarning = json['userEarning'] != null
        ? new GmngEarning.fromJson(json['userEarning'])
        : null;
    limits =
        json['limits'] != null ? new Limits.fromJson(json['limits']) : null;
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
    url = json['url'];
    order = json['order'];
    status = json['status'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userDeal = json['userDeal'] != null
        ? new UserDeal.fromJson(json['userDeal'])
        : null;
    banner =
        json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    appPackage = json['appPackage'] != null
        ? new AppPackage.fromJson(json['appPackage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['advertiserId'] = this.advertiserId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['details'] = this.details;
    data['terms'] = this.terms;
    data['buttonText'] = this.buttonText;
    data['logoUrl'] = this.logoUrl;
    data['activeFromDate'] = this.activeFromDate;
    data['activeToDate'] = this.activeToDate;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['dealTimeoutMinutes'] = this.dealTimeoutMinutes;
    if (this.gmngEarning != null) {
      data['gmngEarning'] = this.gmngEarning.toJson();
    }
    if (this.userEarning != null) {
      data['userEarning'] = this.userEarning.toJson();
    }
    if (this.limits != null) {
      data['limits'] = this.limits.toJson();
    }
    if (this.stats != null) {
      data['stats'] = this.stats.toJson();
    }
    data['url'] = this.url;
    data['order'] = this.order;
    data['status'] = this.status;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.userDeal != null) {
      data['userDeal'] = this.userDeal.toJson();
    }
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    if (this.appPackage != null) {
      data['appPackage'] = this.appPackage.toJson();
    }
    return data;
  }
}

class GmngEarning {
  int value;
  String type;
  String currency;

  GmngEarning({this.value, this.type, this.currency});

  GmngEarning.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
    data['currency'] = this.currency;
    return data;
  }
}

class Limits {
  int total;
  int daily;

  Limits({this.total, this.daily});

  Limits.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    daily = json['daily'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['daily'] = this.daily;
    return data;
  }
}

class Stats {
  int entryCount;
  int uniqueEntryCount;
  int usesCount;
  GmngEarning totalGmngEarning;
  GmngEarning totalUserEarning;

  Stats(
      {this.entryCount,
      this.uniqueEntryCount,
      this.usesCount,
      this.totalGmngEarning,
      this.totalUserEarning});

  Stats.fromJson(Map<String, dynamic> json) {
    entryCount = json['entryCount'];
    uniqueEntryCount = json['uniqueEntryCount'];
    usesCount = json['usesCount'];
    totalGmngEarning = json['totalGmngEarning'] != null
        ? new GmngEarning.fromJson(json['totalGmngEarning'])
        : null;
    totalUserEarning = json['totalUserEarning'] != null
        ? new GmngEarning.fromJson(json['totalUserEarning'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entryCount'] = this.entryCount;
    data['uniqueEntryCount'] = this.uniqueEntryCount;
    data['usesCount'] = this.usesCount;
    if (this.totalGmngEarning != null) {
      data['totalGmngEarning'] = this.totalGmngEarning.toJson();
    }
    if (this.totalUserEarning != null) {
      data['totalUserEarning'] = this.totalUserEarning.toJson();
    }
    return data;
  }
}

class UserDeal {
  String id;
  String advertiserDealId;
  String userId;
  GmngEarning gmngEarning;
  GmngEarning userEarning;
  Null userTransactionId;
  Null gmngTransactionId;
  Null callbackData;
  String dealDate;
  String expireDate;
  String status;
  String createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;

  UserDeal(
      {this.id,
      this.advertiserDealId,
      this.userId,
      this.gmngEarning,
      this.userEarning,
      this.userTransactionId,
      this.gmngTransactionId,
      this.callbackData,
      this.dealDate,
      this.expireDate,
      this.status,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt});

  UserDeal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    advertiserDealId = json['advertiserDealId'];
    userId = json['userId'];
    gmngEarning = json['gmngEarning'] != null
        ? new GmngEarning.fromJson(json['gmngEarning'])
        : null;
    userEarning = json['userEarning'] != null
        ? new GmngEarning.fromJson(json['userEarning'])
        : null;
    userTransactionId = json['userTransactionId'];
    gmngTransactionId = json['gmngTransactionId'];
    callbackData = json['callbackData'];
    dealDate = json['dealDate'];
    expireDate = json['expireDate'];
    status = json['status'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['advertiserDealId'] = this.advertiserDealId;
    data['userId'] = this.userId;
    if (this.gmngEarning != null) {
      data['gmngEarning'] = this.gmngEarning.toJson();
    }
    if (this.userEarning != null) {
      data['userEarning'] = this.userEarning.toJson();
    }
    data['userTransactionId'] = this.userTransactionId;
    data['gmngTransactionId'] = this.gmngTransactionId;
    data['callbackData'] = this.callbackData;
    data['dealDate'] = this.dealDate;
    data['expireDate'] = this.expireDate;
    data['status'] = this.status;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Banner {
  String id;
  String url;

  Banner({this.id, this.url});

  Banner.fromJson(Map<String, dynamic> json) {
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

class AppPackage {
  String android;
  String iOS;

  AppPackage({this.android, this.iOS});

  AppPackage.fromJson(Map<String, dynamic> json) {
    android = json['android'];
    iOS = json['iOS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['android'] = this.android;
    data['iOS'] = this.iOS;
    return data;
  }
}

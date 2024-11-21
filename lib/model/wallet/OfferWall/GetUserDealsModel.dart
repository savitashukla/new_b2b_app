import 'package:gmng/utills/Utils.dart';

class GetUserDealsModel {
  List<Data> data;
  List<Data> data_all;
  List<Data> data_allC;

  GetUserDealsModel({this.data});

  GetUserDealsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data_all = <Data>[];
      data = <Data>[];
      data_allC = <Data>[];
      json['data'].forEach((v) {
        if (v['status'] == 'completed') {
          data_allC.add(new Data.fromJson(v));
        } else if (v['status'] == 'rejected') {
          data_all.add(new Data.fromJson(v));
          //removing duplicates adverserDealId
          final ids = data_all.map((e) => e.advertiserDealId.id).toSet();
          data_all.retainWhere((x) => ids.remove(x.advertiserDealId.id));
        }
      });

      data.addAll(data_allC);
      data.addAll(data_all);

      data.sort((a, b) {
        //sorting in descending order
        //  data.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        return DateTime.parse(b.updatedAt)
            .compareTo(DateTime.parse(a.updatedAt));
      });
      //Utils().customPrint('contains ELSE ${dataNew.length}');
      Utils().customPrint('contains ELSE ${data.length}');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  AdvertiserDealId advertiserDealId;
  String userId;
  GmngEarning gmngEarning;
  GmngEarning userEarning;
  String userTransactionId;
  String gmngTransactionId;

  //CallbackData callbackData;
  String dealDate;
  String expireDate;
  String status;
  String createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;
  bool canChangeStatus;
  bool isViewed;

  Data(
      {this.id,
      this.advertiserDealId,
      this.userId,
      this.gmngEarning,
      this.userEarning,
      this.userTransactionId,
      this.gmngTransactionId,
      //this.callbackData,
      this.dealDate,
      this.expireDate,
      this.status,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.canChangeStatus,
      this.isViewed

      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    advertiserDealId = json['advertiserDealId'] != null
        ? new AdvertiserDealId.fromJson(json['advertiserDealId'])
        : null;
    userId = json['userId'];
    gmngEarning = json['gmngEarning'] != null
        ? new GmngEarning.fromJson(json['gmngEarning'])
        : null;
    userEarning = json['userEarning'] != null
        ? new GmngEarning.fromJson(json['userEarning'])
        : null;
    userTransactionId = json['userTransactionId'];
    gmngTransactionId = json['gmngTransactionId'];
    /* callbackData = json['callbackData'] != null
        ? new CallbackData.fromJson(json['callbackData'])
        : null;*/
    dealDate = json['dealDate'];
    expireDate = json['expireDate'];
    status = json['status'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    canChangeStatus = json['canChangeStatus'];
    isViewed = json['isViewed'];

    if(isViewed==false)
    {
      Utils().showOfferWaleFeedBack(userEarning.value);
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.advertiserDealId != null) {
      data['advertiserDealId'] = this.advertiserDealId.toJson();
    }
    data['userId'] = this.userId;
    if (this.gmngEarning != null) {
      data['gmngEarning'] = this.gmngEarning.toJson();
    }
    if (this.userEarning != null) {
      data['userEarning'] = this.userEarning.toJson();
    }
    data['userTransactionId'] = this.userTransactionId;
    data['gmngTransactionId'] = this.gmngTransactionId;
    /*if (this.callbackData != null) {
      data['callbackData'] = this.callbackData.toJson();
    }*/
    data['dealDate'] = this.dealDate;
    data['expireDate'] = this.expireDate;
    data['status'] = this.status;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['canChangeStatus'] = this.canChangeStatus;
    data['isViewed'] = this.isViewed;
    return data;
  }




}

class AdvertiserDealId {
  String id;
  String advertiserId;
  String name;
  String description;
  String details;
  String terms;
  String buttonText;
  String logoUrl;
  Banner banner;
  String activeFromDate;
  String activeToDate;
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
  int endTime;
  int startTime;
  Banner logo;

  AdvertiserDealId(
      {this.id,
      this.advertiserId,
      this.name,
      this.description,
      this.details,
      this.terms,
      this.buttonText,
      this.logoUrl,
      this.banner,
      this.activeFromDate,
      this.activeToDate,
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
      this.endTime,
      this.startTime,
      this.logo});

  AdvertiserDealId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    advertiserId = json['advertiserId'];
    name = json['name'];
    description = json['description'];
    details = json['details'];
    terms = json['terms'];
    buttonText = json['buttonText'];
    logoUrl = json['logoUrl'];
    banner =
        json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
    activeFromDate = json['activeFromDate'];
    activeToDate = json['activeToDate'];
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
    endTime = json['endTime'];
    startTime = json['startTime'];
    logo = json['logo'] != null ? new Banner.fromJson(json['logo']) : null;
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
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    data['activeFromDate'] = this.activeFromDate;
    data['activeToDate'] = this.activeToDate;
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
    data['endTime'] = this.endTime;
    data['startTime'] = this.startTime;
    if (this.logo != null) {
      data['logo'] = this.logo.toJson();
    }
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

class CallbackData {
  Params params;
  String date;
  bool isAdminAction;

  CallbackData({this.params, this.date, this.isAdminAction});

  CallbackData.fromJson(Map<String, dynamic> json) {
    params =
        json['params'] != null ? new Params.fromJson(json['params']) : null;
    date = json['date'];
    isAdminAction = json['isAdminAction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.params != null) {
      data['params'] = this.params.toJson();
    }
    data['date'] = this.date;
    data['isAdminAction'] = this.isAdminAction;
    return data;
  }
}

class Params {
  String udId;
  Null adId;
  String s;
  Null m;

  Params({this.udId, this.adId, this.s, this.m});

  Params.fromJson(Map<String, dynamic> json) {
    udId = json['udId'];
    adId = json['adId'];
    s = json['s'];
    m = json['m'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['udId'] = this.udId;
    data['adId'] = this.adId;
    data['s'] = this.s;
    data['m'] = this.m;
    return data;
  }
}
